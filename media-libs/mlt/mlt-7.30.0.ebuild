# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit python-single-r1 cmake toolchain-funcs

DESCRIPTION="Open source multimedia framework for television broadcasting"
HOMEPAGE="https://www.mltframework.org/"
SRC_URI="https://github.com/mltframework/mlt/releases/download/v7.30.0/mlt-7.30.0.tar.gz -> mlt-7.30.0.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="debug ffmpeg frei0r gtk jack kernel_linux libsamplerate opencv opengl python qt5 rtaudio rubberband sdl vdpau vidstab xine xml"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	media-libs/libebur128:=
	ffmpeg? ( media-video/ffmpeg:0=[vdpau?,-flite] )
	frei0r? ( media-plugins/frei0r-plugins )
	gtk? (
		media-libs/libexif
		x11-libs/pango
	)
	jack? (
		dev-libs/libxml2
		media-libs/ladspa-sdk
		virtual/jack
	)
	libsamplerate? ( media-libs/libsamplerate )
	opencv? ( media-libs/opencv[contrib] )
	opengl? (
		media-libs/libglvnd
		media-video/movit
	)
	python? ( ${PYTHON_DEPS} )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		media-libs/libexif
		sci-libs/fftw:3.0=
		x11-libs/libX11
	)
	rtaudio? (
		media-libs/rtaudio
		kernel_linux? ( media-libs/alsa-lib )
	)
	rubberband? ( media-libs/rubberband )
	sdl? (
		media-libs/libsdl2[X,opengl,video]
		media-libs/sdl2-image
	)
	vidstab? ( media-libs/vidstab )
	xine? ( media-libs/xine-lib )
	xml? ( dev-libs/libxml2 )
"

RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	python? ( dev-lang/swig )
"

DOCS=( AUTHORS NEWS README.md )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# respect CFLAGS LDFLAGS when building shared libraries. Bug #308873
	if use python; then
		sed -i "/mlt.so/s/ -lmlt++ /& ${CFLAGS} ${LDFLAGS} /" src/swig/python/build || die
		python_fix_shebang src/swig/python
	fi

	# Swig underlinking
	sed -i \
		-e "s|-L\.\.\/\.\.\/framework -lmlt||g" \
		src/swig/ruby/build

	# No lua bdepend
	sed -i \
		-e 's|which lua 2> \/dev\/null|\/bin\/true|g' \
		src/swig/lua/build

	# CMake symlink
	sed -i \
		-e 's|\${CMAKE_INSTALL_FULL_MANDIR}|\\$ENV\\{DESTDIR\\}&|g' \
		CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DGPL=ON
		-DGPL3=ON
		-DMOD_KDENLIVE=ON
		-DMOD_SDL1=OFF
		-DMOD_SDL2=$(usex sdl)
		-DMOD_AVFORMAT=$(usex ffmpeg)
		# TODO: does anything need plus?
		# plus or qt
		#$(use_enable fftw plus)
		-DMOD_FREI0R=$(usex frei0r)
		-DMOD_GDK=$(usex gtk)
		-DMOD_JACKRACK=$(usex jack)
		-DMOD_RESAMPLE=$(usex libsamplerate)
		-DMOD_OPENCV=$(usex opencv)
		-DMOD_MOVIT=$(usex opengl)
		-DMOD_QT=$(usex qt5)
		-DMOD_RTAUDIO=$(usex rtaudio)
		-DMOD_RUBBERBAND=$(usex rubberband)
		-DMOD_VIDSTAB=$(usex vidstab)
		-DMOD_XINE=$(usex xine)
		-DMOD_XML=$(usex xml)
		-DMOD_SOX=OFF
	)

	# TODO: We currently have USE=fftw but both Qt and plus require it, removing flag for now.
	# TODO: rework upstream CMake to allow controlling MMX/SSE/SSE2
	# TODO: add swig language bindings?
	# see also https://www.mltframework.org/twiki/bin/view/MLT/ExtremeMakeover

	if use python; then
		mycmakeargs+=( -DSWIG_PYTHON=ON )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/${PN}
	doins -r demo

	#
	# Install SWIG bindings
	#

	docinto swig

	if use python; then
		dodoc "${S}"/src/swig/python/play.py
		python_optimize
	fi
}