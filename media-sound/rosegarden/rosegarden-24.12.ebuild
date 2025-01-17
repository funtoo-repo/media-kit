# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg virtualx

DESCRIPTION="MIDI and audio sequencer and notation editor"
HOMEPAGE="https://www.rosegardenmusic.com/"
SRC_URI="https://github.com/tedfelix/rosegarden-official/tarball/20fc512ecc163cf10974db16696e05aa1dc831e0 -> rosegarden-official-24.12-20fc512.tar.gz"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="lirc"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/alsa-lib:=
	>=media-libs/dssi-1.0.0:=
	media-libs/ladspa-sdk:=
	media-libs/liblo:=
	media-libs/liblrdf:=
	media-libs/libsamplerate:=
	media-libs/libsndfile:=
	sci-libs/fftw:3.0
	sys-libs/zlib:=
	virtual/jack
	x11-libs/libSM:=
	lirc? ( app-misc/lirc:= )
"
DEPEND="${RDEPEND}
	dev-qt/qttest:5
"
post_src_unpack() {
    if [ ! -d "${S}" ] ; then
        mv ${WORKDIR}/tedfelix-* ${S} || die
    fi
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_LIRC=$(usex !lirc)
	)
	cmake_src_configure
}

src_test() {
	# bug 701682, tries to open network socket and fails.
	local myctestargs=(
		-E "(test_notationview_selection)"
	)
	virtx cmake_src_test
}