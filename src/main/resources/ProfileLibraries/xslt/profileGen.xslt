<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="filename"/>
	<xsl:param name="segmentLib" select="document('LRI_segmentLibrary.xml')"/>
	<xsl:param name="datatypeLib" select="document('LRI_datatypeLibrary.xml')"/>
	<xsl:template match="/">
	<xsl:result-document href="{$filename}" indent="yes">
		<xsl:comment>
			<xsl:value-of  select="current-dateTime()"/>
		</xsl:comment>
		<xsl:apply-templates/>
	</xsl:result-document>
	</xsl:template>
	<xsl:template match="HL7v2xConformanceProfile">
		<xsl:copy>
			 <xsl:apply-templates select="@*"/>
			 <xsl:apply-templates select="child::node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="HL7v2xStaticDef/Segment | SegGroup/Segment">
		<xsl:param name="Name" select="@Name"/>
		<xsl:param name="flavor" select="@flavor"/>
		<xsl:copy>
			<!-- copy attributes except for flavor -->
			<xsl:apply-templates select="@Name"/>
			<xsl:apply-templates select="@Usage"/>
			<xsl:apply-templates select="@PredicateFalseUsage"/>
			<xsl:apply-templates select="@PredicateTrueUsage"/>
			<xsl:apply-templates select="@Min"/>
			<xsl:apply-templates select="@Max"/>
			<xsl:apply-templates select="$segmentLib/SegmentLibrary/Segment[@Name=$Name and @flavor=$flavor]/@LongName"/>

			<!-- copy condition predicate-->
			 <xsl:apply-templates select="Predicate"/>
			<!-- copy conformance statement-->
			 <xsl:apply-templates select="ConformanceStatement"/>
			<!-- lookup in segment libary to get fields -->
			<xsl:apply-templates select="$segmentLib/SegmentLibrary/Segment[@Name=$Name and @flavor=$flavor]"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="SegmentLibrary/Segment">
		<!-- copy conformance statements -->
		<xsl:apply-templates select="ConformanceStatement"/>
		<!-- copy fields -->
		<xsl:apply-templates select="Field"/>
	</xsl:template>
	<xsl:template match="SegmentLibrary/Segment/Field">
		<xsl:param name="Datatype" select="@Datatype"/>
		<xsl:element name="Field">
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="child::node()"/>
			<xsl:apply-templates select="$datatypeLib/DatatypeLibrary/Field[@Datatype=$Datatype]"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="DatatypeLibrary/Field">
		<xsl:call-template name="addComponent"/>
	</xsl:template>
	
	<xsl:template name="addComponent">
	<xsl:for-each select="child::node()[name()='Component']">
		<xsl:variable name="componentDatatype" select="@Datatype"/>
		<xsl:element name="Component">
			 <xsl:apply-templates select="@*"/>
			 <xsl:apply-templates select="child::node()"/>
			 <xsl:call-template name="addSubComponent">
				 <xsl:with-param name="Datatype" select="$componentDatatype"/>
			 </xsl:call-template>
		</xsl:element>
	</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="addSubComponent">
		<xsl:param name="Datatype"/>
		<xsl:for-each select="$datatypeLib/DatatypeLibrary/Field[@Datatype=$Datatype]/Component">
		<xsl:element name="SubComponent">
			 <xsl:apply-templates select="@*"/>
			 <xsl:apply-templates select="child::node()"/>		
		</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<!--Identity template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
