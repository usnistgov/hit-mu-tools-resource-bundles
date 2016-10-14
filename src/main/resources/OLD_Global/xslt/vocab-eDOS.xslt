<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="eDOS_constrained" select="document('../tables/eDOS_constrained_HL7_tables.xml')"/>
	<xsl:variable name="eDOS_external" select="document('../tables/eDOS_external.xml')"/>
	<xsl:variable name="eDOS_unconstrained" select="document('../tables/eDOS_unconstrained_code_systems.xml')"/>
	<xsl:template match="/">
		<xsl:comment>
			<xsl:value-of select="current-dateTime()"/>
		</xsl:comment>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="*:TableLibrary">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="child::node()" mode="no_copy"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*:TableDefinition" mode="no_copy">
		<xsl:param name="tableId" select="@Id"/>
		<xsl:apply-templates select="$eDOS_constrained/*:TableLibrary/*:TableDefinition[@Id=$tableId]"/>
		<xsl:apply-templates select="$eDOS_external/*:TableLibrary/*:TableDefinition[@Id=$tableId]"/>
		<xsl:apply-templates select="$eDOS_unconstrained/*:TableLibrary/*:TableDefinition[@Id=$tableId]"/>
	</xsl:template>
	<xsl:template match="*:TableDefinition">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="child::node()"/>
		</xsl:copy>
	</xsl:template>
	<!--Identity template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
