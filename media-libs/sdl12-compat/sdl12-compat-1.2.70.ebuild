# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Simple Direct Media Layer 1.2 compatibility wrapper around SDL2"
HOMEPAGE="https://github.com/libsdl-org/sdl12-compat"
SRC_URI="https://github.com/libsdl-org/sdl12-compat/tarball/9fb466ec58119d12bd2bce47e8810cb282104bd8 -> sdl12-compat-1.2.70-9fb466e.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="*"

# IUSE dropped from real SDL1: aalib custom-cflags dga fbcon libcaca nas oss pulseaudio static-libs tslib xinerama xv
IUSE="alsa +joystick opengl +sound test +video X"
REQUIRED_USE="test? ( joystick opengl sound video )"

# The tests are more like example programs.
RESTRICT="test"

RDEPEND="
	media-libs/libsdl2[alsa=,joystick=,opengl=,sound=,video=,X=]
	!media-libs/libsdl
"

DEPEND="
	${RDEPEND}
	test? ( virtual/opengl )
"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/* "${S}" || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DSDL12TESTS=$(usex test)
	)

	cmake_src_configure
}