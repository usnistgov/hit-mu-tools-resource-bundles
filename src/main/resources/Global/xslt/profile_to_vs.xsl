<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:result-document href="profile_to_vs.xml">
			<xsl:element name="Messages">
				<xsl:apply-templates select="//Message"/> 
			</xsl:element>
		</xsl:result-document>
	</xsl:template>
	<xsl:template match="Message">
		<xsl:variable name="bindings">
			<xsl:for-each select=".//Segment">
				<xsl:variable name="ref" select="@Ref"/>
				<xsl:apply-templates select="//Segment[@ID=$ref]"/>
			</xsl:for-each>
		</xsl:variable> 
		 <xsl:element name="Message">
			<xsl:attribute name="ID" select="@ID"/>
			<xsl:for-each select="fn:distinct-values(fn:tokenize($bindings,'::'))">
				<xsl:sort select="."/>
				<xsl:if test=".">
					<xsl:element name="ValueSetDefinition">
						<xsl:attribute name="BindingIdentifier" select="."/>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template match="Segment">
		<xsl:apply-templates select="Field"/>
	</xsl:template>
	<xsl:template match="Field">
		<xsl:if test="@Binding">
			<xsl:value-of select="fn:concat(@Binding,'::')"/>
		</xsl:if>
		<xsl:variable name="datatype" select="@Datatype"/>
		<xsl:apply-templates select="//Datatype[@ID=$datatype]"/>
	</xsl:template>
	<xsl:template match="Datatype">
		<xsl:for-each-group select="Component" group-by="@Binding">
			<xsl:value-of select="fn:concat(@Binding,'::')"/>
		</xsl:for-each-group>
	</xsl:template>
	<xsl:template match="text()"/>
</xsl:stylesheet>
