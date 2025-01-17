# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Alliance for Open Media AV1 Codec SDK"
HOMEPAGE="https://aomedia.org"
SRC_URI="https://storage.googleapis.com/aom-releases/libaom-3.11.0.tar.gz -> libaom-3.11.0.tar.gz"
KEYWORDS="*"
LICENSE="BSD-2"
SLOT="0/3"
IUSE="doc examples"
IUSE="${IUSE} cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3"
IUSE="${IUSE} cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_avx cpu_flags_x86_avx2"
IUSE="${IUSE} cpu_flags_arm_neon"

REQUIRED_USE="
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse2 )
"

BDEPEND="
	dev-lang/yasm 
	doc? ( app-doc/doxygen )
"

# the PATENTS file is required to be distributed with this package bug #682214
DOCS=( PATENTS )

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOCS=$(usex doc ON OFF)
		-DENABLE_EXAMPLES=$(usex examples ON OFF)
		-DENABLE_NASM=OFF
		-DENABLE_TESTS=OFF
		-DENABLE_TOOLS=ON
		-DENABLE_WERROR=OFF

		# neon support is assumed to be always enabled on arm64
		-DENABLE_NEON=$(usex cpu_flags_arm_neon ON $(usex arm64 ON OFF))
		# ENABLE_DSPR2 / ENABLE_MSA for mips
		-DENABLE_MMX=$(usex cpu_flags_x86_mmx ON OFF)
		-DENABLE_SSE=$(usex cpu_flags_x86_sse ON OFF)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2 ON OFF)
		-DENABLE_SSE3=$(usex cpu_flags_x86_sse3 ON OFF)
		-DENABLE_SSSE3=$(usex cpu_flags_x86_ssse3 ON OFF)
		-DENABLE_SSE4_1=$(usex cpu_flags_x86_sse4_1 ON OFF)
		-DENABLE_SSE4_2=$(usex cpu_flags_x86_sse4_2 ON OFF)
		-DENABLE_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DENABLE_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)
	)
	cmake_src_configure
}

src_install() {
	if use doc ; then
		local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	fi
	cmake_src_install
	find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
	einstalldocs
}