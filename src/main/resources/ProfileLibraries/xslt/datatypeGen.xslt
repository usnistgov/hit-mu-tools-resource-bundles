<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="filename"/>
	<xsl:param name="datatypeLib" select="document('LOI_datatypeLibrary.xml')"/>
	<xsl:template match="/">
		<xsl:result-document href="{$filename}" indent="yes">
			<xsl:comment>
				<xsl:value-of select="current-dateTime()"/>
			</xsl:comment>
			<xsl:apply-templates/>
		</xsl:result-document>
	</xsl:template>
	<xsl:template match="DatatypeLibrary">
		<xsl:element name="HL7v2xConformanceProfile">
			<xsl:attribute name="HL7Version">2.5.1</xsl:attribute>
			<xsl:attribute name="ProfileType">HL7</xsl:attribute>
			<xsl:element name="Encodings">
				<xsl:element name="Encoding">ER7</xsl:element>
			</xsl:element>
			<xsl:element name="HL7v2xStaticDef">
				<xsl:attribute name="EventDesc"></xsl:attribute>
				<xsl:attribute name="EventType">DTP</xsl:attribute>
				<xsl:attribute name="MsgStructID"></xsl:attribute>
				<xsl:attribute name="MsgType">DTP</xsl:attribute>
				<xsl:attribute name="Role">Sender</xsl:attribute>
				<xsl:element name="Segment">
					<xsl:attribute name="Max">1</xsl:attribute>
					<xsl:attribute name="MaxLength">1</xsl:attribute>
					<xsl:attribute name="Min">0</xsl:attribute>
					<xsl:attribute name="MinLength">0</xsl:attribute>
					<xsl:attribute name="Name">DTLibBASE_LOI-Receiver-Usage</xsl:attribute>
					<xsl:attribute name="Usage">O</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="Field">
		<xsl:copy>
			<xsl:attribute name="Datatype" select="@Datatype"/>
			<xsl:attribute name="Max">1</xsl:attribute>
			<xsl:attribute name="MaxLength">1</xsl:attribute>
			<xsl:attribute name="Min">0</xsl:attribute>
			<xsl:attribute name="MinLength">0</xsl:attribute>
			<xsl:attribute name="Name" select="@Datatype"/>
			<xsl:attribute name="Usage">O</xsl:attribute>
		<xsl:apply-templates select="node()"/>
	
		</xsl:copy>
	</xsl:template>
	<!--Identity template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
