<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:util="http://hl7.nist.gov/data-specs/util" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs" version="2.0">
	<xsl:output method="html"/>
	<!--  ROOT TEMPLATE. Call corresponding sub templates based on the output desired (parametrized) -->
	<xsl:variable name="MFN_M08" select="'MFN_M08'"/>
	<xsl:variable name="MFN_M10" select="'MFN_M10'"/>
	<xsl:variable name="MFN_M04" select="'MFN_M04'"/>
	<xsl:variable name="MFN_M18" select="'MFN_M18'"/>
	<xsl:variable name="MFK_M01" select="'MFK_M01'"/>
	<xsl:template match="*">
		<xsl:call-template name="plain-html"/>
	</xsl:template>
	<!-- This generates the structured DATA -->
	<xsl:template name="main">
		<xsl:variable name="message-type">
			<xsl:choose>
				<xsl:when test="starts-with(name(.), 'MFN_M08')">MFN_M08</xsl:when>
				<xsl:when test="starts-with(name(.), 'MFN_M10')">MFN_M10</xsl:when>
				<xsl:when test="starts-with(name(.), 'MFN_M04')">MFN_M04</xsl:when>
				<xsl:when test="starts-with(name(.), 'MFN_M18')">MFN_M18</xsl:when>
				<xsl:when test="starts-with(name(.), 'MFK_M01')">MFK_M01</xsl:when>
				<!-- other message types-->
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="div">
			<xsl:attribute name="class">test-data-specs-main</xsl:attribute>
			<xsl:element name="tabset">
				<!-- M08 -->
				<xsl:if test="$message-type = 'MFN_M08'">
					<xsl:apply-templates select="//MFN_M08/MFI"/>
					<xsl:element name="tab">
						<xsl:attribute name="heading" select="'Test Details[*]'"/>
						<xsl:attribute name="vertical">false</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">panel panel-info</xsl:attribute>
							<xsl:element name="div">
								<xsl:attribute name="class">panel-body</xsl:attribute>
								<xsl:element name="fieldset">
									<!-- <xsl:element name="legend">Test Details[*]</xsl:element> -->
									<xsl:element name="accordion">
										<xsl:apply-templates select="//MFN_M08/MFN_M08.MF_TEST"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- M10 -->
				<xsl:if test="$message-type = 'MFN_M10'">
					<xsl:apply-templates select="//MFN_M10/MFI"/>
					<xsl:element name="tab">
						<xsl:attribute name="heading" select="'Panel/Test battery Information[*]'"/>
						<xsl:attribute name="vertical">false</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">panel panel-info</xsl:attribute>
							<xsl:element name="div">
								<xsl:attribute name="class">panel-body</xsl:attribute>
								<xsl:element name="fieldset">
								<!-- <xsl:element name="legend">Panel/Test battery Information[*]</xsl:element> -->
									<xsl:element name="accordion">
										<xsl:apply-templates select="//MFN_M10/MFN_M10.MF_BATTERY"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- M04 -->
				<xsl:if test="$message-type = 'MFN_M04'">
					<xsl:apply-templates select="//MFN_M04/MFI"/>
					<xsl:apply-templates select="//MFN_M04/NTE"/>
					<xsl:element name="tab">
						<xsl:attribute name="heading" select="'Charge Information[*]'"/>
						<xsl:attribute name="vertical">false</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">panel panel-info</xsl:attribute>
							<xsl:element name="div">
								<xsl:attribute name="class">panel-body</xsl:attribute>
								<xsl:element name="fieldset">
								<!-- <xsl:element name="legend">Charge Information[*]</xsl:element> -->
									<xsl:element name="accordion">
										<xsl:apply-templates select="//MFN_M04/MFN_M04.MF_CDM"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!-- M18 -->
				<xsl:if test="$message-type = 'MFN_M18'">
					<xsl:apply-templates select="//MFN_M18/MFI"/>
					<xsl:element name="tab">
						<xsl:attribute name="heading" select="'Payer Information[*]'"/>
						<xsl:attribute name="vertical">false</xsl:attribute>
						<xsl:element name="div">
							<xsl:attribute name="class">panel panel-info</xsl:attribute>
							<xsl:element name="div">
								<xsl:attribute name="class">panel-body</xsl:attribute>
								<xsl:element name="fieldset">
									<!-- <xsl:element name="legend">Payer Information[*]</xsl:element> -->
									<xsl:element name="accordion">
										<xsl:apply-templates select="//MFN_M18/MFN_M18.MF_PAYER"/>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<!--MFK M08 MFK M10 MFK M04 MFK M18-->
				<xsl:if test="$message-type = 'MFK_M01'">
					<xsl:apply-templates select="//MFK_M01/MSA"/>
					<xsl:apply-templates select="//MFK_M01/MFI"/>
				</xsl:if>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="MFI">
		<xsl:element name="tab">
			<xsl:attribute name="heading">Master File Identification</xsl:attribute>
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- Master File Identifier -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Identifier'"/>
						<xsl:with-param name="value" select=".//MFI.1.1"/>
					</xsl:call-template>
					<!-- File-Level Event Code -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Event code'"/>
						<xsl:with-param name="value" select="./MFI.3"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="MSA">
		<xsl:element name="tab">
			<xsl:attribute name="heading">Acknowledgement</xsl:attribute>
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Acknowledgment Code'"/>
						<xsl:with-param name="value" select=".//MSA.1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="MFN_M08.MF_TEST">
		<xsl:variable name="testName" select="./MFE/MFE.4/MFE.4.2"/>
		<xsl:variable name="position"> <xsl:value-of select="concat('TestDetails',position())"/></xsl:variable>
		<xsl:element name="accordion-group">
			<xsl:attribute name="class" select="'panel-info'"/>
			<xsl:attribute name="type" select="'pills'"/>
			<xsl:attribute name="style" select="'margin-top:0;border: 1px ridge  #C6DEFF;'"/>
			<xsl:attribute name="is-open" select="$position"/>
			<xsl:attribute name="vertical" select="'true'"/>
			
			<xsl:element name="accordion-heading">
				<xsl:element name="span">
					<xsl:attribute name="class">clearfix</xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">accordion-heading pull-left</xsl:attribute>
						<xsl:element name="i">
							<xsl:attribute name="class">pull-left fa</xsl:attribute>
							<xsl:attribute name="ng-class"><xsl:value-of select="concat('{''fa-caret-down'': ',$position,', ''fa-caret-right'': !',$position,'}')"/></xsl:attribute>
						</xsl:element>
						<xsl:value-of select="concat('Test Details - ',$testName)"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:element name="div">
				<xsl:attribute name="class">panel panel-info</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">panel-body</xsl:attribute>
						<xsl:apply-templates select="./MFE"/>
						<xsl:apply-templates select="./OM1"/>
						<xsl:apply-templates select=".//OMC"/>
						<xsl:apply-templates select=".//OM2"/>
						<xsl:apply-templates select=".//OM3"/>
						<xsl:apply-templates select=".//OM4"/>
				</xsl:element>
			</xsl:element>
			

			<!-- <xsl:attribute name="heading" select="concat('Test Details - ',$testName)"/> -->

		</xsl:element>
	</xsl:template>
	<xsl:template match="MFN_M10.MF_BATTERY">
		<xsl:variable name="testName" select="./MFE/MFE.4/MFE.4.2"/>
		<xsl:variable name="position"> <xsl:value-of select="concat('PanelDetails',position())"/></xsl:variable>

		<xsl:element name="accordion-group">
			<xsl:attribute name="class" select="'panel-info'"/>
			<xsl:attribute name="type" select="'pills'"/>
			<xsl:attribute name="style" select="'margin-top:0;border: 1px ridge  #C6DEFF;'"/>
			<xsl:attribute name="is-open" select="$position"/>
			<xsl:attribute name="vertical" select="'true'"/>
			
			<!-- <xsl:attribute name="heading" select="concat('Panel/Test battery Information - ',$testName)"/> -->
			<xsl:element name="accordion-heading">
				<xsl:element name="span">
					<xsl:attribute name="class">clearfix</xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">accordion-heading pull-left</xsl:attribute>
						<xsl:element name="i">
							<xsl:attribute name="class">pull-left fa</xsl:attribute>
							<xsl:attribute name="ng-class"><xsl:value-of select="concat('{''fa-caret-down'': ',$position,', ''fa-caret-right'': !',$position,'}')"/></xsl:attribute>
						</xsl:element>
						<xsl:value-of select="concat('Panel/Test battery Information - ',$testName)"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>			
			
			<xsl:element name="div">
				<xsl:attribute name="class">panel panel-info</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">panel-body</xsl:attribute>		
					<xsl:apply-templates select="./MFE"/>
					<xsl:apply-templates select="./OM1"/>
					<xsl:apply-templates select=".//MFN_M10.MF_BATTERY.BATTERY_DETAIL"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="MFN_M10.MF_BATTERY.BATTERY_DETAIL">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Panel/Test battery Details</xsl:element>
			<xsl:apply-templates select="./OM5"/>
			<xsl:apply-templates select=".//OM4"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="MFN_M04.MF_CDM">
		<xsl:variable name="testName" select="./MFE/MFE.4/MFE.4.2"/>
		<xsl:variable name="position"> <xsl:value-of select="concat('ChargeInfo',position())"/></xsl:variable>

		<xsl:element name="accordion-group">
			<xsl:attribute name="class" select="'panel-info'"/>
			<xsl:attribute name="type" select="'pills'"/>
			<xsl:attribute name="style" select="'margin-top:0;border: 1px ridge  #C6DEFF;'"/>
			<xsl:attribute name="is-open" select="$position"/>
			<xsl:attribute name="vertical" select="'true'"/>
			
			<xsl:element name="accordion-heading">
				<xsl:element name="span">
					<xsl:attribute name="class">clearfix</xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">accordion-heading pull-left</xsl:attribute>
						<xsl:element name="i">
							<xsl:attribute name="class">pull-left fa</xsl:attribute>
							<xsl:attribute name="ng-class"><xsl:value-of select="concat('{''fa-caret-down'': ',$position,', ''fa-caret-right'': !',$position,'}')"/></xsl:attribute>
						</xsl:element>
						<xsl:value-of select="concat('Charge Information - ',$testName)"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			
			<!-- <xsl:attribute name="heading" select="concat('Charge Information - ',$testName)"/> -->
			<xsl:element name="div">
				<xsl:attribute name="class">panel panel-info</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">panel-body</xsl:attribute>
						<xsl:apply-templates/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="MFN_M18.MF_PAYER">
		<xsl:variable name="testName" select="./MFE/MFE.4/MFE.4.2"/>
		<xsl:variable name="position"> <xsl:value-of select="concat('PayerInfo',position())"/></xsl:variable>

		<xsl:element name="accordion-group">
			<xsl:attribute name="class" select="'panel-info'"/>
			<xsl:attribute name="type" select="'pills'"/>
			<xsl:attribute name="style" select="'margin-top:0;border: 1px ridge  #C6DEFF;'"/>
			<xsl:attribute name="is-open" select="$position"/>
			<xsl:attribute name="vertical" select="'true'"/>
			
			<xsl:element name="accordion-heading">
				<xsl:element name="span">
					<xsl:attribute name="class">clearfix</xsl:attribute>
					<xsl:element name="span">
						<xsl:attribute name="class">accordion-heading pull-left</xsl:attribute>
						<xsl:element name="i">
							<xsl:attribute name="class">pull-left fa</xsl:attribute>
							<xsl:attribute name="ng-class"><xsl:value-of select="concat('{''fa-caret-down'': ',$position,', ''fa-caret-right'': !',$position,'}')"/></xsl:attribute>
						</xsl:element>
						<xsl:value-of select="concat('Payer Information - ',$testName)"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			
			<!-- <xsl:attribute name="heading" select="concat('Payer Information - ',$testName)"/> -->
			<xsl:element name="div">
				<xsl:attribute name="class">panel panel-info</xsl:attribute>
				<xsl:element name="div">
					<xsl:attribute name="class">panel-body</xsl:attribute>
					<xsl:apply-templates select="./MFE"/>
					<xsl:apply-templates select=".//MFN_M18.MF_PAYER.PAYER_MF_Entry"/>
				</xsl:element>
			</xsl:element>		
		</xsl:element>
	</xsl:template>
	<xsl:template match="MFN_M18.MF_PAYER.PAYER_MF_Entry">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Payer &amp; coverage details</xsl:element>
			<!-- <xsl:attribute name="heading">Payer &amp; coverage details</xsl:attribute> -->
			<xsl:apply-templates select="./PM1"/>
			<xsl:apply-templates select=".//MFN_M18.MF_PAYER.PAYER_MF_Entry.PAYER_MF_Coverage"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="MFN_M18.MF_PAYER.PAYER_MF_Entry.PAYER_MF_Coverage">
		<xsl:apply-templates select="./MCP[MCP.3 or MCP.4]"/>
	</xsl:template>
	<xsl:template match="MFE">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Record information</xsl:element>
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- Record-Level Event Code -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Event code'"/>
						<xsl:with-param name="value" select=".//MFE.1"/>
					</xsl:call-template>
					<!-- Effective Date/Time -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Effective date and time'"/>
						<xsl:with-param name="value" select=".//MFE.3.1"/>
					</xsl:call-template>
					<!-- Primary Key Value – MFE -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Test/Panel Name'"/>
						<xsl:with-param name="value" select=".//MFE.4.2"/>
					</xsl:call-template>
					<!--					<xsl:value-of select="util:element('Test/Panel identifier (code system)',  concat(.//MFE.4.1,' (', .//MFE.4.3,')'))"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Test/Panel identifier (code system)'"/>
						<xsl:with-param name="value" select="concat(.//MFE.4.1,' (', .//MFE.4.3,')')"/>
					</xsl:call-template>
					<!--					<xsl:value-of select="util:end-elements()"/>
