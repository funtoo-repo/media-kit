# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Support for TrueType fonts in SDL applications."
HOMEPAGE="https://www.libsdl.org/projects/SDL_ttf/"
SRC_URI="https://github.com/libsdl-org/SDL_ttf/tarball/2a891473eaf05ba1707a4b7913e6c4db7de7458a -> SDL_ttf-2.24.0-2a89147.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="*"
IUSE="+harfbuzz static-libs X"

# On bumps, check external/ for versions of bundled freetype + harfbuzz
# to crank up the dep bounds.
RDEPEND=">=media-libs/libsdl2-2.0.12
	>=media-libs/freetype-2.10.4[harfbuzz?]
	virtual/opengl
	harfbuzz? ( >=media-libs/harfbuzz-2.8.0 )"
DEPEND="${RDEPEND}"

post_src_unpack() {
	if [ ! -d "${S}" ] ; then
		mv ${WORKDIR}/libsdl-org-SDL_ttf* ${S} || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DSDL2TTF_VENDORED=OFF
		-DSDL2TTF_HARFBUZZ=$(usex harfbuzz)
	)

	cmake_src_configure
}

src_install() {
	dodoc {CHANGES,README}.txt

	cmake_src_install
}