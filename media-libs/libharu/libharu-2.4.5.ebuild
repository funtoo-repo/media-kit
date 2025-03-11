# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="libharu - free PDF library"
HOMEPAGE="http://www.libharu.org/ https://github.com/libharu/libharu"
SRC_URI="https://github.com/libharu/libharu/tarball/8fe5a738541a04642885fb7a75b2b5b9c5b416fa -> libharu-2.4.5-8fe5a73.tar.gz"

LICENSE="ZLIB"
SLOT="0/${PV}"
KEYWORDS="*"

DEPEND="
	media-libs/libpng:=
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"

post_src_unpack() {
	mv ${WORKDIR}/libharu-libharu-* ${S} || die
}

src_configure() {
	local mycmakeargs=(
		-DLIBHPDF_EXAMPLES=NO # Doesn't work
		-DLIBHPDF_STATIC=NO
	)
	cmake_src_configure
}