-->
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="OM1">
		<xsl:element name="fieldset">
			<xsl:element name="legend">General information</xsl:element>
			<!--		<xsl:value-of select="util:title('title', 'General information')"/>
-->
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- Specimen required -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Specimen required ?'"/>
						<xsl:with-param name="value" select="./OM1.4"/>
					</xsl:call-template>
					<!-- Producer ID -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Producer'"/>
						<xsl:with-param name="value" select="./OM1.5.2"/>
					</xsl:call-template>
					<xsl:if test="./OM1.5.1">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Producer identifier  (code system)'"/>
							<xsl:with-param name="value" select="concat(./OM1.5.1,' (',./OM1.5.3,')')"/>
						</xsl:call-template>
					</xsl:if>
					<!-- other id -->
					<xsl:for-each select=".//OM1.7">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Test/Panel other name'"/>
							<xsl:with-param name="value" select="./OM1.7.2"/>
						</xsl:call-template>
						<xsl:if test="./OM1.7.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Test/Panel other identifier  (code system)'"/>
								<xsl:with-param name="value" select="concat(./OM1.7.1,' (',./OM1.7.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- prefered name -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Preferred Report Name'"/>
						<xsl:with-param name="value" select="./OM1.9"/>
					</xsl:call-template>
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Preferred Short  Name'"/>
						<xsl:with-param name="value" select="./OM1.10"/>
					</xsl:call-template>
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Preferred Long   Name'"/>
						<xsl:with-param name="value" select="./OM1.11"/>
					</xsl:call-template>
					<!-- Orderability-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Is the test/panel orderable ?'"/>
						<xsl:with-param name="value" select="./OM1.12"/>
					</xsl:call-template>
					<!-- Nature -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Nature'"/>
						<xsl:with-param name="value" select="./OM1.18"/>
					</xsl:call-template>
					<!-- Interpretation  -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Interpretation'"/>
						<xsl:with-param name="value" select="./OM1.32"/>
					</xsl:call-template>
					<!-- Contraindications   -->
					<xsl:for-each select="./OM1.33">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Contraindications'"/>
							<xsl:with-param name="value" select="./OM1.33.2"/>
						</xsl:call-template>
						<xsl:if test="./OM1.33.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Contraindications (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(./OM1.33.1,' (',./OM1.33.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!--  Reflex   -->
					<xsl:for-each select="./OM1.34">
						<xsl:variable name="position" select="position()"/>
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Reflex test'"/>
							<xsl:with-param name="value" select="./OM1.34.2"/>
						</xsl:call-template>
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Reflex test (code &amp; code system)'"/>
							<xsl:with-param name="value" select="concat(./OM1.34.1,' (',./OM1.34.3,')')"/>
						</xsl:call-template>
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Reflex trigger rule'"/>
							<xsl:with-param name="value" select="../OM1.35[position() = $position]"/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- patient preparation -->
					<xsl:for-each select="./OM1.37">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Patient preparation'"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- Factors that may Affect the Observation-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Factors that may affect the test'"/>
						<xsl:with-param name="value" select="./OM1.39"/>
					</xsl:call-template>
					<!-- Performance Schedule-->
					<xsl:for-each select="./OM1.40">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Schedule'"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- Exclusive Test -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Is the test exclusive ?'"/>
						<xsl:with-param name="value" select="./OM1.48"/>
					</xsl:call-template>
					<!-- Diagnostic Service Sector ID -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Diagnostic Service Sector'"/>
						<xsl:with-param name="value" select="./OM1.49"/>
					</xsl:call-template>
					<!-- Other Names -->
					<xsl:for-each select=".//OM1.51">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Test alias'"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- Replacement test -->
					<xsl:for-each select=".//OM1.52">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Replacement test'"/>
							<xsl:with-param name="value" select="./OM1.52.2"/>
						</xsl:call-template>
						<xsl:if test="./OM1.52.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Replacement test (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(./OM1.52.1,' (',./OM1.52.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- Prior Results Instructions -->
					<xsl:for-each select="./OM1.53">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Prior Results Instructions'"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- Special  Instructions -->
					<xsl:for-each select="./OM1.54">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Special Instructions'"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- Test Relationship Category -->
					<xsl:for-each select="./OM1.55">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Test Relationship Category'"/>
							<xsl:with-param name="value" select="./OM1.55.2"/>
						</xsl:call-template>
						<xsl:if test="./OM1.55.1">
							<!--							<xsl:value-of select="util:element('Test Relationship Category (code &amp; code system)',  concat(./OM1.55.1,' (',./OM1.55.3,')'))"/>
