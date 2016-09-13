<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:util="http://hl7.nist.gov/data-specs/util" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs" version="2.0">

	<!-- character map is used for being able to output these special html entities directly after escaping -->
	<xsl:character-map name="tags">
		<xsl:output-character character="&lt;" string="&lt;"/>
		<xsl:output-character character="&gt;" string="&gt;"/>
	</xsl:character-map>
	<xsl:output method="xhtml" use-character-maps="tags"/>
	<!--  Use this section for supportd profiles -->
	<xsl:variable name="OML_O21" select="'OML_O21'"/>
	<!--  ROOT TEMPLATE. Call corresponding sub templates based on the output desired (parametrized) -->
	<xsl:template match="*">
		<xsl:call-template name="plain-html"/>
	</xsl:template>
	<!-- This generates the structured DATA -->
	<xsl:template name="main">
		<!-- - - - programatically determine if it is a OML_O21. Add here any other message type if necessary - -->
		<xsl:variable name="message-type">
			<xsl:choose>
				<xsl:when test="starts-with(name(.), 'OML_O21')">
					<xsl:value-of select="$OML_O21"/>
				</xsl:when>
				<!-- other message types-->
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="util:start()"/>
		<!-- - - - - - Patient information - - - - - - - - - - - -->
		<xsl:apply-templates select="//OML_O21.PATIENT/PID"/>
		<!-- - - - - - Next of a kin information  - - - - - - - - - - - -->
		<xsl:apply-templates select="//OML_O21.PATIENT/NK1"/>
		<!-- - - - - - Order information   - - - - - - - - - - - -->
		<xsl:apply-templates select="//OML_O21.ORDER"/>
		<xsl:value-of select="util:end()"/>
	</xsl:template>
	<!-- Indentation values so that the output is readable -->
