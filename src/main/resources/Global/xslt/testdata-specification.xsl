<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:util="http://hl7.nist.gov" xmlns="" xpath-default-namespace="urn:hl7-org:v2xml" exclude-result-prefixes="xs" version="2.0">
	<!--	<xsl:param name="output" select="'json'" />
-->
	<xsl:param name="output" select="'full-html'"/>
	<!--xsl:param name="output" select="'tab-html'" -->
	<xsl:output method="xhtml" indent="no"/>
	<!-- declare variables -->
	<xsl:variable name="OML_O21" select="'OML_O21'"/>
	<xsl:variable name="ind1" select="'&#9;&#9;'"/>
	<xsl:variable name="ind2" select="'&#9;&#9;&#9;&#9;&#9;'"/>
	<xsl:variable name="indent" select="'&#9;'"/>
	<xsl:variable name="nl" select="'&#10;'"/>
	<!-- Example format: { "tables": [ { "title": "Patient Information", "elements": 		[ { "element" : "Patient Name", "data" : "Madelynn Ainsley" }, { "element" 		: "Mother's Maiden Name", "data" : "Morgan" }, { "element" : "ID Number", 		"data" : "A26376273 D26376273 " }, { "element" : "Date/Time of Birth", "data" 		: "07/02/2015" }, ... ] }, ] } -->
	<xsl:template match="*">
		<xsl:choose>
			<xsl:when test="$output = 'json'">
				<xsl:call-template name="main"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="main-html"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="main">
		<xsl:value-of select="util:start(name(.))"/>
		<!-- - - - programatically determine if it is a OML_O21. Add here any other message type if necessary - -->
		<xsl:variable name="message-type">
			<xsl:choose>
				<xsl:when test="starts-with(name(.), 'OML_O21')">
					<xsl:value-of select="$OML_O21"/>
				</xsl:when>
				<!-- other message types-->
			</xsl:choose>
		</xsl:variable>
		<!-- - - - - - Patient information - - - - - - - - - - - -->
		<xsl:apply-templates select="//OML_O21.PATIENT/PID"/>
		<!-- - - - - - Next of a kin information  - - - - - - - - - - - -->
		<xsl:apply-templates select="//OML_O21.PATIENT/NK1"/>
		<!-- - - - - - Order information   - - - - - - - - - - - -->
		<xsl:apply-templates select="//OML_O21.ORDER"/>
		<xsl:value-of select="util:end($ind1)"/>
	</xsl:template>
	<!-- - - - - - Patient information - - - - - - - - - - - -->
	<xsl:template match="PID">
		<xsl:value-of select="util:title('title', 'Patient Information', $ind1, false())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<!-- Patient Name :
			PID.5.2 : First name
			PID.5.3 : Middle name
			PID.5.4 : Suffix
			PID.5.1.1 : Family name
		-->
		<xsl:value-of select="util:element('Patient Name', concat(util:format-with-space(.//PID.5.2), util:format-with-space(.//PID.5.3),util:format-with-space(.//PID.5.4),.//PID.5.1.1), $ind1)"/>
		<!-- Mother''s Maiden Name :
			PID.6.2 : First name
			PID.6.3 : Middle name
			PID.6.4 : Suffix
			PID.6.1.1 : Family name
		-->
		<xsl:value-of select="util:element('Mother''s Maiden Name', concat(util:format-with-space(.//PID.6.2), util:format-with-space(.//PID.6.3),util:format-with-space(.//PID.6.4),.//PID.6.1.1), $ind1)"/>
		<xsl:value-of select="util:element('Date/Time of Birth',util:format-date(.//PID.7.1), $ind1)"/>
		<xsl:value-of select="util:element('Administrative Sex', .//PID.8, $ind1)"/>
		<!-- Patient Address 
			PID.11[1].1.1 : street
			PID.11[1].2 : other designation
			PID.11[1].3 : city
			PID.11[1].4 : state 
			PID.11[1].5 : zip code
			PID.11[1].6 : country
		-->
		<xsl:for-each select=".//PID.11">
			<xsl:value-of select="util:element('Patient Address', concat(util:format-address(.//PID.11.1.1,.//PID.11.2, .//PID.11.3, .//PID.11.4, .//PID.11.5),.//PID.11.6), $ind1)"/>
		</xsl:for-each>
		<xsl:value-of select="util:element('Local Number', util:format-tel(.//PID.13.6,.//PID.13.7), $ind1)"/>
		<xsl:for-each select=".//PID.10">
			<xsl:value-of select="util:element('Race', .//PID.10.2, $ind1)"/>
		</xsl:for-each>
		<xsl:value-of select="util:last-element('Ethnic Group',.//PID.22.2, $ind1)"/>
	</xsl:template>
	<!-- - - - - - Guardian or Responsible Party - - - - - - - - - - - -->
	<xsl:template match="NK1">
		<xsl:value-of select="util:title('title', 'Guardian or Responsible Party', $ind1, true())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<!-- Name :
			NK1.2.2 : First name
			NK1.2.3 : Middle name
			NK1.2.4 : Suffix
			NK1.2.1.1 : Family name
		-->
		<xsl:value-of select="util:element('Name', concat(util:format-with-space(.//NK1.2.2), util:format-with-space(./NK1.2.3),util:format-with-space(.//NK1.2.4),.//NK1.2.1.1), $ind1)"/>
		<xsl:value-of select="util:element('Organization name', .//NK1.13.1, $ind1)"/>
		<xsl:value-of select="util:element('Contact Person', concat(util:format-with-space(.//NK1.30.2), util:format-with-space(./NK1.30.3),util:format-with-space(.//NK1.30.4),./NK1.30.1.1), $ind1)"/>
		<xsl:value-of select="util:element('Contact Person Address', concat(util:format-address(.//NK1.32.1.1,.//NK1.32.2, .//NK1.32.3, .//NK1.32.4, .//NK1.32.5),.//NK1.32.6), $ind1)"/>
		<xsl:value-of select="util:element('Relationship', .//NK1.3.2, $ind1)"/>
		<xsl:for-each select=".//NK1.4">
			<xsl:value-of select="util:element('Address', concat(util:format-address(.//NK1.4.1.1,.//NK1.4.2, .//NK1.4.3, .//NK1.4.4, .//NK1.4.5),.//NK1.4.6), $ind1)"/>
		</xsl:for-each>
		<xsl:for-each select=".//NK1.5">
			<xsl:value-of select="util:element('Phone Number or Email address', concat(util:format-with-space(.//NK1.5.4), util:format-tel(.//NK1.5.6, .//NK1.5.7)), $ind1)"/>
		</xsl:for-each>
		<xsl:value-of select="util:element('Contact role', .//NK1.7.2, $ind1)"/>
		<xsl:value-of select="util:last-element('Associated Parties Job Code/Class', .//NK1.11.3, $ind1)"/>
	</xsl:template>
	<!-- - - - - - Order Information- - - - - - - - - - - -->
	<xsl:template match="OML_O21.ORDER">
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
			<xsl:value-of select="util:title('title', 'Notes &amp; Comments', $ind1, true())"/>
			<xsl:value-of select="util:elements($ind1)"/>
			<xsl:apply-templates select=".//NTE"/>
			<xsl:value-of select="util:last-element('', '', $ind1)"/>
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
		<xsl:message select="count(.//OBX)"/>
		<xsl:if test="count(.//OBX) >0">
			<xsl:apply-templates select=".//OBX"/>
		</xsl:if>
		<!--Specimen information-->
		<xsl:if test="count(.//SPM) >0">
			<xsl:apply-templates select=".//SPM"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ORC" mode="provider">
		<xsl:value-of select="util:title('title', 'Ordering Provider', $ind1, true())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<xsl:value-of select="util:element('Provider Name', concat(util:format-with-space(.//ORC.12.3),.//ORC.12.2.1), $ind1)"/>
		<xsl:value-of select="util:element('Provider NPI identifier',.//ORC.12.1, $ind1)"/>
		<xsl:for-each select=".//ORC.14">
			<xsl:value-of select="util:element('Call Back Phone Number',  concat(util:format-with-space(.//ORC.14.4), util:format-tel(.//ORC.14.6, .//ORC.14.7)), $ind1)"/>
		</xsl:for-each>
		<xsl:value-of select="util:last-element('', '', $ind1)"/>
	</xsl:template>
	<xsl:template match="ORC" mode="facility">
		<xsl:value-of select="util:title('title', 'Ordering Facility ', $ind1, true())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<xsl:value-of select="util:element('Facility Name',.//ORC.21.1, $ind1)"/>
		<xsl:value-of select="util:element('Facility NPI identifier',.//ORC.21.10.1, $ind1)"/>
		<xsl:value-of select="util:element('Address',concat(util:format-address(.//ORC.22.1.1,.//ORC.22.2, .//ORC.22.3, .//ORC.22.4, .//ORC.22.5),.//ORC.22.6), $ind1)"/>
		<xsl:value-of select="util:last-element('Phone Number',  concat(util:format-with-space(.//ORC.23.4), util:format-tel(.//ORC.23.6, .//ORC.23.7)), $ind1)"/>
	</xsl:template>
	<xsl:template match="ORC" mode="general">
		<xsl:value-of select="util:title('title', 'General order information', $ind1, true())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<xsl:value-of select="util:element('Placer Order Number',.//ORC.2.1, $ind1)"/>
		<xsl:value-of select="util:element('Filler Order Number',.//ORC.3.1, $ind1)"/>
		<xsl:value-of select="util:element('Placer Group Number',.//ORC.4.1, $ind1)"/>
		<xsl:value-of select="util:element('Order Control',.//ORC.1, $ind1)"/>
		<xsl:value-of select="util:element('Date/Time of Transaction',.//ORC.9.1, $ind1)"/>
		<xsl:value-of select="util:element('Order Effective Date/Time',.//ORC.15.1, $ind1)"/>
		<xsl:value-of select="util:element('Order Control Code Reason',.//ORC.16.2, $ind1)"/>
		<xsl:value-of select="util:element('Advanced Beneficiary Notice',.//ORC.20.2, $ind1)"/>
		<xsl:value-of select="util:last-element('Enterer Authorization Mode',.//ORC.30.2, $ind1)"/>
	</xsl:template>
	<xsl:template match="OBR">
		<xsl:value-of select="util:title('title', 'Order details', $ind1, true())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<xsl:value-of select="util:element('Universal service identifier',.//OBR.4.1, $ind1)"/>
		<xsl:value-of select="util:element('Universal service identifier code system',.//OBR.4.3, $ind1)"/>
		<xsl:value-of select="util:element('Universal service identifier text',.//OBR.4.2, $ind1)"/>
		<xsl:value-of select="util:element('Universal service identifier (alternate)',.//OBR.4.4, $ind1)"/>
		<xsl:value-of select="util:element('Universal service identifier (alternate) text',.//OBR.4.5, $ind1)"/>
		<xsl:value-of select="util:last-element('Relevant clinical information',  .//OBR.13.2, $ind1)"/>
	</xsl:template>
	<xsl:template match="TQ1">
		<xsl:value-of select="util:title('title', 'Timing/Quantity Information ', $ind1, true())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<xsl:value-of select="util:element('Start date and time', .//TQ1.7.1, $ind1)"/>
		<xsl:value-of select="util:element('End date and time', .//TQ1.8.1, $ind1)"/>
		<xsl:value-of select="util:last-element('Priority',  .//TQ1.9.1, $ind1)"/>
	</xsl:template>
	<xsl:template match="NTE">
		<xsl:for-each select=".//NTE.3">
			<xsl:value-of select="util:element('Comments', ., $ind1)"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="PRT">
		<xsl:value-of select="util:title('title', 'Result Copies To', $ind1, true())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<xsl:value-of select="util:element('Instance ID', .//PRT.1.1, $ind1)"/>
		<xsl:value-of select="util:element('NPI identifier', .//PRT.5.1, $ind1)"/>
		<xsl:value-of select="util:element('Name', concat(util:format-with-space(.//PRT.5.3),.//PRT.5.1), $ind1)"/>
		<xsl:value-of select="util:element('Address', concat(util:format-address(.//PRT.14.1.1,.//PRT.14.2, .//PRT.14.3, .//PRT.14.4, .//PRT.14.5),.//PRT.14.6), $ind1)"/>
		<xsl:for-each select=".//PRT.15">
			<xsl:value-of select="util:element('Number',  concat(util:format-with-space(.//PRT.15.4), util:format-tel(.//PRT.15.6, .//PRT.15.7)), $ind1)"/>
		</xsl:for-each>
		<xsl:value-of select="util:last-element('', '', $ind1)"/>
	</xsl:template>
	<xsl:template match="DG1">
		<xsl:value-of select="util:title('title', 'Diagnosis Information', $ind1, true())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<xsl:value-of select="util:element('Priority', .//DG1.15, $ind1)"/>
		<xsl:value-of select="util:element('Diagnosis Code', .//DG1.3.1, $ind1)"/>
		<xsl:value-of select="util:element('Diagnosis Code (code system)', .//DG1.3.3, $ind1)"/>
		<xsl:value-of select="util:element('Diagnosis Code (text)', .//DG1.3.2, $ind1)"/>
		<xsl:value-of select="util:element('Diagnosis Type', .//DG1.6, $ind1)"/>
		<xsl:value-of select="util:last-element('', '', $ind1)"/>
	</xsl:template>
	<xsl:template match="OBX">
		<xsl:value-of select="util:title('title', 'Ask at order entry observations ', $ind1, true())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<xsl:value-of select="util:element('Identifier', .//OBX.3.2, $ind1)"/>
		<xsl:variable name="datatype" select=".//OBX.2"/>
		<xsl:choose>
			<xsl:when test="$datatype='NM'">
				<xsl:value-of select="util:element('Value', concat(util:format-with-space(.//OBX.5),util:format-with-space(.//OBX.6.2)), $ind1)"/>
			</xsl:when>
			<xsl:when test="$datatype='DT'">
				<xsl:value-of select="util:element('Value', .//OBX.5, $ind1)"/>
			</xsl:when>
			<xsl:when test="$datatype='CWE'">
				<xsl:value-of select="util:element('Value', .//OBX.5.2, $ind1)"/>
			</xsl:when>
		</xsl:choose>
		<xsl:value-of select="util:element('Observation Result Status', .//OBX.11, $ind1)"/>
		<xsl:value-of select="util:element('Date/Time', .//OBX.14.1, $ind1)"/>
		<xsl:value-of select="util:element('Observation Type', .//OBX.29, $ind1)"/>
		<xsl:value-of select="util:last-element('', '', $ind1)"/>
	</xsl:template>
	<xsl:template match="SPM">
		<xsl:value-of select="util:title('title', 'Specimen information', $ind1, true())"/>
		<xsl:value-of select="util:elements($ind1)"/>
		<xsl:value-of select="util:element('Placer identifier', .//SPM.2.1.1, $ind1)"/>
		<xsl:value-of select="util:element('Filler identifier', .//SPM.2.2.1, $ind1)"/>
		<xsl:value-of select="util:element('Specimen Type', .//SPM.4.2, $ind1)"/>
		<xsl:value-of select="util:element('Specimen Type(alternate)', .//SPM.4.5, $ind1)"/>
		<xsl:value-of select="util:element('Specimen Type (original)', .//SPM.4.9, $ind1)"/>
		<xsl:value-of select="util:element('Type Modifier', .//SPM.5.2, $ind1)"/>
		<xsl:value-of select="util:element('Additives', .//SPM.6.2, $ind1)"/>
		<xsl:value-of select="util:element('Collection Start Date/Time', .//SPM.17.1.1, $ind1)"/>
		<xsl:value-of select="util:element('Collection End Date/Time', .//SPM.17.2.1, $ind1)"/>
		<xsl:value-of select="util:element('Collection Method', .//SPM.7.2, $ind1)"/>
		<xsl:value-of select="util:element('Source Site', .//SPM.8.2, $ind1)"/>
		<xsl:value-of select="util:element('Source Site Modifier', .//SPM.9.2, $ind1)"/>
		<xsl:value-of select="util:last-element('', '', $ind1)"/>
	</xsl:template>
	<xsl:template name="main-html">
		<html>
			<head>
				<xsl:if test="$output = 'tab-html'">
					<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"/>
					<script src="http://code.jquery.com/jquery-1.10.2.js"/>
					<script src="http://code.jquery.com/ui/1.11.4/jquery-ui.js"/>
				</xsl:if>
				<xsl:call-template name="css"/>
				<script>				
					var data = 				
					<xsl:call-template name="main"/>;								
					var full = '', 
					html = '';								
					<xsl:if test="$output = 'tab-html'">
						$(function() { $( "#test-data-tabs" ).tabs();	});				
					</xsl:if>
					document.write('<div class="test-data-specs-main">');									
					/* if we wanted to generate the root tab structure include this code				
					$(function() { $( "#test-tabs" ).tabs();	});									
					document.write('<div id="test-tabs">');				
					document.write('<ul>');				
					document.write('<li>
									<a href="#test-tabs-0">Test Story</a>
								</li>');				
					document.write('<li>
									<a href="#test-tabs-1">Test Data Specification</a>
								</li>');
					document.write('<li>
									<a href="#test-tabs-2">Message Content</a>
								</li>');				
					document.write('</ul>'); 				
					*/								
					<!-- xsl:call-template name="test-story"></xsl:call-template -->
							<xsl:call-template name="test-data-specs"/>
							<!-- xsl:call-template name="message-content"></xsl:call-template -->									
					document.write('</div>');									
					document.write('</div>');				
				</script>
			</head>
			<body>			</body>
		</html>
	</xsl:template>
	<!--	<xsl:template name="test-story">		
		document.write('<div id="test-tabs-0">');		
		document.write(' ............. Test .......... Story................... ');		
		document.write('</div>');	
	</xsl:template>-->
	<!--	<xsl:template name="message-content">		
		document.write('<div id="test-tabs-2">');		
		document.write(' ............. Message .......... Content................... ');		
		document.write('</div>');	
	</xsl:template>-->
	<xsl:template name="test-data-specs">
		
		document.write('<div id="test-tabs-1">');
		document.write('<div id="test-data-tabs">');
			<xsl:if test="$output = 'tab-html'">
				document.write('<ul>');
				document.write('<li>
							<a href="#test-data-tabs-0">FULL</a>
						</li>');
				for(var key in data.tables) {
					document.write('<li>
							<a href="#test-data-tabs-' + (key+1) + '">' + data.tables[key].title + '</a>
						</li>');
				}	
				document.write('</ul>');
			</xsl:if>
		
			for(var key in data.tables) {
			    var tab = '';
			    tab += '<div id="test-data-tabs-' + (key+1) + '">';
				var table = data.tables[key];
				tab += ('<fieldset>
						<legend>' + table.title + '</legend>
						<table>
							<tr>
								<th> Element </th>
								<th> Data </th>
							</tr>'); 

				for (var elkey in table.elements) {
					element = table.elements[elkey];
					// display obxs as separate table
					if (element.element == 'obx') {
							var obx = element.data;
							tab += '</table>
					</fieldset>'; // end the bigger table
							tab += ('<fieldset>
						<table>
							<tr>
								<th colspan="2"> ' + obx.title + '</th>
							</tr>'); 
							for (var obxkey in obx.elements) {
								if (obx.elements[obxkey].element == "") { // gray line
									tab += '<tr class="tds_obxGrpSpl">
								<td colspan="2"/>
							</tr>';
								} 						
								else {
									tab += ('<tr>
								<td>' + obx.elements[obxkey].element + '</td>
								<td>' + obx.elements[obxkey].data + '</td>
							</tr>');
								}
							}
					}
					else {
						var tdclass = element.data == '' ? "tds_noData" : "tds_data"; 
						/* Added  tds_noData class to table row (instead of data cell) to be able to hide the row when no data */
						tab += ('<tr class="' + tdclass + '">
								<td>' + element.element + '</td>
								<td>' + element.data + '</td>
							</tr>');
					}
				}
				
				tab += '</table>
					</fieldset>';
				tab += '</div>';

				<xsl:if test="$output = 'tab-html'">
					document.write(tab);
				</xsl:if>
				
				full += tab; 
			//$(function() { $( "#test-data-tabs-0" ).html("full");	});
			} 					
			
			// full tab
			document.write('<div id="test-data-tabs-0"> ' + full + '</div>');
			document.write('</div>');
			document.write('</div>'); 
	</xsl:template>
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
	<!-- add a trailing hyphen if non empty -->
	<xsl:function name="util:format-tel">
		<xsl:param name="areacode"/>
		<xsl:param name="phonenumber"/>
		<xsl:if test="$areacode != '' and $phonenumber != ''">
			<xsl:variable name="areaCode" select="concat('(',$areacode,')')"/>
			<xsl:variable name="localCode" select="concat(substring($phonenumber,1,3),'-')"/>
			<xsl:variable name="idCode" select="substring($phonenumber,4,4)"/>
			<xsl:value-of select="concat($areaCode,$localCode,$idCode)"/>
		</xsl:if>
	</xsl:function>
	<!-- add a trailing hyphen if non empty -->
	<xsl:function name="util:format-address">
		<xsl:param name="street"/>
		<xsl:param name="other"/>
		<xsl:param name="city"/>
		<xsl:param name="state"/>
		<xsl:param name="zip"/>
		<xsl:value-of select="concat(util:format-with-space($street), util:format-with-space($other), util:format-with-space($city), util:format-with-space($state), util:format-with-space($zip))"/>
	</xsl:function>
	<xsl:function name="util:format-date">
		<xsl:param name="elementDataIn"/>
		<xsl:variable name="elementData" select="concat($elementDataIn, '                ')"/>
		<xsl:if test="string-length(normalize-space($elementData)) &gt; 0">
			<xsl:variable name="year" select="substring($elementData,1,4)"/>
			<xsl:variable name="month" select="concat(substring($elementData,5,2),'/')"/>
			<xsl:variable name="day" select="concat(substring($elementData,7,2),'/')"/>
			<xsl:value-of select="concat($month,$day,$year)"/>
			<!-- <xsl:value-of select="format-date(xs:date(concat($month,$day,$year)),'[D1o] 				[MNn], [Y]', 'en', (), ())"/> -->
		</xsl:if>
	</xsl:function>
	<xsl:function name="util:start">
		<xsl:param name="profile"/>
		<xsl:value-of select="util:html-prelude()"/>
		<xsl:value-of select="concat('{', $nl, '&quot;profile&quot; : &quot;', $profile, '&quot;,', $nl, '&quot;tables&quot;:', $nl, '[', $nl)"/>
	</xsl:function>
	<xsl:function name="util:begin-obx-table">
		<xsl:param name="ind"/>
		<xsl:value-of select="concat($nl, $ind, '{&quot;element&quot; : &quot;obx&quot;, &quot;data&quot; : ', $nl)"/>
	</xsl:function>
	<xsl:function name="util:end-obx-group">
		<xsl:param name="ind"/>
		<xsl:value-of select="util:element('', '', $ind)"/>
	</xsl:function>
	<xsl:function name="util:title">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="ind"/>
		<xsl:param name="endprevioustable" as="xs:boolean"/>
		<xsl:variable name="prelude">
			<xsl:choose>
				<xsl:when test="$endprevioustable">
					<xsl:value-of select="concat($ind, '},', $nl)"/>
				</xsl:when>
				<xsl:otherwise>									</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($prelude, $ind, '{', $nl, $ind, $indent, '&quot;', $name, '&quot;', ':', '&quot;', $value, '&quot;,', $nl)"/>
	</xsl:function>
	<xsl:function name="util:elements">
		<xsl:param name="ind"/>
		<xsl:value-of select="concat($ind, $indent, '&quot;elements&quot; : ', $nl, $ind, $indent, '[')"/>
	</xsl:function>
	<xsl:function name="util:end-elements">
		<xsl:param name="ind"/>
		<xsl:value-of select="concat($ind, ']', $nl)"/>
	</xsl:function>
	<xsl:function name="util:element">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="ind"/>
		<xsl:value-of select="util:element-with-delimiter($name, $value, ',', $ind)"/>
	</xsl:function>
	<xsl:function name="util:last-element">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="ind"/>
		<xsl:value-of select="concat(util:element-with-delimiter($name, $value, '', $ind), $nl, $ind, $indent, ']', $nl)"/>
	</xsl:function>
	<xsl:function name="util:element-with-delimiter">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="trailing"/>
		<xsl:param name="ind"/>
		<xsl:value-of select="concat($nl, $ind, $indent, $indent, '{&quot;element&quot; : &quot;', $name, '&quot;, &quot;data&quot; : &quot;', $value, '&quot;}', $trailing)"/>
	</xsl:function>
	<xsl:function name="util:end">
		<xsl:param name="ind"/>
		<xsl:value-of select="concat($nl, $ind, '}', $nl, ']', $nl, '}')"/>
		<xsl:value-of select="util:html-footer()"/>
	</xsl:function>
	<xsl:function name="util:html-prelude">	</xsl:function>
	<xsl:function name="util:html-footer">	</xsl:function>
</xsl:stylesheet>
