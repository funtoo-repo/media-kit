# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library to interface with IEEE 1394 cameras following the IIDC specification"
HOMEPAGE="https://sourceforge.net/projects/libdc1394/"
SRC_URI="https://netcologne.dl.sourceforge.net/project/libdc1394/libdc1394-2/2.2.7/libdc1394-2.2.7.tar.gz -> libdc1394-2.2.7.tar.gz
https://distfiles.gentoo.org/distfiles/8b/sdl.m4-20140620.tar.xz -> sdl.m4-20140620.tar.xz"
LICENSE="LGPL-2.1"

SLOT="2"
KEYWORDS="*"
IUSE="doc static-libs"

RDEPEND="
	>=sys-libs/libraw1394-2.1.0-r1
	>=virtual/libusb-1-r1:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=( "${FILESDIR}"/${PN}-2.2.1-pthread.patch )

src_prepare() {
	default
	AT_M4DIR=${WORKDIR}/aclocal eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc doxygen-html)
		$(use_enable static-libs static)
		--disable-examples
		--program-suffix=2
		--without-x # only useful for (disabled) examples
	)

	myeconfargs+=( --disable-doxygen-html )

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_compile() {
	default
	use doc && emake doc
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	default
	find "${ED}" -name '*.la' -delete || die
}