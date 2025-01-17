# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake

DESCRIPTION="A software implementation of the OpenAL 3D audio API"
HOMEPAGE="https://www.openal-soft.org/"
SRC_URI="https://github.com/kcat/openal-soft/tarball/b621b5fce739525418f36e0474a46f9e1cab5e64 -> openal-soft-1.24.2-b621b5f.tar.gz"

# See https://github.com/kcat/openal-soft/blob/e0097c18b82d5da37248c4823fde48b6e0002cdd/BSD-3Clause
# Some components are under BSD
LICENSE="LGPL-2+ BSD"
SLOT="0"
KEYWORDS="*"
IUSE="
	alsa coreaudio debug jack oss portaudio pulseaudio sdl sndio qt5
	cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse4_1
	cpu_flags_arm_neon
"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
	portaudio? ( media-libs/portaudio )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	sdl? ( media-libs/libsdl2 )
	sndio? ( media-sound/sndio:= )
"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )"

DOCS=( alsoftrc.sample docs/env-vars.txt docs/hrtf.txt ChangeLog README.md )

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/kcat-openal-soft-* "${S}"
}

src_configure() {
# -DEXAMPLES=OFF to avoid FFmpeg dependency wrt #481670
	local mycmakeargs=(
		-DALSOFT_REQUIRE_ALSA=$(usex alsa)
		-DALSOFT_REQUIRE_COREAUDIO=$(usex coreaudio)
		-DALSOFT_REQUIRE_JACK=$(usex jack)
		-DALSOFT_REQUIRE_OSS=$(usex oss)
		-DALSOFT_REQUIRE_PORTAUDIO=$(usex portaudio)
		-DALSOFT_REQUIRE_PULSEAUDIO=$(usex pulseaudio)
		-DALSOFT_REQUIRE_SDL2=$(usex sdl)
		# See bug #809314 for getting both options for sndio
		-DALSOFT_{BACKEND,REQUIRE}_SNDIO=$(usex sndio)
		-DALSOFT_UTILS=ON
		-DALSOFT_NO_CONFIG_UTIL=$(usex qt5 OFF ON)
		-DALSOFT_EXAMPLES=OFF
	)

	# Avoid unused variable warnings, bug #738240
	if use amd64 || use x86 ; then
		mycmakeargs+=(
			-DALSOFT_CPUEXT_SSE=$(usex cpu_flags_x86_sse)
			-DALSOFT_CPUEXT_SSE2=$(usex cpu_flags_x86_sse2)
			-DALSOFT_CPUEXT_SSE4_1=$(usex cpu_flags_x86_sse4_1)
		)
	fi

	if use arm || use arm64 ; then
		mycmakeargs+=(
			-DALSOFT_CPUEXT_NEON=$(usex cpu_flags_arm_neon)
		)
	fi
	cmake_src_configure
}