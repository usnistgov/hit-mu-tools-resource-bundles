<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="testCaseId"/>
	<xsl:param name="message1"/>
	<xsl:param name="message2"/>
	<xsl:param name="message3"/>
	<xsl:param name="message4"/>
	
	<xsl:variable name="message1Doc" select="document($message1)"/>
	<xsl:variable name="message2Doc" select="document($message2)"/>
	<xsl:variable name="message3Doc" select="document($message3)"/>
	<xsl:variable name="message4Doc" select="document($message4)"/>
	
	<xsl:template match="/">
		<xsl:element name="TestCase">
			<xsl:attribute name="id" select="$testCaseId"/>
			<xsl:attribute name="generated" select="fn:current-dateTime()"/>
			<xsl:element name="Messages">
				<xsl:for-each select="$message1Doc/TestCase/Messages/Message">
					<xsl:copy-of select="."/>
				</xsl:for-each>
				<xsl:for-each select="$message2Doc/TestCase/Messages/Message">
					<xsl:copy-of select="."/>
				</xsl:for-each>
				<xsl:for-each select="$message3Doc/TestCase/Messages/Message">
					<xsl:copy-of select="."/>
				</xsl:for-each>
				<xsl:for-each select="$message4Doc/TestCase/Messages/Message">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
