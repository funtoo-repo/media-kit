# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Open framework for storing and sharing scene data"
HOMEPAGE="https://www.alembic.io/"
SRC_URI="https://api.github.com/repos/alembic/alembic/tarball/1.8.8 -> alembic-1.8.8.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="*"
# imath needs to be keyworded for arm{,64} to re-add
# python / pyalembic support
IUSE="examples hdf5 test"
RESTRICT="!test? ( test )"

RDEPEND="
    >=dev-libs/imath-3.0.1
	hdf5? (
		>=sci-libs/hdf5-1.10.2:=[zlib(+)]
		>=sys-libs/zlib-1.2.11-r1
	)
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.8.0-0001-set-correct-libdir.patch" )

DOCS=( ACKNOWLEDGEMENTS.txt FEEDBACK.txt NEWS.txt README.txt )

src_unpack() {
	default
	rm -rf ${S}
	mv "${WORKDIR}"/alembic-alembic-* "${S}" || die
}

src_configure() {
	local mycmakeargs=(
		-DALEMBIC_BUILD_LIBS=ON
		-DALEMBIC_SHARED_LIBS=ON
		# currently does nothing but require doxygen
		-DDOCS_PATH=OFF
		-DUSE_ARNOLD=OFF
		-DUSE_BINARIES=ON
		-DUSE_EXAMPLES=$(usex examples)
		-DUSE_HDF5=$(usex hdf5)
		-DUSE_MAYA=OFF
		-DUSE_PRMAN=OFF
		# TODO: needs imath keyworded for arm{,64}
		-DUSE_PYALEMBIC=OFF
		-DUSE_TESTS=$(usex test)
	)

	cmake_src_configure
}