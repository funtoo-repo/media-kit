# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="SANE backend for AirScan (eSCL) and WSD document scanners"
HOMEPAGE="https://github.com/alexpevzner/sane-airscan"
SRC_URI="https://github.com/alexpevzner/sane-airscan/tarball/6e5222c32133793f2e06bf9caa0d36d39f8ef254 -> sane-airscan-0.99.34-6e5222c.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

DEPEND="
	net-dns/avahi
	net-libs/gnutls
	dev-libs/libxml2
	virtual/jpeg
	media-libs/libpng
"
RDEPEND="${DEPEND}
	media-gfx/sane-backends
"

PATCHES=( "${FILESDIR}/${PN}-0.99.27-makefile-fixes.patch" )

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv alexpevzner-sane-airscan* "${S}" || die
	fi
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" COMPRESS= STRIP= install
}