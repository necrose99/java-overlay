# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg eutils

MY_PN=${PN//-/.}
# TODO make MY_PV more maintainable
MY_PV="0.9.4-beta"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="W3C XPath-Rec implementation for DOM4J"
HOMEPAGE="http://sourceforge.net/projects/werken-xpath/"
SRC_URI="http://gentooexperimental.org/distfiles/${MY_P}-src.tar.gz"
# This tarball was acquired from jpacckage's src rpm for the package of the same
# name

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc jikes"

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	dev-java/antlr
	jikes? (dev-java/jikes)"
RDEPEND=">=virtual/jre-1.4
	=dev-java/jdom-1.0_beta9*"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Courtesy of JPackages :)
	epatch ${FILESDIR}/${P}-jpp-compile.patch
	epatch ${FILESDIR}/${P}-jpp-jdom.patch
	epatch ${FILESDIR}/${P}-jpp-tests.patch

	epatch ${FILESDIR}/${P}-gentoo.patch

	cd ${S}/lib
	rm -f *.jar
	java-pkg_jar-from jdom-1.0_beta9
	java-pkg_jar-from antlr
}

src_compile() {
	local antflags="package"
	use doc && antflags="${antflags} javadoc -Dbuild.javadocs=build/api"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	
	ant ${antflags} || die "Ant failed"
}

src_install() {
	java-pkg_dojar build/${MY_PN}.jar

	dodoc README TODO
	use doc && java-pkg_dohtml -r build/api
}
