<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="TestCase">
		<!-- copy node -->
		<xsl:copy>
			<!-- copying attributes -->
			<xsl:for-each select="@*">
				<xsl:copy/>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Messages">
		<!-- copy node -->
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Message">
		<!-- copy node -->
		<xsl:copy>
			<!-- copying attributes -->
			<xsl:for-each select="@*">
				<xsl:copy/>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="MFN_M08|MFN_M10|MFN_M04|MFN_M18">
		<!-- copy node -->
		<xsl:copy>
			<xsl:apply-templates select="MSH"/>
			<xsl:apply-templates select="MFI"/>
			<!-- M08 -->
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '104' ]"/>
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '110' ]"/>
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '112' ]"/>
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '202' ]"/>
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '252' ]"/>
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '326' ]"/>
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '500' ]"/>
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '600' ]"/>
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '610' ]"/>
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '1305' ]"/>
			<xsl:apply-templates select="MFN_M08.MF_TEST[MFE/MFE.4/MFE.4.1 = '1506' ]"/>
			<!-- M10 -->
			<xsl:apply-templates select="MFN_M10.MF_BATTERY[MFE/MFE.4/MFE.4.1 = '800' ]"/>
			<xsl:apply-templates select="MFN_M10.MF_BATTERY[MFE/MFE.4/MFE.4.1 = '100' ]"/>
			<!-- M04 -->
			<xsl:apply-templates select="MFN_M04.MF_CDM[MFE/MFE.4/MFE.4.1 = '500' ]"/>
			<xsl:apply-templates select="MFN_M04.MF_CDM[MFE/MFE.4/MFE.4.1 = '800' ]"/>
			<xsl:apply-templates select="MFN_M04.MF_CDM[MFE/MFE.4/MFE.4.1 = '200' ]"/>
			<xsl:apply-templates select="MFN_M04.MF_CDM[MFE/MFE.4/MFE.4.1 = '1305' ]"/>
			<xsl:apply-templates select="MFN_M04.MF_CDM[MFE/MFE.4/MFE.4.1 = '1300' ]"/>
			<xsl:apply-templates select="MFN_M04.MF_CDM[MFE/MFE.4/MFE.4.1 = '600' ]"/>
			<!-- M18 -->
			<xsl:apply-templates select="MFN_M18.MF_PAYER[MFE/MFE.4/MFE.4.1 = '500' ]"/>
			<xsl:apply-templates select="MFN_M18.MF_PAYER[MFE/MFE.4/MFE.4.1 = '600' ]"/>
			<xsl:apply-templates select="MFN_M18.MF_PAYER[MFE/MFE.4/MFE.4.1 = '1300' ]"/>
			<xsl:apply-templates select="MFN_M18.MF_PAYER[MFE/MFE.4/MFE.4.1 = '1305' ]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="MSH|MFI">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="MFN_M08.MF_TEST">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="MFN_M10.MF_BATTERY">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="MFN_M04.MF_CDM">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="MFN_M18.MF_PAYER">
		<xsl:copy-of select="."/>
	</xsl:template>
</xsl:stylesheet>
