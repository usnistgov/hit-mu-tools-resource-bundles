<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="http://www.nist.gov/ds" exclude-result-prefixes="util xsl">
	<xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>
	<xsl:param name="testCaseId" select="$messageProfile/test-message/@instance"/>
	<xsl:param name="segmentName" select="'FULL'"/>
	<xsl:param name="segmentInstanceNumber" select="'0'"/>
	<xsl:variable name="messageProfile" select="event-profiles"/>
	<xsl:template match="/">
		<xsl:for-each select="$messageProfile/test-message[@instance=$testCaseId]">
			<xsl:variable name="testMessage" select="@instance"/>
			<html>
				<head>
					<title>NIST HL7V2 Lab Validation Suite - Data Sheet Prototype</title>
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
						<xsl:variable name="msgProp" select="$messageProfile/message-description/properties[@id=$testMessage]"/>
						<table>
							<thead>
								<tr>
									<th colspan="2">
										<xsl:value-of select="concat($msgProp/@test-case-id,' - ',$msgProp/@description)"/>
									</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th> Test Case ID</th>
									<td>
										<xsl:value-of select="$testMessage"/>
									</td>
								</tr>
							</tbody>
						</table>
					</fieldset>
					<br/>
					<xsl:choose>
						<xsl:when test="$segmentName = 'FULL'">
							<xsl:for-each select="segment">
								<xsl:variable name="segId" select="@id"/>
								<xsl:variable name="testCaseId" select="@test-profile"/>
								<xsl:variable name="testProfile" select="$messageProfile/test-profile-package/test-profiles[@segment=$segId]/test-profile[@id=$testCaseId]"/>
								<xsl:variable name="segTestProfile" select="$testProfile/element"/>
								<xsl:variable name="segDescription" select="$testProfile/@desc"/>
								<xsl:call-template name="renderSegment">
									<xsl:with-param name="segDescription" select="$segDescription"/>
									<xsl:with-param name="segProfile" select="$segTestProfile"/>
									<xsl:with-param name="segment" select="$segId"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="count(segment[@id=$segmentName]) &gt; 0">
									<xsl:for-each select="segment[@id=$segmentName]">
										<xsl:variable name="segId" select="@id"/>
										<xsl:variable name="testCaseId" select="@test-profile"/>
										<xsl:variable name="testProfile" select="$messageProfile/test-profile-package/test-profiles[@segment=$segId]/test-profile[@id=$testCaseId]"/>
										<xsl:variable name="segTestProfile" select="$testProfile/element"/>
										<xsl:variable name="segDescription" select="$testProfile/@desc"/>
										<xsl:variable name="pos">
											<xsl:value-of select="position()"/>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="$pos=$segmentInstanceNumber">
												<xsl:call-template name="renderSegment">
													<xsl:with-param name="segDescription" select="$segDescription"/>
													<xsl:with-param name="segProfile" select="$segTestProfile"/>
													<xsl:with-param name="segment" select="$segId"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>
								</xsl:when>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</body>
			</html>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="renderSegment">
		<xsl:param name="segProfile" as="node()*"/>
		<xsl:param name="segDescription"/>
		<xsl:param name="segment"/>
		<xsl:param name="segInsNumber"/>
		<fieldset>
			<legend>
				<xsl:value-of select="concat($segment,' : ', $segDescription[1])"/>
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
					<xsl:for-each-group select="$segProfile" group-by="@group">
						<xsl:choose>
							<xsl:when test="current-grouping-key() = 'OBX.5'">
								<xsl:variable name="obx5Group" select="current-group()"/>
								<xsl:for-each-group select="$obx5Group" group-starting-with="*[@relation='parent']">
									<xsl:variable name="obx5Data">
										<xsl:for-each select="current-group()">
											<xsl:value-of select="normalize-space(@data)"/>
										</xsl:for-each>
									</xsl:variable>
									<xsl:choose>
										<xsl:when test="string-length($obx5Data) != 0">
											<xsl:call-template name="renderSegBody">
												<xsl:with-param name="segBody" select="current-group()"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each-group>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="renderSegBody">
									<xsl:with-param name="segBody" select="current-group()"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each-group>
				</tbody>
			</table>
		</fieldset>
		<br> </br>
	</xsl:template>
	<xsl:template name="renderSegBody">
		<xsl:param name="segBody"/>
		<xsl:for-each select="$segBody">
			<xsl:choose>
				<!-- this is a field-->
				<xsl:when test="count(tokenize(@location,'[.]')) = 2">
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
							<xsl:value-of select="@location"/>
						</th>
						<th>
							<xsl:value-of select="translate(@displayName,'â€“','&#45;')"/>
						</th>
						<xsl:choose>
							<xsl:when test="string-length(normalize-space(@data)) = 0">
								<th/>
								<th/>
							</xsl:when>
							<xsl:otherwise>
								<td>
									<xsl:variable name="groupData">
										<xsl:choose>
											<xsl:when test="false()">
												<xsl:value-of select="current-group()/@data"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@data"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="$groupData"/>
								</td>
								<td>
									<xsl:value-of select="@category"/>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</xsl:when>
				<!-- components & subcomponents-->
				<xsl:otherwise>
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
							<xsl:value-of select="@location"/>
						</td>
						<td class="{$elementSplitter}">
							<xsl:variable name="curGroup" select="concat(current-grouping-key(),'.')"/>
							<xsl:value-of select="@displayName"/>
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
							<xsl:value-of select="@category"/>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<!--	<xsl:function name="util:isDataPresent">
		<xsl:param name="dataSet"/>
		
		<xsl:for-each select="$dataSet">
			<xsl:if test="string-length(.) &gt; 0">
				<xsl:value-of select="true()"/>
			</xsl:if>
		</xsl:for-each>
		<xsl:value-of select="false()"/>
	</xsl:function>-->
	<xsl:template name="util:elementLength">
		<xsl:param name="elementLocation"/>
		<xsl:variable name="value">
			<xsl:value-of select="@data"/>
			<xsl:value-of select="following-sibling::element[starts-with(@location,concat($elementLocation,'.'))]/@data"/>
		</xsl:variable>
		<xsl:value-of select="string-length($value)"/>
	</xsl:template>
</xsl:stylesheet>
