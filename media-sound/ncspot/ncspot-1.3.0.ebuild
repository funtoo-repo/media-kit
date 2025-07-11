# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/7c74e4d2f7a41189ea7bd829ef5fc17abaf0daaf -> ncspot-1.3.0-7c74e4d.tar.gz
https://direct-github.funmore.org/b4/11/07/b41107fc91e0c7762b6b6ca917dcb90aa26350f9054eec98c7a60d0ca19233fa788e2b487c1250f92d9d63593e1b7fb6a61b451dd709f95f56b58994e57d2868 -> ncspot-1.3.0-funtoo-crates-bundle-5e68d4c7d18847098ad8188d09304671aabe9b4f37e6cb9040e89c4705deedb69dcaad170d98220916683066751208ea6dca32ae507a9aead7918b1b18a78f43.tar.gz"

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