-->
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Test Relationship Category (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(./OM1.55.1,' (',./OM1.55.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- Code for results -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Code for results'"/>
						<xsl:with-param name="value" select="./OM1.56.2"/>
					</xsl:call-template>
					<xsl:if test="./OM1.56.1">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Code for results (code system)'"/>
							<xsl:with-param name="value" select="concat(./OM1.56.1,' (',./OM1.56.3,')')"/>
						</xsl:call-template>
					</xsl:if>
					<!-- Expected turn around time -->
					<!--					<xsl:value-of select="util:element('Expected turn around time',  concat(.//OM1.57.1,' ',.//OM1.57.2.2))"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Expected turn around time'"/>
						<xsl:with-param name="value" select="string-join((.//OM1.57.1,.//OM1.57.2.2),' ')"/>
					</xsl:call-template>
					<!-- Gender Restriction   -->
					<xsl:for-each select="./OM1.58">
						<!--						<xsl:value-of select="util:element('Gender Restriction',  ./OM1.58.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Gender Restriction'"/>
							<xsl:with-param name="value" select="./OM1.58.2"/>
						</xsl:call-template>
						<xsl:if test="./OM1.58.1">
							<!--							<xsl:value-of select="util:element('Gender Restriction (code &amp; code system)',  concat(./OM1.58.1,' (',./OM1.58.3,')'))"/>
-->
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Gender Restriction (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(./OM1.58.1,' (',./OM1.58.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- Age Restriction   -->
					<xsl:for-each select="./OM1.59">
						<!--						<xsl:value-of select="util:element('Age Restriction',  concat('Between ',.//OM1.59.1,' and ',.//OM1.59.2))"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Age Restriction'"/>
							<xsl:with-param name="value" select="concat('Between ',.//OM1.59.1,' and ',.//OM1.59.2)"/>
						</xsl:call-template>
					</xsl:for-each>
					<!--					<xsl:value-of select="util:end-elements()"/>
-->
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="OMC">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Ask at Order Entry questions</xsl:element>
			<!--		<xsl:value-of select="util:title('title', 'Ask at Order Entry questions')"/>
-->
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- segment action code -->
					<!--					<xsl:value-of select="util:element('Action code',  ./OMC.2)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Action code'"/>
						<xsl:with-param name="value" select="./OMC.2"/>
					</xsl:call-template>
					<!-- segment id -->
					<!--					<xsl:value-of select="util:element('Key identifier', .//OMC.3.1)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Key identifier'"/>
						<xsl:with-param name="value" select=".//OMC.3.1"/>
					</xsl:call-template>
					<!--					<xsl:value-of select="util:element('Key namespace', .//OMC.3.2)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Key namespace'"/>
						<xsl:with-param name="value" select=".//OMC.3.2"/>
					</xsl:call-template>
					<!--					<xsl:value-of select="util:element('Key universal id', .//OMC.3.3)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Key universal id'"/>
						<xsl:with-param name="value" select=".//OMC.3.3"/>
					</xsl:call-template>
					<!-- AOE question -->
					<!--					<xsl:value-of select="util:element('AOE question', .//OMC.4.2)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'AOE question'"/>
						<xsl:with-param name="value" select=".//OMC.4.2"/>
					</xsl:call-template>
					<!--					<xsl:value-of select="util:element('AOE question (code &amp; code system)',  concat(.//OMC.4.1,' (',.//OMC.4.3,')'))"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'AOE question (code &amp; code system)'"/>
						<xsl:with-param name="value" select="concat(.//OMC.4.1,' (',.//OMC.4.3,')')"/>
					</xsl:call-template>
					<!-- Collection Event/Process Step-->
					<xsl:for-each select="./OMC.5">
						<!--						<xsl:value-of select="util:element('Collection Event/Process Step',  ./OMC.5.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Collection Event/Process Step'"/>
							<xsl:with-param name="value" select="./OMC.5.2"/>
						</xsl:call-template>
						<xsl:if test="./OMC.5.1">
							<!--							<xsl:value-of select="util:element('Collection Event/Process Step (code &amp; code system)',  concat(./OMC.5.1,' (',./OMC.5.3,')'))"/>
-->
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Collection Event/Process Step (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(./OMC.5.1,' (',./OMC.5.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- Communication Location -->
					<!--					<xsl:value-of select="util:element('Communication Location', .//OMC.6.2)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Communication Location'"/>
						<xsl:with-param name="value" select=".//OMC.6.2"/>
					</xsl:call-template>
					<xsl:if test="./OMC.6.1">
						<!--						<xsl:value-of select="util:element('Communication Location (code &amp; code system)',  concat(./OMC.6.1,' (',./OMC.6.3,')'))"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Communication Location (code &amp; code system)'"/>
							<xsl:with-param name="value" select="concat(./OMC.6.1,' (',./OMC.6.3,')')"/>
						</xsl:call-template>
					</xsl:if>
					<!-- Answer Required-->
					<!--					<xsl:value-of select="util:element('Is an answer required ?', .//OMC.7)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Is an answer required ?'"/>
						<xsl:with-param name="value" select=".//OMC.7"/>
					</xsl:call-template>
					<!-- Hint/Help Text-->
					<!--					<xsl:value-of select="util:element('Hint/Help Text', .//OMC.8)"/>	
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Hint/Help Text'"/>
						<xsl:with-param name="value" select=".//OMC.8"/>
					</xsl:call-template>
					<!-- Type of Answer-->
					<!--					<xsl:value-of select="util:element('Type of Answer', .//OMC.9)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Type of Answer'"/>
						<xsl:with-param name="value" select=".//OMC.9"/>
					</xsl:call-template>
					<!-- Answer Choices-->
					<xsl:for-each select="./OMC.11">
						<!--						<xsl:value-of select="util:element('Answer Choices',  ./OMC.5.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Answer Choices'"/>
							<xsl:with-param name="value" select="./OMC.5.2"/>
						</xsl:call-template>
						<xsl:if test="./OMC.11.1">
							<!--							<xsl:value-of select="util:element('Answer Choices (code &amp; code system)',  concat(./OMC.11.1,' (',./OMC.11.3,')'))"/>
-->
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Answer Choices (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(./OMC.11.1,' (',./OMC.11.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!--Character Limit-->
					<!--					<xsl:value-of select="util:element('Character Limit', .//OMC.12)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Character Limit'"/>
						<xsl:with-param name="value" select=".//OMC.12"/>
					</xsl:call-template>
					<!--Number of Decimals-->
					<!--					<xsl:value-of select="util:element('Number of Decimals', .//OMC.13)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Number of Decimals'"/>
						<xsl:with-param name="value" select=".//OMC.13"/>
					</xsl:call-template>
					<!--					<xsl:value-of select="util:end-elements()"/>
-->
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="OM2">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Numeric test details</xsl:element>
			<!--		<xsl:value-of select="util:title('title', 'Numeric test details')"/>
-->
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- unit of mesure -->
					<xsl:for-each select="./OM2.2">
						<!--						<xsl:value-of select="util:element('Unit of measure',  ./OM2.2.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Unit of measure'"/>
							<xsl:with-param name="value" select="./OM2.2.2"/>
						</xsl:call-template>
						<xsl:if test="./OM2.2.1">
							<!--							<xsl:value-of select="util:element('Unit of measure (code &amp; code system)',  concat(./OMC.2.1,' (',./OMC.2.3,')'))"/>
-->
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Unit of measure (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(./OM2.2.1,' (',./OM2.2.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- reference range -->
					<xsl:for-each select="./OM2.6">
						<!--						<xsl:value-of select="util:element('Reference range (low)', ./OM2.6.1.1)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Reference range (low)'"/>
							<xsl:with-param name="value" select="./OM2.6.1.1"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Reference range (high)', ./OM2.6.1.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Reference range (high)'"/>
							<xsl:with-param name="value" select="./OM2.6.1.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Reference range Administrative Sex', .//OM2.6.2.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Reference range Administrative Sex'"/>
							<xsl:with-param name="value" select=".//OM2.6.2.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Reference range Administrative Sex (code &amp; code system)',  concat(.//OM2.6.2.1,' (',.//OM2.6.2.3,')'))"/>
-->
						<xsl:if test=".//OM2.6.2.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Reference range Administrative Sex (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(.//OM2.6.2.1,' (',.//OM2.6.2.3,')')"/>
							</xsl:call-template>
						</xsl:if>
						<!--						<xsl:value-of select="util:element('Reference range Race/subspecies', .//OM2.6.6.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Reference range Race/subspecies'"/>
							<xsl:with-param name="value" select=".//OM2.6.6.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Reference range Race/subspecies (code &amp; code system)',  concat(.//OM2.6.6.1,' (',.//OM2.6.6.3,')'))"/>
-->
						<xsl:if test=".//OM2.6.6.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Reference range Race/subspecies (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(.//OM2.6.6.1,' (',.//OM2.6.6.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- critical range -->
					<xsl:for-each select="./OM2.7">
						<!--						<xsl:value-of select="util:element('Critical range (low)', ./OM2.7.1.1)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Critical range (low)'"/>
							<xsl:with-param name="value" select="./OM2.7.1.1"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Critical range (high)', ./OM2.7.1.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Critical range (high)'"/>
							<xsl:with-param name="value" select="./OM2.7.1.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Critical range Administrative Sex', .//OM2.7.2.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Critical range Administrative Sex'"/>
							<xsl:with-param name="value" select=".//OM2.7.2.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Critical range Administrative Sex (code &amp; code system)',  concat(.//OM2.7.2.1,' (',.//OM2.7.2.3,')'))"/>
-->
						<xsl:if test=".//OM2.7.2.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Critical range Administrative Sex (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(.//OM2.7.2.1,' (',.//OM2.7.2.3,')')"/>
							</xsl:call-template>
						</xsl:if>
						<!--					<xsl:value-of select="util:element('Critical range Race/subspecies', .//OM2.7.6.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Critical range Race/subspecies'"/>
							<xsl:with-param name="value" select=".//OM2.7.6.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Critical range Race/subspecies (code &amp; code system)',  concat(.//OM2.7.6.1,' (',.//OM2.7.6.3,')'))"/>
-->
						<xsl:if test=".//OM2.7.6.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Critical range Race/subspecies (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(.//OM2.7.6.1,' (',.//OM2.7.6.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- absolute range -->
					<xsl:for-each select="./OM2.8">
						<!--						<xsl:value-of select="util:element('Absolute range (low)', ./OM2.8.1.1)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Absolute range (low)'"/>
							<xsl:with-param name="value" select="./OM2.8.1.1"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Absolute range (high)', ./OM2.8.1.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Absolute range (high)'"/>
							<xsl:with-param name="value" select="./OM2.8.1.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Absolute range Administrative Sex', .//OM2.8.2.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Absolute range Administrative Sex'"/>
							<xsl:with-param name="value" select=".//OM2.8.2.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Absolute range Administrative Sex (code &amp; code system)',  concat(.//OM2.8.2.1,' (',.//OM2.8.2.3,')'))"/>
-->
						<xsl:if test=".//OM2.8.2.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Absolute range Administrative Sex (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(.//OM2.8.2.1,' (',.//OM2.8.2.3,')')"/>
							</xsl:call-template>
						</xsl:if>
						<!--						<xsl:value-of select="util:element('Absolute range Race/subspecies', .//OM2.8.6.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Absolute range Race/subspecies'"/>
							<xsl:with-param name="value" select=".//OM2.8.6.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Absolute range Race/subspecies (code &amp; code system)',  concat(.//OM2.7.6.1,' (',.//OM2.8.6.3,')'))"/>
-->
						<xsl:if test=".//OM2.7.6.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Absolute range Race/subspecies (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(.//OM2.7.6.1,' (',.//OM2.8.6.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!--					<xsl:value-of select="util:end-elements()"/>
-->
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="OM3">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Categorical test details</xsl:element>
			<!--		<xsl:value-of select="util:title('title', 'Categorical test details')"/>
-->
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- Normal Text/Codes  -->
					<xsl:for-each select="./OM3.4">
						<!--						<xsl:value-of select="util:element('Normal Text/Codes', .//OM3.4.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Normal Text/Codes'"/>
							<xsl:with-param name="value" select=".//OM3.4.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Normal Text/Codes (code &amp; code system)',  concat(.//OM3.4.1,' (',.//OM3.4.3,')'))"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Normal Text/Codes (code &amp; code system)'"/>
							<xsl:with-param name="value" select="concat(.//OM3.4.1,' (',.//OM3.4.3,')')"/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- Abnormal Text/Codes  -->
					<xsl:for-each select="./OM3.5">
						<!--						<xsl:value-of select="util:element('Abnormal Text/Codes', .//OM3.5.2)"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Abnormal Text/Codes'"/>
							<xsl:with-param name="value" select=".//OM3.5.2"/>
						</xsl:call-template>
						<!--						<xsl:value-of select="util:element('Abnormal Text/Codes (code &amp; code system)',  concat(.//OM3.5.1,' (',.//OM3.5.3,')'))"/>
-->
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Abnormal Text/Codes (code &amp; code system)'"/>
							<xsl:with-param name="value" select="concat(.//OM3.5.1,' (',.//OM3.5.3,')')"/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- Value type -->
					<!--					<xsl:value-of select="util:element('Value type', ./OM3.7)"/>
-->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Value type'"/>
						<xsl:with-param name="value" select="./OM3.7"/>
					</xsl:call-template>
					<!--					<xsl:value-of select="util:end-elements()"/>
-->
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="OM4">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Specimen information details</xsl:element>
			<!--		<xsl:value-of select="util:title('title', 'Specimen information details')"/>
-->
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- sequence id -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Sequence ID'"/>
						<xsl:with-param name="value" select="./OM4.1"/>
					</xsl:call-template>
					<!-- container description -->
					<xsl:for-each select="./OM4.3">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Container description'"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- container volume -->
					<xsl:for-each select="./OM4.4">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Container volume'"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:for-each>
					<!-- container units -->
					<xsl:for-each select="./OM4.5">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Container units'"/>
							<xsl:with-param name="value" select=".//OM4.5.2"/>
						</xsl:call-template>
						<xsl:if test=".//OM4.5.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Container units (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(.//OM4.5.1,' (',.//OM4.5.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- specimen -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Specimen'"/>
						<xsl:with-param name="value" select="./OM4.6.2"/>
					</xsl:call-template>
					<xsl:if test=".//OM4.6.1">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Specimen (code &amp; code system)'"/>
							<xsl:with-param name="value" select="concat(.//OM4.6.1,' (',.//OM4.6.3,')')"/>
						</xsl:call-template>
					</xsl:if>
					<!-- additive -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Additive'"/>
						<xsl:with-param name="value" select="./OM4.7.2"/>
					</xsl:call-template>
					<xsl:if test=".//OM4.7.1">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Specimen (code &amp; code system)'"/>
							<xsl:with-param name="value" select="concat(.//OM4.7.1,' (',.//OM4.7.3,')')"/>
						</xsl:call-template>
					</xsl:if>
					<!-- normal collection volume -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Normal collection volume'"/>
						<xsl:with-param name="value" select=".//OM4.10.1"/>
					</xsl:call-template>
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Normal collection volume unit'"/>
						<xsl:with-param name="value" select=".//OM4.10.2.2"/>
					</xsl:call-template>
					<xsl:if test=".//OM4.10.2.1">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Normal collection volume unit (code &amp; code system)'"/>
							<xsl:with-param name="value" select="concat(.//OM4.10.2.1,' (',.//OM4.10.2.3,')')"/>
						</xsl:call-template>
					</xsl:if>
					<!-- minimum collection volume -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Normal collection volume'"/>
						<xsl:with-param name="value" select=".//OM4.11.1"/>
					</xsl:call-template>
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Normal collection volume unit'"/>
						<xsl:with-param name="value" select=".//OM4.11.2.2"/>
					</xsl:call-template>
					<xsl:if test=".//OM4.11.2.1">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Normal collection volume unit (code &amp; code system)'"/>
							<xsl:with-param name="value" select="concat(.//OM4.11.2.1,' (',.//OM4.11.2.3,')')"/>
						</xsl:call-template>
					</xsl:if>
					<!-- Specimen Requirements -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Specimen Requirements'"/>
						<xsl:with-param name="value" select=".//OM4.12"/>
					</xsl:call-template>
					<!-- Specimen Handling Code  -->
					<xsl:for-each select="./OM4.15">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Specimen Handling Code'"/>
							<xsl:with-param name="value" select=".//OM4.15.2"/>
						</xsl:call-template>
						<xsl:if test=".//OM4.15.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Specimen Handling Code (code &amp; code system)'"/>
								<xsl:with-param name="value" select="concat(.//OM4.15.1,' (',.//OM4.15.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- Specimen Preference  -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Specimen Preference'"/>
						<xsl:with-param name="value" select=".//OM4.16"/>
					</xsl:call-template>
					<!-- Preferred Specimen/Attribute Sequence ID  -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Preferred Specimen Sequence ID'"/>
						<xsl:with-param name="value" select=".//OM4.17"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="OM5">
		<xsl:element name="fieldset">
			<!-- <xsl:element name="legend">Panel/test battery details</xsl:element> -->
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- Test/Observations Included Within an Ordered Test Battery-->
					<xsl:for-each select=".//OM5.2">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Test included in panel/test battery'"/>
							<xsl:with-param name="value" select=".//OM5.2.2"/>
						</xsl:call-template>
						<xsl:if test=".//OM5.2.1">
							<xsl:call-template name="util:element">
								<xsl:with-param name="name" select="'Test included in panel/test battery (code &amp; code system)'"/>
								<xsl:with-param name="value" select=" concat(.//OM5.2.1,' (',.//OM5.2.3,')')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="NTE">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Notes &amp; comments</xsl:element>
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- Comment -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Comment'"/>
						<xsl:with-param name="value" select=".//NTE.3"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="CDM">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Charge details</xsl:element>
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- primary key value -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Primary key value'"/>
						<xsl:with-param name="value" select=".//CDM.1.2"/>
					</xsl:call-template>
					<xsl:if test=".//CDM.1.1">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Primary key value (code &amp; code system)'"/>
							<xsl:with-param name="value" select="concat(.//CDM.1.1,' (',.//CDM.1.3,')')"/>
						</xsl:call-template>
					</xsl:if>
					<!-- charge description short -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Charge description'"/>
						<xsl:with-param name="value" select=".//CDM.3"/>
					</xsl:call-template>
					<!-- procedure code -->
					<xsl:for-each select="./CDM.7">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Procedure code'"/>
							<xsl:with-param name="value" select="./CDM.7.2"/>
						</xsl:call-template>
						<xsl:if test=".//CDM.7.1">
						</xsl:if>
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Procedure code(code &amp; code system)'"/>
							<xsl:with-param name="value" select="concat(.//CDM.7.1,' (',.//CDM.7.3,')')"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="PM1">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Payer</xsl:element>
			<xsl:element name="table">
				<xsl:element name="tbody">
					<xsl:call-template name="util:elements"/>
					<!-- PM1.1 Health Plan ID -->
					<xsl:call-template name="util:element">
						<xsl:with-param name="name" select="'Health Plan'"/>
						<xsl:with-param name="value" select=".//PM1.1.2"/>
					</xsl:call-template>
					<xsl:if test=".//PM1.1.1">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Health Plan (code &amp; code system)'"/>
							<xsl:with-param name="value" select="string-join((.//PM1.1.1,concat('(',.//PM1.1.3,')')),' ')"/>
						</xsl:call-template>
					</xsl:if>
					<!-- PM1.2 Insurance Company ID -->
					<xsl:for-each select=".//PM1.2.1">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Insurance Company'"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<xsl:template match="MCP">
		<xsl:element name="fieldset">
			<xsl:element name="legend">Coverage Policy</xsl:element>
			<xsl:element name="table">
				<xsl:element name="tbody">
					<!-- MCP-3 Universal Service Price Range – Low Value -->
					<xsl:if test=".//MCP.3">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Low price range'"/>
							<xsl:with-param name="value" select="concat(.//MCP.3.2,' ',.//MCP.3.1)"/>
						</xsl:call-template>
					</xsl:if>
					<!-- MCP-4 Universal Service Price Range – High Value -->
					<xsl:if test=".//MCP.4">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'High price range'"/>
							<xsl:with-param name="value" select="concat(.//MCP.4.2,' ',.//MCP.4.1)"/>
						</xsl:call-template>
					</xsl:if>
					<!-- MCP-5 Reason for Universal Service Cost Range -->
					<xsl:if test=".//MCP.5">
						<xsl:call-template name="util:element">
							<xsl:with-param name="name" select="'Reason for universal service cost range'"/>
							<xsl:with-param name="value" select=".//MCP.5"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	<!-- plain-html : create a head with css and a body around the "main" template to make it a plain html -->
	<xsl:template name="plain-html">
		<xsl:call-template name="css"/>
		<xsl:call-template name="main"/>
	</xsl:template>
	<!-- css template to be output in the head for html outputs -->
	<!-- contains style for graying out and separator -->
	<xsl:template name="css">
		<style type="text/css">
		@media screen {		
		.test-data-specs-main maskByMediaType {display:table;}			
				
		.test-data-specs-main table tbody tr th {font-size:95%}			
		.test-data-specs-main table tbody tr td {font-size:100%;}			
		.test-data-specs-main table tbody tr th {text-align:left;background:#C6DEFF}			
		.test-data-specs-main table thead tr th {text-align:center;}			
		.test-data-specs-main {text-align:center;}			
		.test-data-specs-main table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;border-collapse: collapse;}			
		.test-data-specs-main table  tr { border: 3px groove; }			
		.test-data-specs-main table  th { border: 2px groove;}			
		.test-data-specs-main table  td { border: 2px groove; }			
		.test-data-specs-main table thead {border: 1px groove;background:#446BEC;text-align:left;}			
		.test-data-specs-main table tbody tr td {text-align:left}				
			
		/* Don't display empty rows */
		.test-data-specs-main .tds_noData {display:none;}
	
		}	
			
			@media print {
		.test-data-specs-main 
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
		
		.test-data-specs-main .tds_noData {display:none;}
				
		.test-data-specs-main .tds_title {text-align:left;margin-bottom:1%}			
		.test-data-specs-main h3 {text-align:center;}			
		.test-data-specs-main h2 {text-align:center;}			
		.test-data-specs-main h1 {text-align:center;}	
		.test-data-specs-main .tds_pgBrk {page-break-after:always;}
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
	<!-- elements: <table><tbody><tr><th>Element </th> <th> Data </th> </tr>  -->
	<xsl:template name="util:elements">
		<xsl:element name="tr">
			<xsl:element name="th">Element</xsl:element>
			<xsl:element name="th">Data</xsl:element>
		</xsl:element>
	</xsl:template>
	<!--  element: calls element-with-delimiter with value , ; basically generates table row element -->
	<xsl:template name="util:element">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:call-template name="util:element-with-delimiter">
			<xsl:with-param name="name" select="$name"/>
			<xsl:with-param name="value" select="$value"/>
		</xsl:call-template>
	</xsl:template>
	<!-- element-with-delimiter:  generates <tr> <td> name </td> <td> value </td> </tr>  (adds a class 'tds_noData' to gray out if value is empty -->
	<xsl:template name="util:element-with-delimiter">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:element name="tr">
			<xsl:if test="normalize-space($value) = ''">
				<xsl:attribute name="class">tds_noData</xsl:attribute>
			</xsl:if>
			<xsl:element name="td">
				<xsl:value-of select="$name" disable-output-escaping="no"/>
			</xsl:element>
			<xsl:element name="td">
				<xsl:if test="normalize-space($value) = ''">
					<xsl:attribute name="class">tds_noData</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$value" disable-output-escaping="no"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
