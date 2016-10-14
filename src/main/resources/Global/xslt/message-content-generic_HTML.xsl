<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="http://www.nist.gov/ds" exclude-result-prefixes="util xsl">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="TestStep">
		<xsl:call-template name="css"/>
		<xsl:call-template name="main"/>
	</xsl:template>
	<xsl:template name="main">
		<xsl:element name="div">
			<xsl:attribute name="class">message-content</xsl:attribute>
			<!--  TODO find a way to display the full -->
			<xsl:element name="tabset">
				<xsl:apply-templates select="Message"/>
			</xsl:element>
		</xsl:element>
			<!-- <fieldset>
					<legend>Test Case Information</legend>
					<table>
						<thead>
							<tr>
								<th colspan="2">
									<xsl:value-of select="@name"/>
								</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th> Test Case ID</th>
								<td>
									<xsl:value-of select="@id"/>
								</td>
							</tr>
						</tbody>
					</table>
				</fieldset>
				<br/>
		<xsl:apply-templates select="Message"/> -->
	</xsl:template>
	
	<xsl:template match="Message">
		<!-- <xsl:apply-templates select="Segment"/> -->
		<xsl:for-each select="Segment">
		
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="Segment">
		<xsl:variable name="segmentName" select="@name"/>
		<!-- TODO check if next sibling has the same name : use accordion -->
		<xsl:element name="tab">
			<xsl:attribute name="heading" select="$segmentName"/>
			<xsl:attribute name="vertical" select="'false'"/>
			<xsl:element name="fieldset">
				<xsl:element name="legend" select="$segmentName"></xsl:element>
				<xsl:element name="table">
					<xsl:element name="thead">
						<xsl:element name="tr">
							<xsl:element name="th">Location</xsl:element>
							<xsl:element name="th">Data Element</xsl:element>
							<xsl:element name="th">Data</xsl:element>
							<xsl:element name="th">Categorization</xsl:element>
						</xsl:element>
					</xsl:element>
					<xsl:element name="tbody">
						<xsl:apply-templates select="Element"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="Element">
		<xsl:variable name="location">
			<xsl:call-template name="util:shortLocation">
				<xsl:with-param name="location" select="@location"/>
		</xsl:call-template>	
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="count(tokenize(@location,'[.]')) = 2">
				<!-- this is a field-->
				<xsl:variable name="fieldLength">
					<xsl:call-template name="util:elementLength">
						<xsl:with-param name="elementLocation" select="@location"/>
					</xsl:call-template>
				</xsl:variable>	
				<tr>
					<xsl:if test="$fieldLength = 0">
						<xsl:attribute name="class">hidden</xsl:attribute>
					</xsl:if>
					<th>
						<xsl:value-of select="$location"/>
					</th>
					<th>
						<xsl:value-of select="@dataElement"/>
					</th>
					<xsl:choose>
						<xsl:when test="string-length(normalize-space(@data)) = 0">
							<th/>
							<th/>
						</xsl:when>
						<xsl:otherwise>
							<td>
								<xsl:value-of select="@data"/>
							</td>
							<td>
								<xsl:value-of select="@categorization"/>
							</td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
			</xsl:when>
			<xsl:otherwise>
			<!-- components & subcomponents-->
					<xsl:variable name="elementLength">
						<xsl:call-template name="util:elementLength">
							<xsl:with-param name="elementLocation" select="@location"/>
						</xsl:call-template>
					</xsl:variable>
					
					<tr>
						<xsl:if test="$elementLength = 0">
							<xsl:attribute name="class">hidden</xsl:attribute>
						</xsl:if>
						<xsl:variable name="setColor">
							<xsl:choose>
								<xsl:when test="string-length(normalize-space(@data)) = 0">
									<xsl:value-of select="'childField'"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="elementSplitter">
							<xsl:choose>
								<xsl:when test="count(tokenize(@location,'[.]')) = 3">embSpace</xsl:when>
								<xsl:when test="count(tokenize(@location,'[.]')) = 4">embSubSpace</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<td class="{$elementSplitter}">
							<xsl:value-of select="$location"/>
						</td>
						<td class="{$elementSplitter}">
							<xsl:value-of select="@dataElement"/>
						</td>
						<td>
							<xsl:if test="string-length($setColor) &gt; 0">
								<xsl:attribute name="class" select="$setColor"/>
							</xsl:if>
							<xsl:value-of select="@data"/>
						</td>
						<td>
							<xsl:if test="string-length($setColor) &gt; 0">
								<xsl:attribute name="class" select="$setColor"/>
							</xsl:if>
							<xsl:value-of select="@categorization"/>
						</td>
					</tr>	
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="util:elementLength">
		<xsl:param name="elementLocation"/>
		<xsl:variable name="value">
			<xsl:value-of select="@data"/>
			<xsl:for-each select="following-sibling::Element[starts-with(@location,concat($elementLocation,'.'))]">
				<xsl:value-of select="@data"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="string-length($value)"/>
	</xsl:template>
	
	<xsl:template name="util:shortLocation">
			<xsl:param name="location"/>
			<xsl:value-of select="replace($location,'\[1\]','')"/>
	</xsl:template>
	
	<xsl:template name="css">
		<style type="text/css">
		@media screen {		
		.message-content maskByMediaType {display:table;}			
				
		.message-content table tbody tr th {font-size:95%}			
		.message-content table tbody tr td {font-size:100%;}			
		.message-content table tbody tr th {text-align:left;background:#C6DEFF}			
		.message-content table thead tr th {text-align:center;}			
		.message-content {text-align:center;}			
		.message-content table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;border-collapse: collapse;}			
		.message-content table  tr { border: 3px groove; }			
		.message-content table  th { border: 2px groove;}			
		.message-content table  td { border: 2px groove; }			
		.message-content table thead {border: 1px groove;background:#446BEC;text-align:left;}			
		.message-content table tbody tr td {text-align:left}				
			
		/* Don't display empty rows */
		.message-content .tds_noData {display:none;}
	
		}	
			
			@media print {
		.message-content 
		.message-content tds_maskByMediaType {display:table;}			
		.message-content fieldset table tbody tr th {font-size:90%}			
		.message-content fieldset table tbody tr td {font-size:90%;}			
		.message-content fieldset table tbody tr th {text-align:left;background:#C6DEFF}			
		.message-content fieldset table thead tr th {text-align:center;background:#4682B4}			
		.message-content fieldset {text-align:center;page-break-inside: avoid;}			
		.message-content fieldset table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;page-break-inside: avoid;border-collapse: collapse;}			
		.message-content fieldset table[id=vendor-labResults] thead tr {font-size:80%}			
		.message-content fieldset table[id=vendor-labResults] tbody tr {font-size:75%}			
		.message-content fieldset table  tr { border: 3px groove; }			
		.message-content fieldset table  th { border: 2px groove;}			
		.message-content fieldset table  td { border: 2px groove; }			
		.message-content fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;}			
		.message-content fieldset table tbody tr td {text-align:left;}			
		
		.message-content .tds_noData {display:none;}
				
		.message-content .tds_title {text-align:left;margin-bottom:1%}			
		.message-content h3 {text-align:center;}			
		.message-content h2 {text-align:center;}			
		.message-content h1 {text-align:center;}	
		.message-content .tds_pgBrk {page-break-after:always;}
		}
		</style>
	</xsl:template>
</xsl:stylesheet>
