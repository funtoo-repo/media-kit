# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A spotify daemon"
HOMEPAGE="https://github.com/Spotifyd/spotifyd"
SRC_URI="https://github.com/Spotifyd/spotifyd/tarball/eda388f98486644b7f3667fc4fed9e5c0f49fcbc -> spotifyd-0.3.5-eda388f.tar.gz
https://direct-github.funmore.org/a8/48/e8/a848e862b2de4b8b3fd896a551ab78834eb5622356d179573f56b9a3e0688c097f76aa1892a8468219792ee59519f08bac520b36bb973285f5b581c362e88759 -> spotifyd-0.3.5-funtoo-crates-bundle-37a7930b79097d8d8d6469efa8af57563b7295fae35b11243cc63575df672db3f22d5f5d5fb9a727678f27addba21e03148fc673a4f3ece0c03daba228512320.tar.gz"

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