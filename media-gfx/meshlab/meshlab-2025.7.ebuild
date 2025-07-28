# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

S="${WORKDIR}"/${P}/src

DESCRIPTION=""
HOMEPAGE="http://www.meshlab.net"
SRC_URI="
	https://github.com/cnr-isti-vclab/meshlab/tarball/dc48b91ae562756a6988048c5d5c7f1d2b687256 -> meshlab-2025.07-dc48b91.tar.gz
	https://github.com/cnr-isti-vclab/vcglib/tarball/c94ef4e12e9ea3ae986d9af91005be8328d13719 -> vcglib-2025.07-c94ef4e.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="double-precision minimal"

DEPEND="
	dev-libs/xerces-c
	dev-libs/gmp:=
	>=dev-qt/qtcore-5.12:5
	>=dev-qt/qtdeclarative-5.12:5
	>=dev-qt/qtopengl-5.12:5
	>=dev-qt/qtscript-5.12:5
	>=dev-qt/qtxml-5.12:5
	>=dev-qt/qtxmlpatterns-5.12:5
	sci-mathematics/cgal"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/meshlab-2020.12-disable-updates.patch"
	"${FILESDIR}/meshlab-2021.10-find-plugins.patch"
)

post_src_unpack() {
	cd "${WORKDIR}"
	if [ ! -d "${S}" ]; then
		mv cnr-isti-vclab-meshlab-* "${P}" || die
	fi
	mv cnr-isti-vclab-vcglib-*/* "${P}"/src/vcglib/ || die
}

src_configure() {
	CMAKE_BUILD_TYPE=Release

	local mycmakeargs=(
		-DBUILD_WITH_DOUBLE_SCALAR=$(usex double-precision)
		-Wno-dev
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}