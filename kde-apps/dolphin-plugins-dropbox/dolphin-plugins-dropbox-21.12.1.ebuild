# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="false"
KMNAME="dolphin-plugins"
MY_PLUGIN_NAME="dropbox"
FRAMEWORKS_MINIMAL=5.75.0
QT_MINIMAL=5.15.2
inherit kde5

DESCRIPTION="Dolphin plugin for Dropbox service integration"
HOMEPAGE="https://apps.kde.org/en/dolphin_plugins"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="*"
IUSE=""

DEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_kdeapps_dep dolphin)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kxmlgui)
"
RDEPEND="${DEPEND}
	!kde-apps/dolphin-plugins:5
	net-misc/dropbox-cli
"

src_prepare() {
	kde5_src_prepare
	# solid, qtdbus only required by mountiso
	punt_bogus_dep Qt5 DBus
	punt_bogus_dep KF5 Solid
	# delete non-${PN} translations
	find po -type f -name "*po" -and -not -name "*${MY_PLUGIN_NAME}plugin" -delete || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_${MY_PLUGIN_NAME}=ON
		-DBUILD_bazaar=OFF
		-DBUILD_git=OFF
		-DBUILD_hg=OFF
		-DBUILD_mountiso=OFF
		-DBUILD_svn=OFF
	)
	kde5_src_configure
}

src_install() {
	kde5_src_install
	rm "${D}"/usr/share/metainfo/org.kde.dolphin-plugins.metainfo.xml || die
}
