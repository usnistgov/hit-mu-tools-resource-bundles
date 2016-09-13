<?xml version="1.0" encoding="UTF-8"?>
<!-- Generic transformation used to create TestStory.html -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="fn xs fn">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="TestCaseMetaData">
		<html>
			<head>
				<xsl:call-template name="css"/>
			</head>
			<body>
				<!-- add Description -->
				<xsl:apply-templates select="Description"/>
				<!-- add Comments -->
				<xsl:apply-templates select="Comments"/>
				<!-- add PreCondition -->
				<xsl:apply-templates select="PreCondition"/>
				<!-- add PostCondition -->
				<xsl:apply-templates select="PostCondition"/>
				<!-- TestObjectives -->
				<xsl:apply-templates select="TestObjectives"/>
				<!-- Notes to Testers -->
				<xsl:apply-templates select="Notes"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="Description">
		<xsl:call-template name="addFieldset">
			<xsl:with-param name="title">
				<xsl:value-of select="'Description'"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="Comments">
		<xsl:call-template name="addFieldset">
			<xsl:with-param name="title">
				<xsl:value-of select="'Comments'"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="PreCondition">
		<xsl:call-template name="addFieldset">
			<xsl:with-param name="title">
				<xsl:value-of select="'PreCondition'"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="PostCondition">
		<xsl:call-template name="addFieldset">
			<xsl:with-param name="title">
				<xsl:value-of select="'PostCondition'"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="TestObjectives">
		<xsl:call-template name="addFieldset">
			<xsl:with-param name="title">
				<xsl:value-of select="'TestObjectives'"/>
			</xsl:with-param>
			<!-- Test Objective section is transformed to bulleted list-->
			<xsl:with-param name="toList">
				<xsl:value-of select="'true()'"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="Notes">
		<xsl:call-template name="addFieldset">
			<xsl:with-param name="title">
				<xsl:value-of select="'Notes to Testers'"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="addFieldset">
		<xsl:param name="title"/>
		<xsl:param name="toList"/>
		<fieldset>
			<legend>
				<xsl:value-of select="$title"/>
			</legend>
			<table>
				<thead>
					<tr>
						<th colspan="1" style="height:20px"/>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<xsl:choose>
								<xsl:when test="$toList">
									<xsl:call-template name="toBulletedList">
										<xsl:with-param name="text">
											<xsl:value-of select="text()"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<!-- <td><xsl:copy-of select="node()"/></td> -->
					</tr>
				</tbody>
			</table>
		</fieldset>
	</xsl:template>
	<!-- transform each line of text to bullet -->
	<xsl:template name="toBulletedList">
		<xsl:param name="text"/>
		<ul style="padding-left: 20px;">
			<xsl:for-each select="tokenize($text,'\n')">
				<xsl:if test="matches(.,'\S+')">
					<li>
						<xsl:value-of select="."/>
					</li>
				</xsl:if>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<!-- insert line breaks in text -->
	<xsl:template match="text()" name="insertBreaks">
		<xsl:param name="pText" select="."/>
		<xsl:choose>
			<xsl:when test="not(contains($pText, '&#xA;'))">
				<xsl:copy-of select="$pText"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring-before($pText, '&#xA;')"/>
				<br/>
				<xsl:call-template name="insertBreaks">
					<xsl:with-param name="pText" select="substring-after($pText, '&#xA;')"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- css -->
	<xsl:template name="css">
		<style type="text/css">@media screen { 
                                maskByMediaType {display:table;} 
                                fieldset table tbody tr th {font-size:90%} 
                                fieldset table tbody tr td {font-size:90%;} 
                                fieldset table tbody tr th {text-align:left;background:#C6DEFF} 
                                fieldset table thead tr th {text-align:center;}
                                fieldset table thead tr th:first-child {width:15%;} 
                                fieldset table thead tr th:nth-child(2) {width:35%;} 
                                fieldset table thead tr th:nth-child(3) {width:35%;}
                                fieldset table thead tr th:last-child {width:10%;} 
                                fieldset {text-align:center;}
                                fieldset table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;border-collapse: collapse;} 
                                fieldset table tr { border: 3px groove; } 
                                fieldset table th { border: 2px groove;} 
                                fieldset table td { border: 2px groove; } 
                                fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;} 
                                fieldset table tbody tr td {text-align:left} .embSpace {padding-left:15px;} .embSubSpace {padding-left:25px;} .childField {background:#B8B8B8;} } 
                                fieldset table tbody tr td div ul {padding-left:60px}
                                @media print { maskByMediaType {display:table;} 
                                fieldset table tbody tr th {font-size:70%} 
                                fieldset table tbody tr td {font-size:70%;} 
                                fieldset table tbody tr th {text-align:left;background:#C6DEFF}
                                fieldset table thead tr th {text-align:center;font-size:70%;}
                                fieldset legend {text-align:center;font-size:70%;}
                                fieldset table thead tr th:first-child {width:15%;}
                                fieldset table thead tr th:nth-child(2) {width:35%;}
                                fieldset table thead tr th:nth-child(3) {width:35%;} 
                                fieldset table thead tr th:last-child {width:10%;} 
                                fieldset {text-align:center;page-break-inside: avoid;} 
                                fieldset table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;border-collapse: collapse;page-break-inside: avoid;} fieldset table tr { border: 3px groove; } 
                                fieldset table th { border: 2px groove;}
                                fieldset table td { border: 2px groove; } 
                                fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;} 
                                fieldset table tbody tr td {text-align:left} .embSpace {padding-left:10px;} .embSubSpace {padding-left:20px;} .childField {background:#B8B8B8;} } @page { counter-increment: page; @bottom-center { content: "Page " counter(page); } } @page :left { margin-left: 5%; margin-right: 5%; } @page :right { margin-left: 5%; margin-right: 5%; }
                                fieldset table tbody tr td div ul {padding-left:60px}
                    </style>
	</xsl:template>
</xsl:stylesheet>
