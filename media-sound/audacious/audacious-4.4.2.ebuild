# Distributed under the terms of the GNU General Public License v2
EAPI=7

MY_P="${P/_/-}"


inherit xdg autotools

DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"
SRC_URI="https://github.com/audacious-media-player/audacious/tarball/76fde78f91e475111f211b6303f80d216a2ec37a -> audacious-4.4.2-76fde78.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="*"
IUSE="nls"

BDEPEND="
	virtual/pkgconfig
	nls? ( dev-util/intltool )
"
DEPEND="
	>=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.28
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=x11-libs/cairo-1.2.6
	>=x11-libs/pango-1.8.0
	virtual/freedesktop-icon-theme
"
RDEPEND="${DEPEND}"
PDEPEND="~media-plugins/audacious-plugins-${PV}"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}/"audacious-media-player-audacious* "${S}" || die
	fi
}

src_prepare() {
	default
	if ! use nls; then
		sed -e "/SUBDIRS/s/ po//" -i Makefile || die # bug #512698
	fi
	sed -i -e 's/SingleMainWindow/X-SingleMainWindow/g' "${S}"/audacious.desktop || die
    eautoreconf
}

src_configure() {
	# D-Bus is a mandatory dependency, remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	local myeconfargs=(
		--disable-valgrind
		--disable-libarchive
		--disable-gtk
		--enable-dbus
		--enable-qt5
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}
