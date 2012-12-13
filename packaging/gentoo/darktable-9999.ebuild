# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit cmake-utils eutils git-2 gnome2-utils toolchain-funcs

DESCRIPTION="A virtual lighttable and darkroom for photographers"
HOMEPAGE="http://www.darktable.org/"
EGIT_REPO_URI="git://github.com/darktable-org/darktable.git"

EGIT_BRANCH="master"
EGIT_COMMIT="master"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="colord facebook flickr geo gnome-keyring gphoto2 kde nls opencl openmp +rawspeed +slideshow"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/libxml2:2
	colord? ( x11-misc/colord )
	facebook? ( dev-libs/json-glib )
	flickr? ( media-libs/flickcurl )
	geo? ( net-libs/libsoup:2.4 )
	gnome-keyring? ( gnome-base/gnome-keyring )
	gnome-base/librsvg:2
	gphoto2? ( media-libs/libgphoto2 )
	kde? (
		dev-libs/dbus-glib
		kde-base/kwalletd
	)
	media-gfx/exiv2[xmp]
	media-libs/lcms:2
	>=media-libs/lensfun-0.2.3
	media-libs/libpng
	media-libs/openexr
	media-libs/tiff
	net-misc/curl
	opencl? ( virtual/opencl )
	slideshow? (
		media-libs/libsdl
		virtual/glu
		virtual/opengl
	)
	virtual/jpeg
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	base_src_prepare
	sed -i -e "s:\(/share/doc/\)darktable:\1${PF}:" \
		-e "s:LICENSE::" doc/CMakeLists.txt || die
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_use colord COLORD)
		$(cmake-utils_use_use facebook GLIBJSON)
		$(cmake-utils_use_use flickr FLICKR)
		$(cmake-utils_use_use geo GEO)
		$(cmake-utils_use_use gnome-keyring GNOME_KEYRING)
		$(cmake-utils_use_use gphoto2 CAMERA_SUPPORT)
		$(cmake-utils_use_use kde KWALLET)
		$(cmake-utils_use_use nls NLS)
		$(cmake-utils_use_use opencl OPENCL)
		$(cmake-utils_use_use openmp OPENMP)
		$(cmake-utils_use !rawspeed DONT_USE_RAWSPEED)
		$(cmake-utils_use_build slideshow SLIDESHOW)
		-DINSTALL_IOP_EXPERIMENTAL=ON
		-DINSTALL_IOP_LEGACY=ON
		-DCUSTOM_CFLAGS=ON
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
