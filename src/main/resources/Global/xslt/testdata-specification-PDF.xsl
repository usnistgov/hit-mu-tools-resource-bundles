<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xpath-default-namespace="http://www.w3.org/1999/xhtml">
	<xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<html>
			<xsl:apply-templates/>
		</html>
	</xsl:template>
	<xsl:template match="root">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="style">
		<head>
			<xsl:copy-of select="."/>
		</head>
	</xsl:template>
	<xsl:template match="root/div">
		<body>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</body>
	</xsl:template>
	<xsl:template match="tabset/tab">
		<fieldset>
			<legend>
				<xsl:value-of select="@heading"/>
			</legend>
			<xsl:apply-templates select="table|.//accordion"/>
		</fieldset>
	</xsl:template>
	<xsl:template match="accordion">
			<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="accordion-group">
		<fieldset>
			<legend>
				<xsl:value-of select="@heading"/>
			</legend>
			<xsl:copy-of select="./*"/>
		</fieldset>
	</xsl:template>
	
	<xsl:template match="table">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="text()">
</xsl:template>
</xsl:stylesheet>
