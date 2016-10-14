<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="html"/>
	<xsl:param name="json" select="'{&quot;profile&quot;:&quot;TODO&quot;,&quot;tables&quot;:[{&quot;elements&quot;:[{&quot;element&quot;:&quot;Identifier&quot;,&quot;data&quot;:&quot;OME&quot;},{&quot;element&quot;:&quot;Event code&quot;,&quot;data&quot;:&quot;REP&quot;}],&quot;title&quot;:&quot;Master File Identification&quot;},{&quot;groups&quot;:[{&quot;elements&quot;:[{&quot;element&quot;:&quot;Event code&quot;,&quot;data&quot;:&quot;MAD&quot;},{&quot;element&quot;:&quot;Effective date and time&quot;,&quot;data&quot;:&quot;20131219145310&quot;},{&quot;element&quot;:&quot;Test/Panel Name&quot;,&quot;data&quot;:&quot;Prothrombin Time, PT&quot;},{&quot;element&quot;:&quot;Test/Panel identifier (code system)&quot;,&quot;data&quot;:&quot;11 (99USI)&quot;}],&quot;title&quot;:&quot;Record information&quot;},{&quot;elements&quot;:[{&quot;element&quot;:&quot;Specimen required ?&quot;,&quot;data&quot;:&quot;Y&quot;},{&quot;element&quot;:&quot;Producer&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Preferred Report Name&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Preferred Short  Name&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Preferred Long   Name&quot;,&quot;data&quot;:&quot;Prothrombin Time&quot;},{&quot;element&quot;:&quot;Is the test/panel orderable ?&quot;,&quot;data&quot;:&quot;N&quot;},{&quot;element&quot;:&quot;Nature&quot;,&quot;data&quot;:&quot;A&quot;},{&quot;element&quot;:&quot;Interpretation&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Factors that may affect the test&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Is the test exclusive ?&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Diagnostic Service Sector&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Code for results&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Expected turn around time&quot;,&quot;data&quot;:&quot;&quot;}],&quot;title&quot;:&quot;General information&quot;}],&quot;title&quot;:&quot;Test Details&quot;},{&quot;groups&quot;:[{&quot;elements&quot;:[{&quot;element&quot;:&quot;Event code&quot;,&quot;data&quot;:&quot;MAD&quot;},{&quot;element&quot;:&quot;Effective date and time&quot;,&quot;data&quot;:&quot;20131219145310&quot;},{&quot;element&quot;:&quot;Test/Panel Name&quot;,&quot;data&quot;:&quot;INR&quot;},{&quot;element&quot;:&quot;Test/Panel identifier (code system)&quot;,&quot;data&quot;:&quot;12 (99USI)&quot;}],&quot;title&quot;:&quot;Record information&quot;},{&quot;elements&quot;:[{&quot;element&quot;:&quot;Specimen required ?&quot;,&quot;data&quot;:&quot;N&quot;},{&quot;element&quot;:&quot;Producer&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Preferred Report Name&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Preferred Short  Name&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Preferred Long   Name&quot;,&quot;data&quot;:&quot;International Normalized Ratio&quot;},{&quot;element&quot;:&quot;Is the test/panel orderable ?&quot;,&quot;data&quot;:&quot;N&quot;},{&quot;element&quot;:&quot;Nature&quot;,&quot;data&quot;:&quot;C&quot;},{&quot;element&quot;:&quot;Interpretation&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Factors that may affect the test&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Is the test exclusive ?&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Diagnostic Service Sector&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Code for results&quot;,&quot;data&quot;:&quot;&quot;},{&quot;element&quot;:&quot;Expected turn around time&quot;,&quot;data&quot;:&quot;&quot;}],&quot;title&quot;:&quot;General information&quot;}],&quot;title&quot;:&quot;Test Details&quot;}]}'"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="angular-script">
		<xsl:element name="script">
	console.log('coucou script');
	var app = angular.module('hit-testcase-viewer');
	app.controller('myCtrl', function($scope) {
	console.log('coucou controller');
	var json = JSON.parse('<xsl:value-of select="$json"/>');
	$scope.json = json;
	
	this.full = true;
			this.setTab = function (tabId) {
				this.tab = tabId;
			};
	
			this.isSet = function (tabId) {
				return this.tab === tabId;
			};
	});
	</xsl:element>
	</xsl:template>
	
	<xsl:template match="head|script"/>
	<xsl:template match="html|body">
			<!-- apply template without copying -->
			<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
