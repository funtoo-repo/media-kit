# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A spotify daemon"
HOMEPAGE="https://github.com/Spotifyd/spotifyd"
SRC_URI="https://github.com/Spotifyd/spotifyd/tarball/03c3da68cd047f8cae4e007d5fa36b0d4864701a -> spotifyd-0.4.1-03c3da6.tar.gz
https://direct-github.funmore.org/bd/af/00/bdaf0037777ce01133e83433a9cc5141eb09a5f53e1662bbc8bb941d08aff8cfc87933fde32e4248792fdc6a78d6481fd55b493cb34d0d4d5e5b475f4cedbcc4 -> spotifyd-0.4.1-funtoo-crates-bundle-a42f807916b7310605072bec3d34abfa2c62c9a07f011e9881cd59e9791cbb4e8c6a8ee82dd7270c09f430f328f9fa38aefa4f3b4c220dfda3e734032aa3c854.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 GPL-3 ISC MIT MPL-2.0 ZLIB"
KEYWORDS="*"
SLOT="0"
IUSE="+alsa dbus portaudio pulseaudio rodio"
REQUIRED_USE="|| ( alsa portaudio pulseaudio rodio ) rodio? ( alsa )"

RDEPEND="
	dev-libs/openssl:0=
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( {CHANGELOG,README}.md )

QA_FLAGS_IGNORED="usr/bin/spotifyd"

post_src_unpack() {
	rm -rf "${S}"
	mv "${WORKDIR}"/Spotifyd-spotifyd-* "${S}" || die
}

src_configure() {
	myfeatures=(
		"$(usex alsa alsa_backend '')"
		"$(usex dbus "dbus_keyring dbus_mpris" '')"
		"$(usex portaudio portaudio_backend '')"
		"$(usex pulseaudio pulseaudio_backend '')"
		"$(usex rodio rodio_backend '')"
	)
}

src_install() {
	einstalldocs

	insinto /etc
	doins "${FILESDIR}"/spotifyd.conf

	cargo_src_install ${myfeatures:+--features "${myfeatures[*]}"} --no-default-features
}