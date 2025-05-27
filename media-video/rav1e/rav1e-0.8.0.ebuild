# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="The fastest and safest AV1 encoder."
HOMEPAGE="https://github.com/xiph/rav1e"
SRC_URI="https://github.com/xiph/rav1e/tarball/1fd67cd1b4a39f69303f28ed27c5d2d3833110c4 -> rav1e-0.8.0-1fd67cd.tar.gz
https://direct-github.funmore.org/64/a7/3f/64a73f9496b5c0e9584a5e002ed52acdc17377b7726831717f492a2f9f7c420f4d18fe5bc3850bd1476182a17797377161b6ac8a64cab09f14632ebc80605c99 -> rav1e-0.8.0-funtoo-crates-bundle-f6264f9d321b338740c9edb76f49e4beb00b1622540642e27bc5b52665b79e76310332007b8543c5704a6e793374fb24a36f0f45d078ff650afccc3899459ace.tar.gz"

RESTRICT=""
LICENSE="BSD-2 Apache-2.0 MIT Unlicense"
SLOT="0"
KEYWORDS="*"
IUSE="+capi"

ASM_DEP=">=dev-lang/nasm-2.15"
BDEPEND="
	amd64? ( ${ASM_DEP} )
	capi? ( dev-util/cargo-c )
"

src_unpack() {
	default
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/xiph-rav1e-* ${S} || die
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"
	local args=$(usex debug "" --release)

	RUSTFLAGS="-C target-cpu=native" cargo build ${args} \
		|| die "cargo build failed"

	if use capi; then
		RUSTFLAGS="-C target-cpu=native" cargo cbuild ${args} --target-dir="capi" \
			--prefix="/usr" --libdir="/usr/$(get_libdir)" \
			|| die "cargo cbuild failed"
	fi
}

src_install() {
	export CARGO_HOME="${ECARGO_HOME}"
	local args=$(usex debug --debug "")

	if use capi; then
		cargo cinstall $args --target-dir="capi" \
			--prefix="/usr" --libdir="/usr/$(get_libdir)" --destdir="${ED%/}" \
			|| die "cargo cinstall failed"
	fi

	cargo_src_install
}