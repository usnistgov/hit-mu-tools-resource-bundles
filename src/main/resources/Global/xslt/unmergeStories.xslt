<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:for-each select="//TestCaseMetaData">
			<xsl:if test="matches(@id,'-GU')">
				<xsl:variable name="filename" select="concat('TestStory_',@id,'.xml')"/>
				<xsl:value-of select="$filename"/>
				<!-- Creating GU -->
				<xsl:result-document href="GU/{$filename}">
					<xsl:copy-of select="."/>
				</xsl:result-document>
				<!-- Copying NG -->
				<xsl:variable name="id" select="replace(@id,'-GU','-NG')"/>
				<xsl:variable name="filename_ng" select="concat('TestStory_',$id,'.xml')"/>
				<xsl:value-of select="$filename_ng"/>
				<!-- Creating  -->
				<xsl:result-document href="NG/{$filename_ng}">
					<xsl:copy-of select="."/>
				</xsl:result-document>
			</xsl:if>
			<xsl:if test="not(matches(@id,'-GU'))">
				<xsl:variable name="filename" select="concat('TestStory_',@id,'.xml')"/>
				<xsl:value-of select="$filename"/>
				<!-- Creating GU -->
				<xsl:result-document href="GU/{$filename}">
					<xsl:copy-of select="."/>
				</xsl:result-document>
				<!-- Creating NG -->
				<xsl:result-document href="NG/{$filename}">
					<xsl:copy-of select="."/>
				</xsl:result-document>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