<!--	<xsl:variable name="ind1" select="'&#9;&#9;'"/>
	<xsl:variable name="ind2" select="'&#9;&#9;&#9;&#9;&#9;'"/>-->
	<!-- - - - - - Patient information - - - - - - - - - - - -->
	<xsl:template match="PID">
		<xsl:value-of select="util:title('title', 'Patient Information')"/>
		<xsl:value-of select="util:elements()"/>
		<!-- Patient Name :
			PID.5.2 : First name
			PID.5.3 : Middle name
			PID.5.4 : Suffix
			PID.5.1.1 : Family name
		-->
		<xsl:value-of select="util:element('Patient Name', concat(util:format-with-space(.//PID.5.2), util:format-with-space(.//PID.5.3),util:format-with-space(.//PID.5.4),.//PID.5.1.1))"/>
		<!-- Mother''s Maiden Name :
			PID.6.2 : First name
			PID.6.3 : Middle name
			PID.6.4 : Suffix
			PID.6.1.1 : Family name
		-->
		<xsl:value-of select="util:element('Mother''s Maiden Name', concat(util:format-with-space(.//PID.6.2), util:format-with-space(.//PID.6.3),util:format-with-space(.//PID.6.4),.//PID.6.1.1))"/>
		<xsl:value-of select="util:element('Date/Time of Birth',util:format-date(.//PID.7.1))"/>
		<xsl:value-of select="util:element('Administrative Sex', .//PID.8)"/>
		<!-- Patient Address 
			PID.11[1].1.1 : street
			PID.11[1].2 : other designation
			PID.11[1].3 : city
			PID.11[1].4 : state 
			PID.11[1].5 : zip code
			PID.11[1].6 : country
		-->
		<xsl:for-each select=".//PID.11">
			<xsl:value-of select="util:element('Patient Address', concat(util:format-address(.//PID.11.1.1,.//PID.11.2, .//PID.11.3, .//PID.11.4, .//PID.11.5),.//PID.11.6))"/>
		</xsl:for-each>
		<xsl:value-of select="util:element('Local Number', util:format-tel(.//PID.13.6,.//PID.13.7))"/>
		<xsl:for-each select=".//PID.10">
			<xsl:value-of select="util:element('Race', .//PID.10.2)"/>
		</xsl:for-each>
		<xsl:value-of select="util:last-element('Ethnic Group',.//PID.22.2)"/>
	</xsl:template>
	<!-- - - - - - Guardian or Responsible Party - - - - - - - - - - - -->
	<xsl:template match="NK1">
		<xsl:value-of select="util:title('title', 'Guardian or Responsible Party')"/>
		<xsl:value-of select="util:elements()"/>
		<!-- Name :
			NK1.2.2 : First name
			NK1.2.3 : Middle name
			NK1.2.4 : Suffix
			NK1.2.1.1 : Family name
		-->
		<xsl:value-of select="util:element('Name', concat(util:format-with-space(.//NK1.2.2), util:format-with-space(./NK1.2.3),util:format-with-space(.//NK1.2.4),.//NK1.2.1.1))"/>
		<xsl:value-of select="util:element('Organization name', .//NK1.13.1)"/>
		<xsl:value-of select="util:element('Contact Person', concat(util:format-with-space(.//NK1.30.2), util:format-with-space(./NK1.30.3),util:format-with-space(.//NK1.30.4),./NK1.30.1.1))"/>
		<xsl:value-of select="util:element('Contact Person Address', concat(util:format-address(.//NK1.32.1.1,.//NK1.32.2, .//NK1.32.3, .//NK1.32.4, .//NK1.32.5),.//NK1.32.6))"/>
		<xsl:value-of select="util:element('Relationship', .//NK1.3.2)"/>
		<xsl:for-each select=".//NK1.4">
			<xsl:value-of select="util:element('Address', concat(util:format-address(.//NK1.4.1.1,.//NK1.4.2, .//NK1.4.3, .//NK1.4.4, .//NK1.4.5),.//NK1.4.6))"/>
		</xsl:for-each>
		<xsl:for-each select=".//NK1.5">
			<xsl:value-of select="util:element('Phone Number or Email address', concat(util:format-with-space(.//NK1.5.4), util:format-tel(.//NK1.5.6, .//NK1.5.7)))"/>
		</xsl:for-each>
		<xsl:value-of select="util:element('Contact role', .//NK1.7.2)"/>
		<xsl:value-of select="util:last-element('Associated Parties Job Code/Class', .//NK1.11.3)"/>
	</xsl:template>
	<!-- - - - - - Order Information- - - - - - - - - - - -->
	<xsl:template match="OML_O21.ORDER">
		<!--TODO order fieldset -->
		<xsl:value-of select="util:tags('fieldset', '')"/>
		<xsl:value-of select="util:tags('legend', 'Order')"/>
		<!-- Odering Provider -->
		<xsl:apply-templates select=".//ORC" mode="provider"/>
		<!-- Odering Facility -->
		<xsl:if test="count(.//ORC.21 | .//ORC.22 | .//ORC.23) > 0">
			<xsl:apply-templates select=".//ORC" mode="facility"/>
		</xsl:if>
		<!-- General order information -->
		<xsl:apply-templates select=".//ORC" mode="general"/>
		<!-- Order details  -->
		<xsl:apply-templates select=".//OBR"/>
		<!-- Timing/Quantity Information -->
		<xsl:if test="count(.//TQ1) >0">
			<xsl:apply-templates select=".//TQ1"/>
		</xsl:if>
		<!--Notes & Comments-->
		<xsl:if test="count(.//NTE) >0">
			<!-- merge NTEs in one table -->
			<xsl:value-of select="util:title('title', 'Notes &amp; Comments')"/>
			<xsl:value-of select="util:elements()"/>
			<xsl:apply-templates select=".//NTE"/>
			<xsl:value-of select="util:end-elements()"/>
		</xsl:if>
		<!--Result Copies-->
		<xsl:if test="count(.//PRT) >0">
			<xsl:apply-templates select=".//PRT"/>
		</xsl:if>
		<!--Diagnosis Information-->
		<xsl:if test="count(.//DG1) >0">
			<xsl:apply-templates select=".//DG1"/>
		</xsl:if>
		<!--Ask at order entry observations-->
		<xsl:if test="count(.//OBX) >0">
			<xsl:apply-templates select=".//OBX"/>
		</xsl:if>
		<!--Specimen information-->
		<xsl:if test="count(.//SPM) >0">
			<xsl:apply-templates select=".//SPM"/>
		</xsl:if>
		<xsl:value-of select="util:tags('/fieldset', '')"/>
		<!--					<xsl:choose>
						<xsl:when test="$output = 'plain-html'">
							<xsl:value-of select="util:tags('/fieldset', '')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($ind1, '}', $nl)"/>
						</xsl:otherwise>
					</xsl:choose>-->
	</xsl:template>
	<xsl:template match="ORC" mode="provider">
		<xsl:value-of select="util:title('title', 'Ordering Provider')"/>
		<xsl:value-of select="util:elements()"/>
		<xsl:value-of select="util:element('Provider Name', concat(util:format-with-space(.//ORC.12.3),.//ORC.12.2.1))"/>
		<xsl:value-of select="util:element('Provider NPI identifier',.//ORC.12.1)"/>
		<!-- if there is no ORC.14, we still want the element with no data in the html -->
		<xsl:if test="count(.//ORC.14) = 0">
			<xsl:value-of select="util:element-with-delimiter('Call Back Phone Number',  '','')"/>
		</xsl:if>
		<xsl:for-each select=".//ORC.14">
			<xsl:choose>
				<xsl:when test="position() = last()">
					<!-- last element : no delimiter -->
					<xsl:value-of select="util:element-with-delimiter('Call Back Phone Number',  concat(util:format-with-space(.//ORC.14.4), util:format-tel(.//ORC.14.6, .//ORC.14.7)),'')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="util:element('Call Back Phone Number',  concat(util:format-with-space(.//ORC.14.4), util:format-tel(.//ORC.14.6, .//ORC.14.7)))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:value-of select="util:end-elements()"/>
	</xsl:template>
	<xsl:template match="ORC" mode="facility">
		<xsl:value-of select="util:title('title', 'Ordering Facility ')"/>
		<xsl:value-of select="util:elements()"/>
		<xsl:value-of select="util:element('Facility Name',.//ORC.21.1)"/>
		<xsl:value-of select="util:element('Facility NPI identifier',.//ORC.21.10.1)"/>
		<xsl:value-of select="util:element('Address',concat(util:format-address(.//ORC.22.1.1,.//ORC.22.2, .//ORC.22.3, .//ORC.22.4, .//ORC.22.5),.//ORC.22.6))"/>
		<xsl:value-of select="util:last-element('Phone Number',  concat(util:format-with-space(.//ORC.23.4), util:format-tel(.//ORC.23.6, .//ORC.23.7)))"/>
	</xsl:template>
	<xsl:template match="ORC" mode="general">
		<xsl:value-of select="util:title('title', 'General order information')"/>
		<xsl:value-of select="util:elements()"/>
		<xsl:value-of select="util:element('Placer Order Number',.//ORC.2.1)"/>
		<xsl:value-of select="util:element('Filler Order Number',.//ORC.3.1)"/>
		<xsl:value-of select="util:element('Placer Group Number',.//ORC.4.1)"/>
		<xsl:value-of select="util:element('Order Control',.//ORC.1)"/>
		<xsl:value-of select="util:element('Date/Time of Transaction',.//ORC.9.1)"/>
		<xsl:value-of select="util:element('Order Effective Date/Time',.//ORC.15.1)"/>
		<xsl:value-of select="util:element('Order Control Code Reason',.//ORC.16.2)"/>
		<xsl:value-of select="util:element('Advanced Beneficiary Notice',.//ORC.20.2)"/>
		<xsl:value-of select="util:last-element('Enterer Authorization Mode',.//ORC.30.2)"/>
	</xsl:template>
	<xsl:template match="OBR">
		<xsl:value-of select="util:title('title', 'Order details')"/>
		<xsl:value-of select="util:elements()"/>
		<xsl:value-of select="util:element('Universal service identifier',.//OBR.4.1)"/>
		<xsl:value-of select="util:element('Universal service identifier code system',.//OBR.4.3)"/>
		<xsl:value-of select="util:element('Universal service identifier text',.//OBR.4.2)"/>
		<xsl:value-of select="util:element('Universal service identifier (alternate)',.//OBR.4.4)"/>
		<xsl:value-of select="util:element('Universal service identifier (alternate) text',.//OBR.4.5)"/>
		<xsl:value-of select="util:last-element('Relevant clinical information',  .//OBR.13.2)"/>
	</xsl:template>
	<xsl:template match="TQ1">
		<xsl:value-of select="util:title('title', 'Timing/Quantity Information ')"/>
		<xsl:value-of select="util:elements()"/>
		<xsl:value-of select="util:element('Start date and time', .//TQ1.7.1)"/>
		<xsl:value-of select="util:element('End date and time', .//TQ1.8.1)"/>
		<xsl:value-of select="util:last-element('Priority',  .//TQ1.9.1)"/>
	</xsl:template>
	<xsl:template match="NTE">
		<xsl:variable name="position" select="position()"/>
		<xsl:variable name="last" select="last()"/>
		<xsl:for-each select=".//NTE.3">
			<xsl:choose>
				<xsl:when test="$position = $last and position() = last()">
					<!-- last element : no delimiter -->
					<xsl:value-of select="util:element-with-delimiter('Comments', .,'')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="util:element('Comments', .)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="PRT">
		<xsl:value-of select="util:title('title', 'Result Copies To')"/>
		<xsl:value-of select="util:elements()"/>
		<xsl:value-of select="util:element('Instance ID', .//PRT.1.1)"/>
		<xsl:value-of select="util:element('NPI identifier', .//PRT.5.1)"/>
		<xsl:value-of select="util:element('Name', concat(util:format-with-space(.//PRT.5.3),.//PRT.5.1))"/>
		<xsl:value-of select="util:element('Address', concat(util:format-address(.//PRT.14.1.1,.//PRT.14.2, .//PRT.14.3, .//PRT.14.4, .//PRT.14.5),.//PRT.14.6))"/>
		<!-- if there is no PRT.15, we still want the element with no data in the html -->
		<xsl:if test="count(.//PRT.15) = 0">
			<xsl:value-of select="util:element-with-delimiter('Number',  '','')"/>
		</xsl:if>
		<xsl:for-each select=".//PRT.15">
			<xsl:choose>
				<xsl:when test="position() = last()">
					<!-- last element : no delimiter -->
					<xsl:value-of select="util:element-with-delimiter('Number',  concat(util:format-with-space(.//PRT.15.4), util:format-tel(.//PRT.15.6, .//PRT.15.7)),'')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="util:element('Number',  concat(util:format-with-space(.//PRT.15.4), util:format-tel(.//PRT.15.6, .//PRT.15.7)))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:value-of select="util:end-elements()"/>
	</xsl:template>
	<xsl:template match="DG1">
		<xsl:value-of select="util:title('title', 'Diagnosis Information')"/>
		<xsl:value-of select="util:elements()"/>
		<xsl:value-of select="util:element('Priority', .//DG1.15)"/>
		<xsl:value-of select="util:element('Diagnosis Code', .//DG1.3.1)"/>
		<xsl:value-of select="util:element('Diagnosis Code (code system)', .//DG1.3.3)"/>
		<xsl:value-of select="util:element('Diagnosis Code (text)', .//DG1.3.2)"/>
		<xsl:value-of select="util:element('Diagnosis Type', .//DG1.6)"/>
		<xsl:value-of select="util:end-elements()"/>
	</xsl:template>
	<xsl:template match="OBX">
		<xsl:value-of select="util:title('title', 'Ask at order entry observations ')"/>
		<xsl:value-of select="util:elements()"/>
		<xsl:value-of select="util:element('Identifier', .//OBX.3.2)"/>
		<xsl:variable name="datatype" select=".//OBX.2"/>
		<xsl:choose>
			<xsl:when test="$datatype='NM'">
				<xsl:value-of select="util:element('Value', concat(util:format-with-space(.//OBX.5),util:format-with-space(.//OBX.6.2)))"/>
			</xsl:when>
			<xsl:when test="$datatype='DT'">
				<xsl:value-of select="util:element('Value', .//OBX.5)"/>
			</xsl:when>
			<xsl:when test="$datatype='CWE'">
				<xsl:value-of select="util:element('Value', .//OBX.5.2)"/>
			</xsl:when>
		</xsl:choose>
		<xsl:value-of select="util:element('Observation Result Status', .//OBX.11)"/>
		<xsl:value-of select="util:element('Date/Time', .//OBX.14.1)"/>
		<xsl:value-of select="util:element('Observation Type', .//OBX.29)"/>
		<xsl:value-of select="util:end-elements()"/>
	</xsl:template>
	<xsl:template match="SPM">
		<xsl:value-of select="util:title('title', 'Specimen information')"/>
		<xsl:value-of select="util:elements()"/>
		<xsl:value-of select="util:element('Placer identifier', .//SPM.2.1.1)"/>
		<xsl:value-of select="util:element('Filler identifier', .//SPM.2.2.1)"/>
		<xsl:value-of select="util:element('Specimen Type', .//SPM.4.2)"/>
		<xsl:value-of select="util:element('Specimen Type(alternate)', .//SPM.4.5)"/>
		<xsl:value-of select="util:element('Specimen Type (original)', .//SPM.4.9)"/>
		<xsl:value-of select="util:element('Type Modifier', .//SPM.5.2)"/>
		<xsl:value-of select="util:element('Additives', .//SPM.6.2)"/>
		<xsl:value-of select="util:element('Collection Start Date/Time', .//SPM.17.1.1)"/>
		<xsl:value-of select="util:element('Collection End Date/Time', .//SPM.17.2.1)"/>
		<xsl:value-of select="util:element('Collection Method', .//SPM.7.2)"/>
		<xsl:value-of select="util:element('Source Site', .//SPM.8.2)"/>
		<xsl:value-of select="util:element('Source Site Modifier', .//SPM.9.2)"/>
		<xsl:value-of select="util:end-elements()"/>
	</xsl:template>
	<!-- plain-html : create a head with css and a body around the "main" template to make it a plain html -->
	<xsl:template name="plain-html">
		<html>
			<head>
				<xsl:call-template name="css"/>
			</head>
			<body>
				<xsl:call-template name="main"/>
			</body>
		</html>
	</xsl:template>
	<!-- css template to be output in the head for html outputs -->
	<!-- contains style for graying out and separator -->
	<xsl:template name="css">
		<style type="text/css">
		@media screen {		
		.test-data-specs-main .tds_obxGrpSpl {background:#B8B8B8;}			
		.test-data-specs-main maskByMediaType {display:table;}			
		.test-data-specs-main fieldset table tbody tr th {font-size:95%}			
		.test-data-specs-main fieldset table tbody tr td {font-size:100%;}			
		.test-data-specs-main fieldset table tbody tr th {text-align:left;background:#C6DEFF}			
		.test-data-specs-main fieldset table thead tr th {text-align:center;}			
		.test-data-specs-main fieldset {text-align:center;}			
		.test-data-specs-main fieldset table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;border-collapse: collapse;}			
		.test-data-specs-main fieldset table  tr { border: 3px groove; }			
		.test-data-specs-main fieldset table  th { border: 2px groove;}			
		.test-data-specs-main fieldset table  td { border: 2px groove; }			
		.test-data-specs-main fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;}			
		.test-data-specs-main fieldset table tbody tr td {text-align:left}			
		/* .test-data-specs-main .tds_noData {background:#B8B8B8;}		*/
		/* Don't display empty rows */
		.test-data-specs-main .tds_noData {display:none;}

		.test-data-specs-main .tds_childField {background:#B8B8B8;}			
		.test-data-specs-main .tds_title {text-align:left;}			
		.test-data-specs-main h3 {text-align:center;page-break-inside: avoid;}			
		.test-data-specs-main h2 {text-align:center;}			
		.test-data-specs-main h1 {text-align:center;}			
		.test-data-specs-main .tds_pgBrk {padding-top:15px;}			
		.test-data-specs-main .tds_er7Msg {width:100%;}			
		.test-data-specs-main .tds_embSpace {padding-left:15px;}			
		.test-data-specs-main .tds_embSubSpace {padding-left:25px;}			
		}	
			
			@media print {
		.test-data-specs-main 
		.tds_obxGrpSpl {background:#B8B8B8;}			
		.test-data-specs-main tds_maskByMediaType {display:table;}			
		.test-data-specs-main fieldset table tbody tr th {font-size:90%}			
		.test-data-specs-main fieldset table tbody tr td {font-size:90%;}			
		.test-data-specs-main fieldset table tbody tr th {text-align:left;background:#C6DEFF}			
		.test-data-specs-main fieldset table thead tr th {text-align:center;background:#4682B4}			
		.test-data-specs-main fieldset {text-align:center;page-break-inside: avoid;}			
		.test-data-specs-main fieldset table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;page-break-inside: avoid;border-collapse: collapse;}			
		.test-data-specs-main fieldset table[id=vendor-labResults] thead tr {font-size:80%}			
		.test-data-specs-main fieldset table[id=vendor-labResults] tbody tr {font-size:75%}			
		.test-data-specs-main fieldset table  tr { border: 3px groove; }			
		.test-data-specs-main fieldset table  th { border: 2px groove;}			
		.test-data-specs-main fieldset table  td { border: 2px groove; }			
		.test-data-specs-main fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;}			
		.test-data-specs-main fieldset table tbody tr td {text-align:left;}			
		.test-data-specs-main .tds_noData {background:#B8B8B8;}			
		.test-data-specs-main .tds_childField {background:#B8B8B8;}			
		.test-data-specs-main .tds_title {text-align:left;margin-bottom:1%}			
		.test-data-specs-main h3 {text-align:center;}			
		.test-data-specs-main h2 {text-align:center;}			
		.test-data-specs-main h1 {text-align:center;}	
			.test-data-specs-main .tds_pgBrk {page-break-after:always;}
			.test-data-specs-main fieldset#tds_er7Message table {border:0px;width:80%}
			.test-data-specs-main fieldset#tds_er7Message td {background:#B8B8B8;font-size:65%;margin-top:6.0pt;border:0px;text-wrap:preserve-breaks;white-space:pre;}
			.test-data-specs-main .tds_er7Msg {width:100%;font-size:80%;}
			.test-data-specs-main .tds_er7MsgNote{width:100%;font-style:italic;font-size:80%;}
			.test-data-specs-main .tds_embSpace {padding-left:15px;}
			.test-data-specs-main .tds_embSubSpace {padding-left:25px;}
			}
		</style>
	</xsl:template>
	<!--  util: generic functions for string manipulations  -->
	<!-- format-trailing: add the padding if non-empty; called from format-with-space -->
	<xsl:function name="util:format-trailing">
		<xsl:param name="value"/>
		<xsl:param name="padding"/>
		<xsl:value-of select="$value"/>
		<xsl:if test="$value != ''">
			<xsl:value-of select="$padding"/>
		</xsl:if>
	</xsl:function>
	<!-- add a trailing space if non empty -->
	<xsl:function name="util:format-with-space">
		<xsl:param name="value"/>
		<xsl:value-of select="util:format-trailing($value, ' ')"/>
	</xsl:function>
	<!-- format-tel: take a string and format it as (abc)efg-higk -->
	<xsl:function name="util:format-tel">
		<xsl:param name="areacode"/>
		<xsl:param name="phonenumberin"/>
		<!-- pad it so that length problems don't happen -->
		<xsl:variable name="phonenumber" select="concat($phonenumberin, '                ')"/>
		<xsl:if test="$areacode != '' and $phonenumber != ''">
			<xsl:variable name="areaCode" select="concat('(',$areacode,')')"/>
			<xsl:variable name="localCode" select="concat(substring($phonenumber,1,3),'-')"/>
			<xsl:variable name="idCode" select="substring($phonenumber,4,4)"/>
			<xsl:value-of select="concat($areaCode,$localCode,$idCode)"/>
		</xsl:if>
	</xsl:function>
	<!-- format-address: concatenate the individual elements, adding spaces when necessary -->
	<xsl:function name="util:format-address">
		<xsl:param name="street"/>
		<xsl:param name="other"/>
		<xsl:param name="city"/>
		<xsl:param name="state"/>
		<xsl:param name="zip"/>
		<xsl:value-of select="concat(util:format-with-space($street), util:format-with-space($other), util:format-with-space($city), util:format-with-space($state), util:format-with-space($zip))"/>
	</xsl:function>
	<!-- tags: most important functions; if you pass X, Y, and indentation it outputs <X> Y </X> ; if Y is empty, however, it produces only <X>  -->
	<xsl:function name="util:tags">
		<xsl:param name="tag"/>
		<xsl:param name="content"/>
		<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
		<xsl:value-of select="$tag"/>
		<xsl:text disable-output-escaping="yes">></xsl:text>
		<xsl:if test="$content != ''">
			<xsl:value-of select="$content"/>
			<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
			<xsl:value-of select="$tag"/>
			<xsl:text disable-output-escaping="yes">></xsl:text>
		</xsl:if>
	</xsl:function>
	<!--  format-date: takes a string and makes it a date mm/nn/yyyy -->
	<xsl:function name="util:format-date">
		<xsl:param name="elementDataIn"/>
		<!-- pad it so that length problems don't happen -->
		<xsl:variable name="elementData" select="concat($elementDataIn, '                ')"/>
		<xsl:if test="string-length(normalize-space($elementData)) &gt; 0">
			<xsl:variable name="year" select="substring($elementData,1,4)"/>
			<xsl:variable name="month" select="concat(substring($elementData,5,2),'/')"/>
			<xsl:variable name="day" select="concat(substring($elementData,7,2),'/')"/>
			<xsl:value-of select="concat($month,$day,$year)"/>
			<!-- <xsl:value-of select="format-date(xs:date(concat($month,$day,$year)),'[D1o] 
				[MNn], [Y]', 'en', (), ())"/> -->
		</xsl:if>
	</xsl:function>
	<!-- some useful variables -->
	<xsl:variable name="indent" select="'&#9;'"/>
	<xsl:variable name="nl" select="'&#10;'"/>
	<!-- title: <fieldset> <legend> title </legend> in case of html; -->
	<!-- note that the function last-element ends the table, but the param endprevioustable generates </table></fieldset> if the previous table is open (as in the case of starting OBX) -->
	<xsl:function name="util:title">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:value-of select="util:tags('fieldset', '')"/>
		<xsl:value-of select="util:tags('legend', $value)"/>
	</xsl:function>
	<!-- elements: <table><tbody><tr><th>Element </th> <th> Data </th> </tr>  -->
	<xsl:function name="util:elements">
		<xsl:value-of select="util:tags('table', '')"/>
		<xsl:value-of select="util:tags('tbody', '')"/>
		<xsl:value-of select="util:tags('tr', '')"/>
		<xsl:value-of select="util:tags('th', 'Element')"/>
		<xsl:value-of select="util:tags('th', 'Data')"/>
		<xsl:value-of select="util:tags('/tr', '')"/>
	</xsl:function>
	<!-- end-elements: </tbody></table></fieldset> , to denote the end of the table -->
	<xsl:function name="util:end-elements">
		<xsl:variable name="end-elements">
			<xsl:value-of select="util:tags('/tbody', '')"/>
			<xsl:value-of select="util:tags('/table', '')"/>
			<xsl:value-of select="util:tags('/fieldset', '')"/>
		</xsl:variable>
		<xsl:value-of select="$end-elements"/>
	</xsl:function>
	<!--  element: calls element-with-delimiter with value , ; basically generates table row element -->
	<xsl:function name="util:element">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:value-of select="util:element-with-delimiter($name, $value, ',')"/>
	</xsl:function>
	<!-- last-element: just like element, but also generates </tbody></table></fieldset> at the end-->
	<xsl:function name="util:last-element">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:value-of select="util:element-with-delimiter($name, $value, '')"/>
		<xsl:value-of select="util:tags('/tbody', '')"/>
		<xsl:value-of select="util:tags('/table', '')"/>
		<xsl:value-of select="util:tags('/fieldset', '')"/>
	</xsl:function>
	<!-- element-with-delimiter:  generates <tr> <td> name </td> <td> value </td> </tr>  (adds a class 'tds_noData' to gray out if value is empty -->
	<xsl:function name="util:element-with-delimiter">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="trailing"/>
		<!-- td elements -->
		<xsl:variable name='td-element'>
			<xsl:value-of select="util:tags('td', $name)"/>
			<xsl:choose>
				<xsl:when test="normalize-space($value) = ''">
					<xsl:value-of select="util:tags('td class=''tds_noData''', '')"/>
					<xsl:value-of select="$value"/>
					<xsl:value-of select="util:tags('/td', '')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="util:tags('td', $value)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- tr element -->
			<xsl:choose>
				<xsl:when test="normalize-space($value) = ''">
						<xsl:value-of select="util:tags('tr class=''tds_noData''','')"/>
						<xsl:value-of select= "$td-element"/>
						<xsl:value-of select="util:tags('/tr','')"/>
				</xsl:when>
				<xsl:otherwise>
						<xsl:value-of select="util:tags('tr', $td-element)"/>

				</xsl:otherwise>
			</xsl:choose>
		
	</xsl:function>
	
<!-- start:  output <div class='test-data-specs'> or if json,   { "profile" : "name-of-profile", "tables" : [ -->
	<xsl:function name="util:start">
		<xsl:value-of select="util:tags('div class=''test-data-specs-main''', '')" />
	</xsl:function>
<!-- end: </div> to end the test-data-specs div;  to end the array of tables -->
	<xsl:function name="util:end">
		<xsl:value-of select="util:tags('/div', '')"/>
	</xsl:function>
</xsl:stylesheet>
