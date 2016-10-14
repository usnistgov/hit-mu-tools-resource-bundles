<?xml version="1.0" encoding="UTF-8"?>
<!-- LOI specific package aggregator -->
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="fn xs fn">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<xsl:param name="testCaseId"/>
	<xsl:param name="testCaseType"/>
	

	<xsl:template match="/">
		<html>
			<head>
				<xsl:call-template name="css"/>
			</head>
			<body>
				<!-- add cover page -->
				<xsl:call-template name="cover-page"/>
				<!-- add test case information page -->
				<xsl:call-template name="test-case-info"/>
				<!-- add each entry -->
				 <xsl:for-each select="aggregator/entry">
				 	<xsl:sort select="@order"/>
				 	<xsl:call-template name="entry"/>
				 </xsl:for-each>
				
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="entry">
		<!-- add page break -->
		<div class="pgBrk"/>
		<!--  add title -->
		<xsl:call-template name="buildPageTitle">
			<xsl:with-param name="content" select="@title" />
		</xsl:call-template>
		<!-- process body -->
		<xsl:apply-templates select="document(.)/*/body"/>
	</xsl:template>
	
	
	<!-- process body -->
	<xsl:template match="body">
		<xsl:apply-templates/>
	</xsl:template>

	
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" />
		</xsl:copy>
	</xsl:template>
	
	<!-- insert title -->
	<xsl:template name="buildPageTitle">
		<xsl:param name="content" />
		<h2>
			<xsl:value-of select="$content" />
		</h2>
		<br />
	</xsl:template>
	
	<!--  replace legend -->
	<xsl:template match="legend">
		<div class="title"><xsl:apply-templates /></div>
	</xsl:template>
	
	<xsl:template name="test-case-info">
		<!-- add page break -->
		<div class="pgBrk"/>
		<div class="test-case-info">
			<h1>eDOS Test Case <xsl:value-of select="$testCaseId"/>
			</h1>
			<br/>
			<h2>
				<xsl:value-of select="$testCaseType"/>
			</h2>
		</div>
	</xsl:template>
	
	<!-- cover page -->
	<!-- TODO Title and version could be parameters -->
	<xsl:template name="cover-page">
		<div id="test-pkg-cover-page">
			<br/>
			<br/>
			<br/>
			<br/>
			<h1>NIST HL7 V2 Validation Tool Test Data</h1>
			<h1>Electronic Directory Of Service (eDOS)</h1>
			<br/>
			<br/>
			<br/>
			<h3>Version 1.0</h3>
			<br/>
			<h3>
				<xsl:value-of select="format-date(current-date(), '[D1o] [MNn], [Y]', 'en', (), ())"/>
			</h3>
		</div>
	</xsl:template>
	<!-- css -->
	<xsl:template name="css">
		<style type="text/css">
			@page {
				margin-top:2cm;
				margin-bottom:2.5cm;
				padding-top:25px;
				padding-bottom:25px;
				counter-increment: page;
				border: 1px solid;
				@bottom-right {
					content: "Page " counter(page);
				}
				@top-center {
					content: "NIST HL7 V2 eDOS Validation Tool Test Data";
				}
				@bottom-center {
					content: "National Institute of Standards and Technology (NIST)";
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

			@page :top {
				margin-top: 7%;
				margin-bottom: 7%;

			}

        	@media print {
			<!-- table -->
			fieldset {text-align:center;}
         	fieldset table {width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;border-collapse:separate;border-spacing:0px;}
         	
         	fieldset table tr { page-break-inside: avoid}
         	fieldset table th { border: 2px groove;}
         	fieldset table td { border: 2px groove;}
                  	
         	<!-- table header -->
         	fieldset table thead tr th {text-align:center;background:#4682B4}
         	fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;}
         	
         	<!-- table body -->
         	fieldset table tbody tr th {font-size:80%;text-align:left;background:#C6DEFF;}     	
         	fieldset table tbody tr td {font-size:80%;text-align:left;}
         	
         	<!-- no data : grey -->
         	.noData {background:#B8B8B8;}
         	<!-- non primitive component : grey -->
         	.childField {background:#B8B8B8;}
         	
         	
         	<!-- er7 message display -->
         	.hl7Message {width:100%;font-size:75%;}
<!--          	fieldset#er7Message table {border:0px;width:80%} -->
<!--          	fieldset#er7Message td {background:#B8B8B8;font-size:65%;margin-top:6.0pt;border:0px;text-wrap:preserve-breaks;white-space:pre;} -->
<!--          	.er7Msg {width:100%;font-size:80%;} -->
<!--          	.er7MsgNote{width:100%;font-style:italic;font-size:80%;} -->
         	
         	<!-- space -->
         	.embSpace {padding-left:15px;}
         	.embSubSpace {padding-left:25px;}
         	
         	<!-- headings -->
         	h3 {text-align:center;}
         	h2 {text-align:center;}
         	h1 {text-align:center;}
         	
         	<!-- misc -->
         	.title {text-align:left;margin-bottom:1%}
         	.pgBrk {page-break-after:always;}
         	.hidden {display:none;}
         	
         	
         	<!-- caca -->
<!--          	.obxGrpSpl {background:#B8B8B8;} -->
<!--          	maskByMediaType {display:table;} -->
<!--          	fieldset table[id=vendor-labResults] thead tr {font-size:80%} -->
<!--          	fieldset table[id=vendor-labResults] tbody tr {font-size:75%} -->
         	}
		</style>
	</xsl:template>
	
</xsl:stylesheet>