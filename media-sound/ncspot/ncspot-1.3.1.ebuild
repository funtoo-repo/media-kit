# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/55d00c6ab768a7b5a1c74840c2b7e1e77270fadd -> ncspot-1.3.1-55d00c6.tar.gz
https://direct-github.funmore.org/fa/97/d2/fa97d29df3a10eee436e4c678499c8afa6ced3e6167dcd2da91edd386dd4e2a38201d0a9cab1ecce272de88676f257900953f872c38ae6cc95063b1beabe08a2 -> ncspot-1.3.1-funtoo-crates-bundle-43b579b134ece9b72314c67e8226d80db8d530f22527ec6f0c573ef4ab150059287c8e47e879cd373f81fa2ddd7821b61c98c75dc10901ce5c10f631debaebee.tar.gz"

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