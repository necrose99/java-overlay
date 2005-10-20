# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg

DESCRIPTION="HttpUnit emulates the relevant portions of browser behavior, including form submission, JavaScript, basic http authentication, cookies and automatic page redirection, and allows Java test code to examine returned pages either as text, an XML DOM, or containers of forms, tables, and links."
HOMEPAGE="http://httpunit.sourceforge.net/"
# TODO what is metainf for?
# TODO where did it come from?
SRC_URI="mirror://sourceforge/${PN}/${P}.zip
	http://gentooexperimental.org/distfiles/${P}-metainf.tar.gz"

# TODO: new license needed?
# http://httpunit.sourceforge.net/doc/license.html
LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.4
	dev-java/jtidy
	=dev-java/rhino-1.6*
	dev-java/nekohtml
	=dev-java/servletapi-2.3*
	=dev-java/xerces-2*"

TIDY="jtidy Tidy.jar"
JS="rhino-1.6 js.jar"
JUNIT="junit junit.jar"
NEKOHTML="nekohtml nekohtml.jar"
SERVLET="servletapi-2.3 servlet.jar"
XERCES_IMPL="xerces-2 xercesImpl.jar"
XML_PARSER_APIS="xerces-2 xmlParserAPIs.jar"

src_unpack() {
	unpack ${A}

	einfo "Fixing jars in jars/"
	cd ${S}/jars
	java-pkg_jar-from ${TIDY}
	java-pkg_jar-from ${JS}
	java-pkg_jar-from ${JUNIT}
	java-pkg_jar-from ${NEKOHTML}
	java-pkg_jar-from ${SERVLET}
	java-pkg_jar-from ${XERCES_IMPL}
	java-pkg_jar-from ${XML_PARSER_APIS}
}

src_compile() {
	local antflags="clean jar"
	# TODO patch for jikes
	#use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	use doc && antflags="${antflags} javadocs"
	ant ${antflags} || die "compile problem"
}

src_install() {
	java-pkg_dojar lib/${PN}.jar
	dodoc doc/*.txt
	if use doc; then
		java-pkg_dohtml -r doc/api doc/manual doc/tutorial
	fi
}
