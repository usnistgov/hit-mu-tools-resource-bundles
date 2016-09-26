<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<!-- Extract Segment elements and Datatype elements in seperate files. Useful to compare flavors -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//Segments//Segment"/>
		<xsl:apply-templates select="//Datatypes//Datatype"/>
	</xsl:template>
	<xsl:template match="Segment">
		<xsl:variable name="dir_name" select="@Name"/>
		<xsl:variable name="file_name" select="concat(@ID,'.xml')"/>
		<xsl:message select="$dir_name"/>
		<xsl:message select="$file_name"/>
		<xsl:result-document href="Segments/{$dir_name}/{$file_name}">
			<xsl:copy-of select="."/>
		</xsl:result-document>
	</xsl:template>
	<xsl:template match="Datatype">
		<xsl:variable name="dir_name" select="@Name"/>
		<xsl:variable name="file_name" select="concat(@ID,'.xml')"/>
		<xsl:message select="$dir_name"/>
		<xsl:message select="$file_name"/>
		<xsl:result-document href="Datatypes/{$dir_name}/{$file_name}">
			<xsl:copy-of select="."/>
		</xsl:result-document>
	</xsl:template>
</xsl:stylesheet>
