<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="http://www.nist.gov/ds" exclude-result-prefixes="util xsl">
	<xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="TestStep">
		<html>
			<head>
				<title>NIST HL7V2 Lab Validation Suite - Message Content</title>
				<style type="text/css">
                     @media screen {
                    maskByMediaType {display:table;}
                    fieldset table tbody tr th {font-size:95%}
                    fieldset table tbody tr td {font-size:95%;}
                    fieldset table tbody tr th {text-align:left;background:#C6DEFF}
                    fieldset table thead tr th {text-align:center;}
                    fieldset table thead tr th:first-child {width:15%;}
                    fieldset table thead tr th:nth-child(2) {width:30%;}
                    fieldset table thead tr th:nth-child(3) {width:30%;}
                    fieldset table thead tr th:last-child {width:20%;}
					fieldset {text-align:center;}
					fieldset table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;border-collapse: collapse;}
                    fieldset table  tr { border: 3px groove; }
                    fieldset table  th { border: 2px groove;}
                    fieldset table  td { border: 2px groove; }
                    fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;}
                    fieldset table tbody tr td {text-align:left}
                    .embSpace {padding-left:15px;}
                    .embSubSpace {padding-left:25px;}
                    .childField {background:#B8B8B8;}
                    .hidden {display:none;}
                    }
                    @media print {
                    maskByMediaType {display:table;}
                    fieldset table tbody tr th {font-size:70%}
                    fieldset table tbody tr td {font-size:70%;}
                    fieldset table tbody tr th {text-align:left;background:#C6DEFF}
                    fieldset table thead tr th {text-align:center;font-size:70%;}
                    fieldset legend {text-align:center;font-size:70%;}
                    fieldset table thead tr th:first-child {width:15%;}
                    fieldset table thead tr th:nth-child(2) {width:30%;}
                    fieldset table thead tr th:nth-child(3) {width:30%;}
                    fieldset table thead tr th:last-child {width:20%;}
					fieldset {text-align:center;page-break-inside: avoid;}
					fieldset table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;border-collapse: collapse;page-break-inside: avoid;}
                    fieldset table  tr { border: 3px groove; }
                    fieldset table  th { border: 2px groove;}
                    fieldset table  td { border: 2px groove; }
                    fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;}
                    fieldset table tbody tr td {text-align:left}
                    .embSpace {padding-left:10px;}
                    .embSubSpace {padding-left:20px;}
                    .childField {background:#B8B8B8;}
                    .hidden {display:none;}
                    }
                    @page {
                    counter-increment: page;
					@bottom-center {
                    content: "Page " counter(page);
                    }
                    }
                    @page :left {
                    margin-left: 5%;
                    margin-right: 5%;
                    }
                    @page :right {
                    margin-left: 5%;
                    margin-right: 5%;
                    }
                </style>
			</head>
			<body>
				<fieldset>
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
				<xsl:apply-templates select="Message"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="Message">
		<xsl:apply-templates select="Segment"/>
	</xsl:template>
	<xsl:template match="Segment">
		<xsl:variable name="segmentName" select="@name"/>
		<fieldset>
			<legend>
				<xsl:value-of select="$segmentName"/>
			</legend>
			<table>
				<thead>
					<tr>
						<th>Location</th>
						<th>Data Element</th>
						<th>Data</th>
						<th>Categorization</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="Element"/>
				</tbody>
			</table>
		</fieldset>
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
		<!--		<tr>
			<th>
				<xsl:value-of select="@location"/>
			</th>
			<th>
				<xsl:value-of select="@dataElement"/>
			</th>
			<td>
				<xsl:value-of select="@data"/>
			</td>
			<td>
				<xsl:value-of select="@categorization"/>
			</td>
		</tr>-->
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

</xsl:stylesheet>
