# Distributed under the terms of the GNU General Public License v2
EAPI=7

MY_P="${P/_/-}"

inherit autotools

DESCRIPTION="Plugins for Audacious music player"
HOMEPAGE="https://audacious-media-player.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="+aac +alsa ampache bs2b cdda cue ffmpeg flac fluidsynth gme +http jack lame
	libnotify libsamplerate lirc mms modplug +mp3 nls opengl opus osd pulseaudio
	scrobbler sdl sid sndfile soxr speedpitch streamtuner vorbis wavpack X"
REQUIRED_USE="ampache? ( http ) streamtuner? ( http )"
SRC_URI="https://github.com/audacious-media-player/audacious-plugins/tarball/f6ff6b29a68582e629ac34b61405ee5e0a13efcc -> audacious-plugins-4.4.2-f6ff6b2.tar.gz"

# The following plugins REQUIRE a GUI build of audacious, because non-GUI
# builds do NOT install the libaudgui library & headers.
# Plugins without a configure option:
#   alarm
#   albumart
#   delete-files
#   ladspa
#   playlist-manager
#   search-tool
#   skins
#   vtx
# Plugins with a configure option:
#   glspectrum
#   gtkui
#   hotkey
#   notify
#   aosd
#   statusicon
BDEPEND="
	dev-util/gdbus-codegen
	virtual/pkgconfig
	nls? ( dev-util/intltool )
"
DEPEND="
	app-arch/unzip
	dev-libs/dbus-glib
	dev-libs/glib
	dev-libs/libxml2:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5
	~media-sound/audacious-${PV}
	aac? ( >=media-libs/faad2-2.7 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	ampache? ( =media-libs/ampache_browser-1* )
	bs2b? ( media-libs/libbs2b )
	cdda? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia:=
		>=media-libs/libcddb-1.2.1
	)
	cue? ( media-libs/libcue:= )
	ffmpeg? ( >=media-video/ffmpeg-0.7.3 )
	flac? (
		>=media-libs/flac-1.2.1-r1
		>=media-libs/libvorbis-1.0
	)
	fluidsynth? ( media-sound/fluidsynth:= )
	http? ( >=net-libs/neon-0.26.4 )
	jack? (
		>=media-libs/bio2jack-0.4
		virtual/jack
	)
	lame? ( media-sound/lame )
	libnotify? ( x11-libs/libnotify )
	libsamplerate? ( media-libs/libsamplerate:= )
	lirc? ( app-misc/lirc )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( >=media-sound/mpg123-1.12.1 )
	opengl? ( dev-qt/qtopengl:5 )
	opus? ( >=media-libs/opus-1.0.1 >=media-libs/opusfile-0.4 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.3 )
	scrobbler? ( net-misc/curl )
	sdl? ( media-libs/libsdl2[sound] )
	sid? ( >=media-libs/libsidplayfp-1.0.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	soxr? ( media-libs/soxr )
	speedpitch? ( media-libs/libsamplerate:= )
	streamtuner? ( dev-qt/qtnetwork:5 )
	vorbis? (
		>=media-libs/libogg-1.1.3
		>=media-libs/libvorbis-1.2.0
	)
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )
	X? ( dev-qt/qtx11extras:5 )
"
RDEPEND="${DEPEND}"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}/"audacious-media-player-audacious-plugins* "${S}" || die
	fi
}

pkg_setup() {
	use mp3 || ewarn "MP3 support is optional, you may want to enable the mp3 USE-flag"
}

src_prepare() {
	default
	if ! use nls; then
		sed -e "/SUBDIRS/s/ po//" -i Makefile || die # bug #512698
	fi
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-mpris2
		--enable-qt5
		--enable-qtaudio
		--enable-songchange
		--disable-adplug # not packaged
		--disable-gtk
		--disable-openmpt # not packaged
		--disable-oss4
		--disable-coreaudio
		--disable-sndio
		--with-libsdl=2
		$(use_enable aac)
		$(use_enable alsa)
		$(use_enable ampache)
		$(use_enable bs2b)
		$(use_enable cdda cdaudio)
		$(use_enable cue)
		$(use_enable flac)
		$(use_enable flac filewriter)
		$(use_enable fluidsynth amidiplug)
		$(use_enable ffmpeg ffaudio )
		$(use_enable gme console)
		$(use_enable http neon)
		$(use_enable jack)
		$(use_enable lame filewriter_mp3)
		$(use_enable libnotify notify)
		$(use_enable libsamplerate resample)
		$(use_enable lirc)
		$(use_enable mms)
		$(use_enable modplug)
		$(use_enable mp3 mpg123)
		$(use_enable nls)
		$(use_enable opengl qtglspectrum)
		$(use_enable opus )
		$(use_enable pulseaudio pulse)
		$(use_enable scrobbler scrobbler2)
		$(use_enable sdl sdlout)
		$(use_enable sid)
		$(use_enable sndfile)
		$(use_enable soxr)
		$(use_enable speedpitch)
		$(use_enable streamtuner)
		$(use_enable vorbis)
		$(use_enable wavpack)
		$(use_enable X qthotkey)
	)

	econf "${myeconfargs[@]}"
}