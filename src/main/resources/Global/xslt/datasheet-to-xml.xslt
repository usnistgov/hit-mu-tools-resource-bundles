<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:element name="TestCase">
			<xsl:attribute name="id" select="event-profiles/test-message/@instance"/>
			<xsl:attribute name="generated" select="fn:current-dateTime()"/>
			<xsl:element name="Messages">
				<xsl:apply-templates select="event-profiles/test-message"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="test-message">
		<!-- get message type -->
		<xsl:variable name="mshId" select="segment[@id='MSH']/@test-profile"/>
		<xsl:variable name="msgType" select="//test-profile[@segment = 'MSH' and @id=$mshId]/element[@location='MSH.9[1].3']/@data"/>
		<xsl:element name="Message">
			<xsl:attribute name="id" select="$msgType"/>
			<xsl:element name="{$msgType}">
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="test-message/segment">
		<xsl:param name="segmentName" select="@id"/>
		<xsl:param name="segmentId" select="@test-profile"/>
		<xsl:element name="{$segmentName}">
			<xsl:apply-templates select="//test-profiles[@segment=$segmentName]/test-profile[@id=$segmentId]"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="test-profile">
		<!-- process fileds -->
		<xsl:param name="fields" select="element[fn:string-length(@location) - fn:string-length(fn:translate(@location,'.','')) = 1]"/>
		<xsl:for-each select="$fields">
			<xsl:call-template name="processField">
				<xsl:with-param name="field" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="processField">
		<xsl:param name="field"/>
		<xsl:variable name="fieldLocation" select="@location"/>
		<xsl:variable name="elementName">
			<xsl:call-template name="removeRepetition">
				<xsl:with-param name="location" select="@location"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="data">
			<xsl:call-template name="getValue">
				<xsl:with-param name="location" select="$fieldLocation"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="fn:string-length($data) &gt; 0">
			<xsl:element name="{$elementName}">
				<xsl:choose>
					<xsl:when test="@data">
						<xsl:value-of select="@data"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- get all the components-->
						<xsl:variable name="components" select="following-sibling::element[fn:starts-with(@location,fn:concat($fieldLocation,'.')) and (fn:string-length(@location) - fn:string-length(fn:translate(@location,'.','')) = 2) ]"/>
						<xsl:for-each select="$components">
							<xsl:call-template name="processComponent">
								<xsl:with-param name="component" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="processComponent">
		<xsl:param name="component"/>
		<xsl:variable name="componentLocation" select="@location"/>
		<xsl:variable name="elementName">
			<xsl:call-template name="removeRepetition">
				<xsl:with-param name="location" select="@location"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="data">
			<xsl:call-template name="getValue">
				<xsl:with-param name="location" select="$componentLocation"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="fn:string-length($data) &gt; 0">
			<xsl:element name="{$elementName}">
				<xsl:choose>
					<xsl:when test="@data">
						<xsl:value-of select="@data"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- get all the subcomponents-->
						<xsl:variable name="subcomponents" select="following-sibling::element[fn:starts-with(@location,fn:concat($componentLocation,'.')) and (fn:string-length(@location) - fn:string-length(fn:translate(@location,'.','')) = 3) ]"/>
						<xsl:for-each select="$subcomponents">
							<xsl:call-template name="processSubComponent">
								<xsl:with-param name="subcomponent" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="processSubComponent">
		<xsl:param name="subcomponent"/>
		<xsl:variable name="subcomponentLocation" select="@location"/>
		<xsl:variable name="elementName">
			<xsl:call-template name="removeRepetition">
				<xsl:with-param name="location" select="@location"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="@data">
			<xsl:element name="{$elementName}">
				<xsl:choose>
					<xsl:when test="@data">
						<xsl:value-of select="@data"/>
					</xsl:when>
					<xsl:otherwise>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	<xsl:template name="getValue">
		<xsl:param name="location"/>
		<xsl:value-of select="@data"/>
		<xsl:variable name="siblings" select="following-sibling::element[fn:starts-with(@location,fn:concat($location,'.'))]"/>
		<xsl:for-each select="$siblings">
			<xsl:value-of select="./@data"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="removeRepetition">
		<xsl:param name="location"/>
		<xsl:value-of select="fn:replace($location,'\[.+\]','')"/>
	</xsl:template>
</xsl:stylesheet>
