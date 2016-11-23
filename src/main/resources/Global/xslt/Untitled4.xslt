<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="M08"/>
	<xsl:param name="M10"/>
	<xsl:param name="M04"/>
	
	<xsl:variable name="M08Doc" select="document($M08)"/>
	<xsl:variable name="M10Doc" select="document($M10)"/>
	<xsl:variable name="M04Doc" select="document($M04)"/>
	<xsl:template match="/">
		<xsl:element name="TestCase">
			<xsl:attribute name="id" select="TODO"/>
			<xsl:attribute name="generated" select="fn:current-dateTime()"/>
			<xsl:element name="Messages">
				<!-- copy M08 -->
				<xsl:element name="Message">
					<xsl:for-each select="$M08Doc/TestCase/Messages/Message">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:element>
				<!-- copy M10 -->
				<xsl:element name="Message">
					<xsl:for-each select="$M10Doc/TestCase/Messages/Message">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:element>
				<!-- copy M04 -->
				<xsl:element name="Message">
					<xsl:for-each select="$M04Doc/TestCase/Messages/Message">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
