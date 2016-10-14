<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xhtml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template name="commentTemplate">
		<input type="text" disabled="true"/>

	</xsl:template>

	<xsl:template name="dateTime">
		<xsl:param name="dateS"/>
		<xsl:message>
			coucou
			<xsl:value-of select="$dateS"/>
		</xsl:message>
		<xsl:variable name="dateformat"
            select="xs:dateTime(concat(
            substring($dateS,1,4),'-',
            substring($dateS,5,2),'-',
            substring($dateS,7,2),'T',
            substring($dateS,9,2),':',
            substring($dateS,11,2),':',
            substring($dateS,13,2)
            ))"/>

		<xsl:value-of
            select="format-dateTime($dateformat, '[Y0001]/[M01]/[D01] at [H01]:[m01]:[s01]')"
        />
	</xsl:template>

	<xsl:template match="/">

		<html>
			<head>

				<style type="text/css">
                    @media screen {
                    fieldset {font-size:100%;}
                    fieldset table tbody tr th {font-size:90%}
                    fieldset table tbody tr td {font-size:90%;}
                    }
                    @media print{fieldset {font-size:small;} fieldset table  th { font-size:x-small; }
                    fieldset table  td { font-size:xx-small }* [type=text]{
                    width: 98%;
                    height: 15px;
                    margin: 2px;
                    padding: 0px;
                    background: 1px  #ccc;
                    }

                    * [type=checkbox]{
                    width: 10px;
                    height: 10px;
                    margin: 2px;
                    padding: 0px;
                    background: 1px  #ccc;
                    }}
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


                    * [type=text]{
                    width: 95%;
                    }

                    fieldset {page-break-inside: avoid;}
                    fieldset table { width:98%;border: 1px groove; margin:0 auto;page-break-inside: avoid;}
                    fieldset table  tr { border: 1px groove; }
                    fieldset table  th { border: 1px groove; }
                    fieldset table  td { border: 1px groove;empty-cells: show; }
                    fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;}
                    fieldset table thead tr th:last-child {width:2%;}
                    fieldset table thead tr th:nth-last-child(2) {width:2%;}
                    fieldset table thead tr th:nth-last-child(3) {width:45%;}
                    fieldset table tbody tr th {text-align:left;background:#C6DEFF;width:15%}
                    fieldset table tbody tr td {text-align:left}
                    fieldset table tbody tr td [type=text]{text-align:left;margin-left:1%}
                    fieldset table caption {font-weight:bold;color:#0840F8;}
                    fieldset {width:98%;font-weight:bold;border:1px solid #446BEC;}
                    .embSpace {padding-left:25px;}
				</style>
			</head>
			<body>


				<fieldset id="juror">
					<legend>ELECTRONIC DIRECTORY OF SERVICE(eDOS)</legend>
					<table id="headerTable">
						<thead>
							<tr>
								<th colspan="2">Electronic Directory Of Service (eDOS)</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>Test Case ID</th>
								<xsl:for-each select="/event-profiles/@id">
								<xsl:message>
								<xsl:value-of select="/event-profiles/@id"/>
								</xsl:message>
									<td>
										<xsl:value-of select="/event-profiles/@id"/>
									</td>
								</xsl:for-each>
							</tr>
							<tr>
								<th>Inspection Date/Time</th>
								<td/>
							</tr>
							<tr>
								<th>Inspection Settlement</th>
								<td>
									<table id="inspectionStatus">
										<thead>
											<tr>
												<th>Pass</th>
												<th>Fail</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>
													<input type="checkbox"/>
												</td>
												<td>
													<input type="checkbox"/>
												</td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<th>Juror ID</th>
								<td/>
							</tr>
							<tr>
								<th>Juror Name</th>
								<td/>
							</tr>
						</tbody>
					</table>
				</fieldset>
				<fieldset id="Panel1">
					<legend>NON-DISPLAY VERIFICATION</legend>
					<table id="nonorderablePanel">
						<thead>
							<tr>
								<th colspan="2">Non-Orderable Panels and /or Tests</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>Name of Test</th>
								<th>Altenate and/or Preferred Name</th>
							</tr>
							<xsl:for-each select="//element[@location='OM1.12'][@data='N']/..">
								<tr>
									<td>  
										<xsl:value-of   select="element[@location='OM1.2.2']/@data" />
									</td>
									<td>                                         
										<xsl:choose>
											<xsl:when test="element[@location='OM1.9']/@data">
												<xsl:value-of select="element[@location='OM1.9']/@data"/>
											</xsl:when>
											<xsl:when test="element[@location='OM1.10']/@data">
												<xsl:value-of select="element[@location='OM1.10']/@data"/>
											</xsl:when>
											<xsl:when test="element[@location='OM1.11']/@data">
												<xsl:value-of select="element[@location='OM1.11']/@data"/>
											</xsl:when>
										</xsl:choose>            
									</td>        
								</tr>                           
							</xsl:for-each>
						</tbody>
					</table>
				</fieldset>
				<!-- Display orderable panels/tests where OM1.12=Y-->
				<fieldset id="Panel2">
					<legend>DISPLAY VERIFICATION</legend>
					<table id="orderablePanel">
						<thead>
							<tr>
								<th colspan="2">Orderable Panels and /or Tests</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<th>Name of Test</th>
								<th>Altenate and/or Preferred Name</th>
							</tr>
							<xsl:for-each select="//element[@location='OM1.12'][@data='Y']/..">
								<tr>
									<td>  
										<xsl:value-of   select="element[@location='OM1.2.2']/@data" />
									</td>
									<td>                                         
										<xsl:choose>
											<xsl:when test="element[@location='OM1.9']/@data">
												<xsl:value-of select="element[@location='OM1.9']/@data"/>
											</xsl:when>
											<xsl:when test="element[@location='OM1.10']/@data">
												<xsl:value-of select="element[@location='OM1.10']/@data"/>
											</xsl:when>
											<xsl:when test="element[@location='OM1.11']/@data">
												<xsl:value-of select="element[@location='OM1.11']/@data"/>
											</xsl:when>
										</xsl:choose>            
									</td>        
								</tr>                           
							</xsl:for-each>
						</tbody>
					</table> 
					<br/>
					<!--Get orderable panel/test id into variable, group the profiles by id and select values with grouping key= orderable panel id -->
					<xsl:variable name="operableId" select="//element[@location='OM1.12'][@data='Y']/../@id"/>
					<xsl:for-each-group select="//test-profile" group-by="@id">

						<xsl:if test="current-grouping-key()=$operableId">

							<table id="details">
								<thead>

									<tr>
										<th colspan="2">Test/Panel Details:<xsl:value-of select="element[@location='OM1.2.2']/@data"/>
										</th>
									</tr>
								</thead>
								<tbody>

									<div id="global">
										<tr>
											<th colspan="2">Global Information</th>

										</tr>
										<tr>
											<th>Alternate and/or preferred name(s)</th>
											<td>
												<xsl:value-of select="element[@location='OM1.9']/@data"/> 
											</td>

										</tr>
										<tr>
											<th>Factors that may affect the observation</th>
											<td>
												<xsl:value-of select="element[@location='OM1.39']/@data"/>  
											</td>

										</tr>
										<tr>
											<th>Test Performance schedule</th>
											<td>
												<xsl:value-of select= "element[@location='OM1.40[1]']/@data"/> 
											</td>

										</tr>
										<tr>
											<th>Diagnostic service sector ID</th>
											<td>
												<xsl:value-of select="element[@location='OM1.49']/@data"/>
											</td>

										</tr>
										<tr>
											<th>Expected turn-around time</th>
											<td>
												<xsl:value-of select="element[@location='OM1.57[1].1']/@data"/>
												<xsl:value-of select="element[@location='OM1.57[1].2.2']/@data"/>
											</td>
										</tr>
									</div>
								</tbody>

							</table>
							<xsl:if test="current-group()[@segment='OM3']/element[@location]/@data">
								<table id="result">
									<thead>

										<tr>
											<th colspan="2">Results Information </th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th>Result Type</th>
											<td>
												<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.7']/@data"/> 
											</td>

										</tr>
										<tr>
											<th>Normal Result for test</th>
											<td>
												<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.4[1].2']/@data"/> 
											</td>

										</tr>
										<tr>
											<th rowspan="4">Abnormal result(s) for test</th>
										</tr>
										<tr>
											<td>
												<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[1].2']/@data"/> 
											</td>
										</tr>
										<tr>
											<td>
												<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[2].2']/@data"/> 
											</td>
										</tr>
										<tr>

											<td>
												<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[3].2']/@data"/> 
											</td>

										</tr>
									</tbody>
								</table>
							</xsl:if>
							<xsl:if test="current-group()[@segment='OM4']/element[@location]/@data">
								<table id="specimen">
									<thead>

										<tr>
											<th colspan="2">Preferred Specimen Information </th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th>Specimen</th>
											<td>
												<xsl:value-of select="current-group()[@segment='OM4']/element[@location='OM4.6.2']/@data"/> 
											</td>

										</tr>
										<tr>
											<th>Additive</th>
											<td>
												<xsl:value-of select="current-group()[@segment='OM4']/element[@location='OM4.7.2']/@data"/> 
											</td>

										</tr>
										<tr>
											<th>Specimen Handling Code</th>
											<td>
												<xsl:value-of select="current-group()[@segment='OM4']/element[@location='OM4.15[1].2']/@data"/> 
											</td>

										</tr>
										<tr>
											<th colspan="2">Container(s)</th>
										</tr>
										<tr>
											<th>Description</th>
											<th>Volume</th>
										</tr>
										<tr>
											<td>
												<xsl:value-of select="current-group()[@segment='OM4']/element[@location='OM4.3[1]']/@data"/> 
											</td>
											<td>
												<xsl:value-of select="current-group()[@segment='OM4']/element[@location='OM4.4[1]']/@data"/> 
												<xsl:value-of select="current-group()[@segment='OM4']/element[@location='OM4.5[1].2']/@data"/> 
											</td>
										</tr>
										<tr>
											<th colspan="2">Collection Information</th>
										</tr>
										<tr>
											<th> Normal Collection Volume</th>
											<td>
												<xsl:value-of select="current-group()[@segment='OM4']/element[@location='OM4.10.1']/@data"/> 
											</td>

										</tr>
										<tr>
											<th> Minimum Collection Volume</th>
											<td>
												<xsl:value-of select="current-group()[@segment='OM4']/element[@location='OM4.11.1']/@data"/> 
											</td>

										</tr>
									</tbody>
								</table>
							</xsl:if>
							<!-- to do alternate specimen for OM4 need to check -->
							<xsl:variable name="specimen"  select="current-group()[@segment='OM4']/element[@location='OM4.1']/@data"/>
							<xsl:if test="current-group()[@segment='OM4']">
								<xsl:for-each select="//element[@location='OM4.17'][@data=$specimen]/..">
									<table id="alternate specimen">
										<thead>

											<tr>
												<th colspan="2">Alternate Specimen Information </th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<th>Specimen</th>
												<td>
													<xsl:value-of select="element[@location='OM4.6.2']/@data"/> 
												</td>

											</tr>

											<tr>
												<th>Specimen Handling Code</th>
												<td>
													<xsl:value-of select="element[@location='OM4.15[1].2']/@data"/> 
												</td>

											</tr>
											<tr>
												<th colspan="2">Container(s)</th>
											</tr>
											<tr>
												<th>Description</th>
												<th>Volume</th>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="element[@location='OM4.3[1]']/@data"/> 

												</td>
												<td>
													<xsl:value-of select="element[@location='OM4.4[1]']/@data"/> 
													<xsl:value-of select="element[@location='OM4.5[1].2']/@data"/> 
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="element[@location='OM4.3[2]']/@data"/> 
												</td>
												<td>
													<xsl:value-of select="element[@location='OM4.4[1]']/@data"/> 
													<xsl:value-of select="element[@location='OM4.5[1].2']/@data"/> 
												</td>
											</tr>
											<tr>
												<th colspan="2">Collection Information</th>
											</tr>
											<tr>
												<th> Normal Collection Volume</th>
												<td>
													<xsl:value-of select="element[@location='OM4.10.1']/@data"/> 
												</td>

											</tr>
											<tr>
												<th> Minimum Collection Volume</th>
												<td>
													<xsl:value-of select="element[@location='OM4.11.1']/@data"/> 
												</td>

											</tr>
										</tbody>
									</table>
								</xsl:for-each>
							</xsl:if>
							<xsl:if test="current-group()[@segment='CDM']/element[@location]/@data">
								<table id="charge code">
									<thead>

										<tr>
											<th colspan="2">Charge Code Information </th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th>Description</th>
											<td>
												<xsl:value-of select="current-group()[@segment='CDM']/element[@location='CDM.3']/@data"/> 
											</td>

										</tr>
										<tr>
											<th>CPT-4 text</th>
											<td>
												<xsl:value-of select="current-group()[@segment='CDM']/element[@location='CDM.7[1].2']/@data"/> 
											</td>

										</tr>
										<tr>
											<th>CPT-4 text</th>
											<td>
												<xsl:value-of select="current-group()[@segment='CDM']/element[@location='CDM.7[2].2']/@data"/> 
											</td>

										</tr>
									</tbody>
								</table>
							</xsl:if>
							<xsl:if test="current-group()[@segment='OM5']/element[@category='Changeable Data'][@displayName='Text']">
								<table id="panel components">
									<thead>

										<tr>
											<th>Panel Components</th>
										</tr>
									</thead>
									<tbody>

										<xsl:for-each select="current-group()[@segment='OM5']/element[@category='Changeable Data'][@displayName='Text']">

											<tr>

												<td>
													<xsl:value-of select="@data"/> 
												</td>

											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</xsl:if>
							<!-- select the value of OM5 panel component into variable and insert in the Xpath and get the values -->
							<xsl:variable name="panel" select="current-group()[@segment='OM5']/element[@category='Changeable Data'][@displayName='Text']/@data"/>

							<xsl:for-each select=" //test-profile[@segment='OM1']/element[@category='Changeable Data'][@displayName='Text'][@data=$panel]/..">

								<table id="panel details">

									<thead>

										<tr>
											<th colspan="2">
												<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.2.2']/@data"/> Panel Component Details:<xsl:value-of select="element[@location='OM1.2.2']/@data"/>
											</th>
										</tr>
									</thead>


									<tbody>

										<tr>
											<th colspan="2">Global Information</th>

										</tr>

										<tr>
											<th>Alternate and/or preferred name(s)</th>
											<td>
												<xsl:value-of select="element[@location='OM1.9']/@data"/> 
											</td>

										</tr>
										<tr>
											<th>Factors that may affect the observation</th>
											<td>
												<xsl:value-of select="element[@location='OM1.39']/@data"/>  
											</td>

										</tr>
										<tr>
											<th>Test Performance schedule</th>
											<td>
												<xsl:value-of select= "element[@location='OM1.40[1]']/@data"/> 
											</td>

										</tr>
										<tr>
											<th>Diagnostic service sector ID</th>
											<td>
												<xsl:value-of select="element[@location='OM1.49']/@data"/>
											</td>

										</tr>
										<tr>
											<th>Expected turn-around time</th>
											<td>
												<xsl:value-of select="element[@location='OM1.57[1].1']/@data"/>
												<xsl:value-of select="element[@location='OM1.57[1].2.2']/@data"/>
											</td>

										</tr>

									</tbody>

								</table> 

							</xsl:for-each>
							<br/>
						</xsl:if>

					</xsl:for-each-group>

				</fieldset>

				<fieldset id="IncorporateDetails">  
					<legend>INCORPORATE VERIFICATION</legend>
					<!-- Similar process as done for Display verification-->
					<xsl:variable name="incorporateVar" select="//element[@location='OM1.12'][@data='Y']/../@id"/>
					<xsl:for-each-group select="//test-profile" group-by="@id">
						<xsl:if test="current-grouping-key()=$incorporateVar">
							<table id="details">
								<thead>

									<tr>
										<th colspan="2">Test/Panel Details:<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.2.2']/@data"/>
										</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th>Record Effective Date</th>
										<td>
											<xsl:call-template name="dateTime">
												<xsl:with-param name="dateS" select="current-group()[@segment='MFE']/element[@location='MFE.3.1']/@data"/>
											</xsl:call-template> 
										</td>

									</tr>

									<tr>
										<th colspan="2">Global Information</th>

									</tr>

									<tr>
										<th>Lab Name</th>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.5.2']/@data"/> 
										</td>

									</tr>
									<tr>
										<th>Lab Identifier</th>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.5.1']/@data"/>  
										</td>

									</tr>
									<tr>
										<th>Identifier assigned by Lab(code)</th>
										<td>
											<xsl:value-of select= "current-group()[@segment='OM1']/element[@location='OM1.2.1']/@data"/> 
										</td>

									</tr>
									<tr>
										<th>Identifier assigned by Lab(text)</th>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.2.2']/@data"/>
										</td>

									</tr>
									<tr>
										<th>Identifier assigned by Lab(code system)</th>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.2.3']/@data"/> 
										</td>

									</tr>
									<tr>
										<th>Alternate Identifier(code)</th>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.7.1']/@data"/> 
										</td>

									</tr>
									<tr>
										<th>Alternate Identifier(text)</th>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.7.2']/@data"/> 
										</td>

									</tr>
									<tr>
										<th>Alternate Identifier(code system)</th>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.7.3']/@data"/> 
										</td>

									</tr>
									<tr>
										<th>Alternate and/or preferred name(s)</th>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.9']/@data"/> 
										</td>

									</tr>
									<tr>
										<th>Exclusive Test</th>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.48']/@data"/>

										</td>

									</tr>
								</tbody>
							</table>
							<xsl:if test="current-group()[@segment='OM1']/element[@location]/@data and (current-group()[@segment='OM3']/element[@location]/@data)">
								<table>


									<tr>
										<th colspan="3">Results Information</th>
									</tr>

									<tr>
										<th>Text</th>
										<th>
                                            Result identifier/code
										</th>
										<th>
                                            Code System
										</th>
									</tr>
									<tr>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].2']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].1']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].3']/@data"/>
										</td>
									</tr>
									<tr>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].5']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].4']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].6']/@data"/>
										</td>
									</tr>
									<tr>
										<th colspan="3">
                                            Normal Result for Test
										</th>
									</tr>
									<tr>
										<th>Text</th>
										<th>
                                            Result identifier/code
										</th>
										<th>
                                            Code System
										</th>
									</tr>
									<tr>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.4[1].2']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.4[1].1']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.4[1].3']/@data"/>
										</td>
									</tr>
									<tr>
										<th colspan="3">
                                            Abnormal result for test
										</th>
									</tr>
									<tr>
										<th>Text</th>
										<th>
                                            Result identifier/code
										</th>
										<th>
                                            Code System
										</th>
									</tr>
									<tr>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[1].2']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[1].1']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[1].3']/@data"/>
										</td>
									</tr>
									<tr>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[2].2']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[2].1']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[2].3']/@data"/>
										</td>
									</tr>
									<tr>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[3].2']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[3].1']/@data"/>
										</td>
										<td>
											<xsl:value-of select="current-group()[@segment='OM3']/element[@location='OM3.5[3].3']/@data"/>
										</td>
									</tr>
								</table>
							</xsl:if>
							<table>
								<tr>
									<th colspan="2">Charge Code Information</th>
								</tr>
								<tr>
									<th>Record Effective Date</th>
									<td>
										<xsl:call-template name="dateTime">
											<xsl:with-param name="dateS" select="current-group()[@segment='MFE']/element[@location='MFE.3.1']/@data"/>
										</xsl:call-template> 
									</td>

								</tr>
								<tr>
									<th>CPT-4 text</th>
									<td>
										<xsl:value-of select="current-group()[@segment='CDM']/element[@location='CDM.7[1].2']/@data"/> 
									</td>

								</tr>
								<tr>
									<th>CPT-4 text</th>
									<td>
										<xsl:value-of select="current-group()[@segment='CDM']/element[@location='CDM.7[2].2']/@data"/> 
									</td>

								</tr>
							</table>
							<xsl:if test="current-group()[@segment='OM5']/element[@category='Changeable Data'][@displayName='Text']">
								<table id="panel components">
									<thead>

										<tr>
											<th>Panel Components</th>
										</tr>
									</thead>
									<tbody>
										<xsl:for-each select="current-group()[@segment='OM5']/element[@category='Changeable Data'][@displayName='Text']">
											<tr>

												<td>
													<xsl:value-of select="@data"/> 
												</td>

											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</xsl:if>
							<xsl:variable name="panelDetails" select="current-group()[@segment='OM5']/element[@category='Changeable Data'][@displayName='Text']/@data"/>

							<xsl:for-each-group select="//test-profile" group-by="@id">

								<xsl:for-each select="element[@category='Changeable Data'][@displayName='Text'][@data=$panelDetails]">
									<table id="panel details">

										<thead>

											<tr>
												<th colspan="2">Panel Component Details:<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.2.2']/@data"/>
												</th>
											</tr>
										</thead>


										<tbody>

											<tr>
												<th>Record Effective Date</th>
												<td>
													<xsl:call-template name="dateTime">
														<xsl:with-param name="dateS" select="current-group()[@segment='MFE']/element[@location='MFE.3.1']/@data"/>
													</xsl:call-template> 
												</td>

											</tr>

											<tr>
												<th colspan="2">Global Information</th>

											</tr>

											<tr>
												<th>Lab Name</th>
												<td>
													<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.5.2']/@data"/> 
												</td>

											</tr>
											<tr>
												<th>Lab Identifier</th>
												<td>
													<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.5.1']/@data"/>  
												</td>

											</tr>
											<tr>
												<th>Identifier assigned by lab(code)</th>
												<td>
													<xsl:value-of select= "current-group()[@segment='OM1']/element[@location='OM1.2.1']/@data"/> 
												</td>

											</tr>
											<tr>
												<th>Identifier assigned by lab(text)</th>
												<td>
													<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.2.2']/@data"/>
												</td>

											</tr>
											<tr>
												<th>Identifier assigned by lab(code system)</th>
												<td>
													<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.2.3']/@data"/>

												</td>

											</tr>
											<tr>
												<th>Alternate identifier(code)</th>
												<td>
													<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.7.1']/@data"/>

												</td>

											</tr>
											<tr>
												<th>Alternate identifier(text)</th>
												<td>
													<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.7.2']/@data"/>

												</td>

											</tr>
											<tr>
												<th>Alternate identifier(code system)</th>
												<td>
													<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.7.3']/@data"/>

												</td>

											</tr>
											<tr>
												<th>Alternate and/or preferred name(s)</th>
												<td>
													<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.9']/@data"/>

												</td>

											</tr>
											<tr>
												<th>Exclusive Test</th>
												<td>
													<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.48']/@data"/>

												</td>

											</tr>

										</tbody>

									</table> 


									<table>
										<tr>
											<th colspan="3">Results Information</th>
										</tr>

										<tr>
											<th>Text</th>
											<th>
                                                Result identifier/code
											</th>
											<th>
                                                Code System
											</th>
										</tr>
										<tr>
											<td>
												<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].2']/@data"/>
											</td>
											<td>
												<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].1']/@data"/>
											</td>
											<td>
												<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].3']/@data"/>
											</td>
										</tr>
										<tr>
											<td>
												<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].5']/@data"/>
											</td>
											<td>
												<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].4']/@data"/>
											</td>
											<td>
												<xsl:value-of select="current-group()[@segment='OM1']/element[@location='OM1.56[1].6']/@data"/>
											</td>
										</tr>
									</table>

								</xsl:for-each>
							</xsl:for-each-group> 
							<br/>


						</xsl:if>
					</xsl:for-each-group>
				</fieldset>

			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
