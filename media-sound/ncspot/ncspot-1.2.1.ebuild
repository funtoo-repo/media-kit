# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/189298b256f42db33c17a8b2cb1da87ad8225ea1 -> ncspot-1.2.1-189298b.tar.gz
https://direct-github.funmore.org/e6/2e/f9/e62ef9e9ef0749fb81ab6f49516139d68fbe4b1216dc81c77d1032cade3af89a4d72f5f426d7a6cfa8f1f1e8ff135a692c6b4b13f5d08e85ee3010d2d5badda8 -> ncspot-1.2.1-funtoo-crates-bundle-fcf4d90aef4a9c18096c101a785ed9b1b5ffd29887f0b0a05c1bcf2d172576eaf797c40f85563d46516f493b96f53df84e5e339d24a883b8a172a71f14171b65.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND=""
BDEPEND="virtual/rust"

DOCS=( README.md CHANGELOG.md )

QA_FLAGS_IGNORED="/usr/bin/ncspot"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/hrkfdn-ncspot-* ${S} || die
}