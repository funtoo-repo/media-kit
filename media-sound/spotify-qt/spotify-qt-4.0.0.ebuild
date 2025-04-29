# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Lightweight Spotify client using Qt"
HOMEPAGE="https://github.com/kraxarn/spotify-qt"
SRC_URI="https://github.com/kraxarn/spotify-qt/tarball/47ef2ca2e1101f53b108887952aab82f2d9fac59 -> spotify-qt-4.0.0-47ef2ca.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}/kraxarn-spotify-qt-47ef2ca"

RDEPEND="
  dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

src_prepare() {
  cmake_src_prepare
}