<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="ByID">
		<xsl:variable name="node" select="current()"/>
		<xsl:for-each select="fn:tokenize(@ID,' ')">
			<xsl:element name="ByID">
				<xsl:attribute name="ID" select="."/>
				<xsl:apply-templates select="$node/node()">
					<xsl:with-param name="ID" select="."/>
				</xsl:apply-templates>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ByName">
		<xsl:variable name="node" select="current()"/>
		<xsl:for-each select="fn:tokenize(@Name,' ')">
			<xsl:element name="ByName">
				<xsl:attribute name="Name" select="."/>
				<xsl:apply-templates select="$node/node()">
					<xsl:with-param name="ID" select="."/>
				</xsl:apply-templates>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="Predicate">
		<xsl:param name="ID"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- todo add ID-->
			<xsl:attribute name="ID" select="fn:concat('[',$ID,']',@Target)"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Constraint|Description|Assertion">
		<xsl:copy-of select="."/>
	</xsl:template>
	<!-- copy comments -->
	<xsl:template match="comment()">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- copy attributes -->
	<xsl:template match="@*">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
