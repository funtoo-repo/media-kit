# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/456291623e9c82bc1add01682c1045265569454f -> ncspot-1.3.2-4562916.tar.gz
https://direct-github.funmore.org/7a/99/6d/7a996dc8e4efecda7a073680f2b9bf8c3527fda3b5599ccf5433273b383ebe52c2ba22445027edad5f681dec698cb1bd69675a296d3087f77da3ec84e294c895 -> ncspot-1.3.2-funtoo-crates-bundle-314cdd1f4854f3fbc64d0c42571e24f188d5ff05f5a0da521e312981956a95530d721760f4a80acece41bbc7b6e8556fec75f54d5412105335337894d9bb4164.tar.gz"

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