<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>
	<xsl:param name="testCaseId" select="event-profiles/test-message/@instance"/>
	<!-- <xsl:param name="filterMask" select="event-profiles/message-description/properties[@id=$testCaseId]/@vendorDSFilter"/>-->
	<xsl:param name="msgType" select="//element[@location='MSH.9.2']/@data"/>
	<xsl:param name="filterMask" select="$typeToMask/filterMasks/filterMask[@msgType=$msgType]/@mask"/>
	<xsl:param name="filterGroup" select="'FULL'"/>
	<xsl:variable name="typeToMask">
		<!-- 
			1: Master File identification
			2: Test information
			3:	Battery information
			4: Charge descrption information
	-->
		<filterMasks>
			<filterMask msgType="M04" mask="1:4"/>
			<filterMask msgType="M08" mask="1:2"/>
			<filterMask msgType="M10" mask="1:3"/>
		</filterMasks>
	</xsl:variable>
	<xsl:variable name="tables">
		<table id="0074">
			<entry key="AU">Audiology</entry>
			<entry key="BG">Blood Gases</entry>
			<entry key="BLB">Blood Bank</entry>
			<entry key="CUS">Cardiac Ultrasound</entry>
			<entry key="CTH">Cardiac Catheterization</entry>
			<entry key="CT">CAT Scan</entry>
			<entry key="CH">Chemistry</entry>
			<entry key="CP">Cytopathology</entry>
			<entry key="EC">Electrocardiac (e.g., EKG,  EEC, Holter)</entry>
			<entry key="EN">Electroneuro (EEG, EMG,EP,PSG)</entry>
			<entry key="HM">Hematology</entry>
			<entry key="ICU">Bedside ICU Monitoring</entry>
			<entry key="IMM">Immunology</entry>
			<entry key="LAB">Laboratory</entry>
			<entry key="MB">Microbiology</entry>
			<entry key="MCB">Mycobacteriology</entry>
			<entry key="MYC">Mycology</entry>
			<entry key="NMS">Nuclear Medicine Scan</entry>
			<entry key="NMR">Nuclear Magnetic Resonance</entry>
			<entry key="NRS">Nursing Service Measures</entry>
			<entry key="OUS">OB Ultrasound</entry>
			<entry key="OT">Occupational Therapy</entry>
			<entry key="OTH">Other</entry>
			<entry key="OSL">Outside Lab</entry>
			<entry key="PHR">Pharmacy</entry>
			<entry key="PT">Physical Therapy</entry>
			<entry key="PHY">Physician (Hx. Dx, admission note, etc.)</entry>
			<entry key="PF">Pulmonary Function</entry>
			<entry key="RAD">Radiology</entry>
			<entry key="RX">Radiograph</entry>
			<entry key="RUS">Radiology Ultrasound</entry>
			<entry key="RC">Respiratory Care (therapy)</entry>
			<entry key="RT">Radiation Therapy</entry>
			<entry key="SR">Serology</entry>
			<entry key="SP">Surgical Pathology</entry>
			<entry key="TX">Toxicology</entry>
			<entry key="VUS">Vascular Ultrasound</entry>
			<entry key="VR">Virology</entry>
			<entry key="XRC">Cineradiograph</entry>
		</table>
		<table id="0125">
			<entry key="CE">Coded Entry</entry>
			<entry key="CWE">Coded Entry</entry>
			<entry key="CX">Extended Composite ID With Check Digit</entry>
			<entry key="DT">Date</entry>
			<entry key="ED">Encapsulated Data</entry>
			<entry key="FT">Formatted Text (Display)</entry>
			<entry key="NM">Numeric</entry>
			<entry key="RP">Reference Pointer</entry>
			<entry key="SN">Structured Numeric</entry>
			<entry key="ST">String Data.</entry>
			<entry key="TM">Time</entry>
			<entry key="TS">Time Stamp (Date &amp; Time)</entry>
			<entry key="TX">Text Data (Display)</entry>
		</table>
		<table id="0175">
			<entry key="CDM">Charge description master file</entry>
			<entry key="CMA">Clinical study with phases and scheduled master file</entry>
			<entry key="CMB">Clinical study without phases but with scheduled master file</entry>
			<entry key="LOC">Location master file</entry>
			<entry key="OMA">Numerical observation master file</entry>
			<entry key="OMB">Categorical observation master file</entry>
			<entry key="OMC">Observation batteries master file</entry>
			<entry key="OMD">Calculated observations master file</entry>
			<entry key="PRA">Practitioner master file</entry>
			<entry key="STF">Staff master file</entry>
			<entry key="CLN">Clinic master file</entry>
			<entry key="OME">Other Observation/Service Item master file</entry>
			<entry key="INV">Inventory master file</entry>
		</table>
		<table id="0178">
			<entry key="REP">Replace current version of this master file with the version contained in this message</entry>
			<entry key="UPD">Change file records as defined in the record-level event codes for each record that follows</entry>
		</table>
		<table id="0179">
			<entry key="NE">Never.  No application-level response needed</entry>
		</table>
		<table id="0180">
			<entry key="MAD">Add record to master file</entry>
			<entry key="MUP">Update record for master file</entry>
			<entry key="MDC">Deactivate: discontinue using record in master file, but do not delete from database</entry>
			<entry key="MAC">Reactivate deactivated record</entry>
		</table>
		<table id="0355">
			<entry key="CWE">Coded with Exceptions</entry>
		</table>
		<table id="0136">
			<entry key="Y">Yes</entry>
			<entry key="N">No</entry>
		</table>
		<table id="0919">
			<entry key="Y">This test should be exclusive</entry>
			<entry key="N">This test can be included with any number of other tests</entry>
			<entry key="D">In some cases, this test should be only exclusively with like tests (examples are cyto or pathology)</entry>
		</table>
		<table id="0920">
			<entry key="P">Preferred</entry>
			<entry key="A">Alternate</entry>
		</table>
	</xsl:variable>
	<xsl:variable name="dataSheetSeg">
		<filter-groups>
			<filters title="Master File Identification" group="MFI" scope="1">
				<!-- value fixed by edos-9, edos-10 edos-11 -->
				<!-- <filter mask="MFI.1" title="Master File Identifier" format="cwe" table="0175"/>-->
				<filter mask="MFI.3" title="File-Level Event Code" format="coded" table="0178"/>
				<!-- value fixed by edos-12 -->
				<!-- <filter mask="MFI.6" title="Response Level Code" format="coded" table="0179"/> -->
			</filters>
			<filters title="Master File Entry" group="MFE" scope="2:3:4">
				<filter mask="MFE.1" title="Record-Level Event Code" format="coded" table="0180"/>
				<!-- always optional -->
				<!-- <filter mask="MFE.2" title="MFN Control ID" format="st"/>-->
				<filter mask="MFE.3.1" title="Effective Date/Time" format="dtm"/>
				<!-- matches OM1-2 ? -->
				<filter mask="MFE.4" title="Primary Key Value - MFE" format="cwe"/>
				<!-- value fixed by edos-13 -->
				<!-- <filter mask="MFE.5" title="Primary Key Value Type" format="coded" table="0355"/>-->
			</filters>
			<filters title="General Segment" group="OM1" scope="2:3:4">
				<!-- set by IG/HL7 -->
				<!-- <filter mask="OM1.1" title="Sequence Number - Test/Observation Master File" format="st"/> -->
				<!-- matches MFE-4 -->
				<!-- <filter mask="OM1.2" title="Producer's Service/Test/Observation ID" format="cwe"/> -->
				<filter mask="OM1.4" title="Specimen Required" format="coded" table="0136"/>
				<filter mask="OM1.5" title="Producer ID" format="cwe" table="99USI_OM1_5"/>
				<filter mask="OM1.7" title="Other Service/Test/Observation IDs for the Observation" format="cwe" table="9999_LN"/>
				<filter mask="OM1.9" title="Preferred Report Name for the Observation" format="st"/>
				<filter mask="OM1.10" title="Preferred Short Name or Mnemonic for Observation" format="st"/>
				<filter mask="OM1.11" title="Preferred Long Name for the Observation" format="st"/>
				<filter mask="OM1.12" title="Orderability" format="coded" table="0136"/>
				<filter mask="OM1.18" title="Nature of Service/Test/Observation" format="st"/>
				<filter mask="OM1.27[1]" title="Outside Site(s) Where Observation may be Performed" format="cwe"/>
				<filter mask="OM1.27[2]" title="Outside Site(s) Where Observation may be Performed" format="cwe"/>
				<filter mask="OM1.28[1]" title="Address of Outside Site(s)" format="xad"/>
				<filter mask="OM1.28[2]" title="Address of Outside Site(s)" format="xad"/>
				<filter mask="OM1.31[1]" title="Observations Required to Interpret the Observation" format="cwe" table="99USI_LN"/>
				<filter mask="OM1.31[2]" title="Observations Required to Interpret the Observation" format="cwe" table="99USI_LN"/>
				<filter mask="OM1.32[1]" title="Interpretation of Observations" format="st"/>
				<filter mask="OM1.33[1]" title="Contraindications to Observations" format="cwe" table="99USI_SCT"/>
				<filter mask="OM1.33[2]" title="Contraindications to Observations" format="cwe" table="99USI_SCT"/>
				<filter mask="OM1.34[1]" title="Reflex Tests/Observations" format="cwe" table="99USI_LN"/>
				<filter mask="OM1.34[2]" title="Reflex Tests/Observations" format="cwe" table="99USI_LN"/>
				<filter mask="OM1.35[1]" title="Rules that Trigger Reflex Testing" format="st"/>
				<filter mask="OM1.35[2]" title="Rules that Trigger Reflex Testing" format="st"/>
				<filter mask="OM1.37[1]" title="Patient Preparation" format="st"/>
				<filter mask="OM1.37[2]" title="Patient Preparation" format="st"/>
				<filter mask="OM1.39" title="Factors that may Affect the Observation" format="st"/>
				<filter mask="OM1.40[1]" title="Service/Test/Observation Performance Schedule" format="st"/>
				<filter mask="OM1.40[2]" title="Service/Test/Observation Performance Schedule" format="st"/>
				<filter mask="OM1.48" title="Exclusive Test" format="coded" table="0919"/>
				<filter mask="OM1.49" title="Diagnostic Service Sector ID" format="coded" table="0074"/>
				<filter mask="OM1.51[1]" title="Other Names" format="st"/>
				<filter mask="OM1.51[2]" title="Other Names" format="st"/>
				<filter mask="OM1.52[1]" title="Replacement Producer’s Service/Test/Observation ID" format="cwe" table="99USI_LN"/>
				<filter mask="OM1.52[2]" title="Replacement Producer’s Service/Test/Observation ID" format="cwe" table="99USI_LN"/>
				<filter mask="OM1.52[3]" title="Replacement Producer’s Service/Test/Observation ID" format="cwe" table="99USI_LN"/>
				<filter mask="OM1.52[4]" title="Replacement Producer’s Service/Test/Observation ID" format="cwe" table="99USI_LN"/>
				<filter mask="OM1.53[1]" title="Prior Resuts Instructions" format="st"/>
				<filter mask="OM1.53[2]" title="Prior Resuts Instructions" format="st"/>
				<filter mask="OM1.54[1]" title="Special Instructions" format="st"/>
				<filter mask="OM1.54[2]" title="Special Instructions" format="st"/>
				<filter mask="OM1.55[1]" title="Test Relationship Category Identifier" format="cwe"/>
				<filter mask="OM1.56[1]" title="Observation Identifier" format="cwe"/>
				<filter mask="OM1.57[1]" title="Expected Turn-Around Time" format="cq"/>
			</filters>
			<!-- <filters title="Numeric Observation Segment" group="OM2" scope="2">
		<filter mask="OM2.1" title="Sequence Number - Test/Observation Master File" format="st"/>
		<filter mask="OM2.2" title="Units of Measure" format="cwe" table="99USI_UCUM"/>
		<filter mask="OM2.6[1]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[2]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[3]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[4]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[5]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[6]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[7]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[8]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[9]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[10]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[11]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[12]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[13]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[14]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[15]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[16]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[17]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[18]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[19]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[20]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>		
		<filter mask="OM2.6[21]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[22]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[23]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[24]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[25]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[26]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[27]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[28]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[29]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[30]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>		
		<filter mask="OM2.6[31]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[32]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[33]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>	
		<filter mask="OM2.6[34]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[35]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.6[36]" title="Reference (Normal) Range for Ordinal and Continuous Observations" format="rfr"/>			
		<filter mask="OM2.7[1]" title="Critical Range for Ordinal and Continuous Observations" format="rfr"/>
		<filter mask="OM2.8[1]" title="Absolute Range for Ordinal and Continuous Observations" format="rfr"/>
	</filters> -->
			<filters title="Categorical Service/Test/Observation Segment" group="OM3" scope="2">
				<!-- set by IG/HL7 -->
				<filter mask="OM3.1" title="Sequence Number - Test/Observation Master File" format="st"/>
				<filter mask="OM3.4[1]" title="Normal Text/Codes for Categorical Observations [1]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.4[2]" title="Normal Text/Codes for Categorical Observations [2]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.4[3]" title="Normal Text/Codes for Categorical Observations [3]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.4[4]" title="Normal Text/Codes for Categorical Observations [4]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.4[5]" title="Normal Text/Codes for Categorical Observations [5]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.4[6]" title="Normal Text/Codes for Categorical Observations [6]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[1]" title="Abnormal Text/Codes for Categorical Observations [1]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[2]" title="Abnormal Text/Codes for Categorical Observations [2]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[3]" title="Abnormal Text/Codes for Categorical Observations [3]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[4]" title="Abnormal Text/Codes for Categorical Observations [4]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[5]" title="Abnormal Text/Codes for Categorical Observations [5]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[6]" title="Abnormal Text/Codes for Categorical Observations [6]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[7]" title="Abnormal Text/Codes for Categorical Observations [7]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[8]" title="Abnormal Text/Codes for Categorical Observations [8]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[9]" title="Abnormal Text/Codes for Categorical Observations [9]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[10]" title="Abnormal Text/Codes for Categorical Observations [10]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.5[11]" title="Abnormal Text/Codes for Categorical Observations [11]" format="cwe" table="99USI_SCT"/>
				<filter mask="OM3.7" title="Value Type" format="coded" table="0125"/>
			</filters>
			<filters title="Observations that Require Specimens" group="OM4" scope="2:3">
				<!-- set by IG/HL7 -->
				<!-- there might be a reference to that value in another OM4 segment (OM4-17) - so nneds to be present -->
				<filter mask="OM4.1" title="Sequence Number - Test/Observation Master File" format="st"/>
				<filter mask="OM4.3[1]" title="Container Description" format="st"/>
				<filter mask="OM4.3[2]" title="Container Description" format="st"/>
				<filter mask="OM4.4[1]" title="Container Volume" format="st"/>
				<filter mask="OM4.4[2]" title="Container Volume" format="st"/>
				<filter mask="OM4.5[1]" title="Container Units" format="cwe" table="UCUM"/>
				<filter mask="OM4.5[2]" title="Container Units" format="cwe" table="UCUM"/>
				<filter mask="OM4.6" title="Specimen" format="cwe" table="SCT_0874"/>
				<filter mask="OM4.7" title="Additive" format="cwe" table="0371"/>
				<filter mask="OM4.10" title="Normal Collection Volume" format="cq"/>
				<filter mask="OM4.11" title="Minimum Collection Volume" format="cq"/>
				<filter mask="OM4.12" title="Specimen Requirements" format="st"/>
				<filter mask="OM4.15[1]" title="Specimen Handling Code" format="cwe" table="0376"/>
				<filter mask="OM4.15[2]" title="Specimen Handling Code" format="cwe" table="0376"/>
				<filter mask="OM4.16" title="Specimen Preference" format="coded" table="0920"/>
				<!-- reference to another OM4 -->
				<filter mask="OM4.17" title="Preferred Specimen/Attribute Sequence ID" format="st"/>
			</filters>
			<filters title="Observation batteries" group="OM5" scope="3">
				<!-- set by IG/HL7 -->
				<!-- <filter mask="OM5.1" title="Sequence Number - Test/Observation Master File" format="st"/> -->
				<filter mask="OM5.2[1]" title="Test/Observations Included Within an Ordered Test Battery [1]" format="cwe"/>
				<filter mask="OM5.2[2]" title="Test/Observations Included Within an Ordered Test Battery [2]" format="cwe"/>
				<filter mask="OM5.2[3]" title="Test/Observations Included Within an Ordered Test Battery [3]" format="cwe"/>
				<filter mask="OM5.2[4]" title="Test/Observations Included Within an Ordered Test Battery [4]" format="cwe"/>
				<filter mask="OM5.2[5]" title="Test/Observations Included Within an Ordered Test Battery [5]" format="cwe"/>
				<filter mask="OM5.2[6]" title="Test/Observations Included Within an Ordered Test Battery [6]" format="cwe"/>
				<filter mask="OM5.2[7]" title="Test/Observations Included Within an Ordered Test Battery [7]" format="cwe"/>
				<filter mask="OM5.2[8]" title="Test/Observations Included Within an Ordered Test Battery [8]" format="cwe"/>
				<filter mask="OM5.2[9]" title="Test/Observations Included Within an Ordered Test Battery [9]" format="cwe"/>
				<filter mask="OM5.2[10]" title="Test/Observations Included Within an Ordered Test Battery [10]" format="cwe"/>
				<filter mask="OM5.2[11]" title="Test/Observations Included Within an Ordered Test Battery [11]" format="cwe"/>
				<filter mask="OM5.2[12]" title="Test/Observations Included Within an Ordered Test Battery [12]" format="cwe"/>
				<filter mask="OM5.2[13]" title="Test/Observations Included Within an Ordered Test Battery [13]" format="cwe"/>
				<filter mask="OM5.2[14]" title="Test/Observations Included Within an Ordered Test Battery [14]" format="cwe"/>
				<filter mask="OM5.2[15]" title="Test/Observations Included Within an Ordered Test Battery [15]" format="cwe"/>
				<filter mask="OM5.2[16]" title="Test/Observations Included Within an Ordered Test Battery [16]" format="cwe"/>
				<filter mask="OM5.2[17]" title="Test/Observations Included Within an Ordered Test Battery [17]" format="cwe"/>
				<filter mask="OM5.2[18]" title="Test/Observations Included Within an Ordered Test Battery [18]" format="cwe"/>
				<filter mask="OM5.2[19]" title="Test/Observations Included Within an Ordered Test Battery [19]" format="cwe"/>
				<filter mask="OM5.2[20]" title="Test/Observations Included Within an Ordered Test Battery [20]" format="cwe"/>
				<filter mask="OM5.2[21]" title="Test/Observations Included Within an Ordered Test Battery [21]" format="cwe"/>
				<filter mask="OM5.2[22]" title="Test/Observations Included Within an Ordered Test Battery [22]" format="cwe"/>
				<filter mask="OM5.2[23]" title="Test/Observations Included Within an Ordered Test Battery [23]" format="cwe"/>
				<filter mask="OM5.2[24]" title="Test/Observations Included Within an Ordered Test Battery [24]" format="cwe"/>
				<filter mask="OM5.2[25]" title="Test/Observations Included Within an Ordered Test Battery [25]" format="cwe"/>
				<filter mask="OM5.2[26]" title="Test/Observations Included Within an Ordered Test Battery [26]" format="cwe"/>
				<filter mask="OM5.2[27]" title="Test/Observations Included Within an Ordered Test Battery [27]" format="cwe"/>
				<filter mask="OM5.2[28]" title="Test/Observations Included Within an Ordered Test Battery [28]" format="cwe"/>
				<filter mask="OM5.2[29]" title="Test/Observations Included Within an Ordered Test Battery [29]" format="cwe"/>
				<filter mask="OM5.2[30]" title="Test/Observations Included Within an Ordered Test Battery [30]" format="cwe"/>
				<filter mask="OM5.2[31]" title="Test/Observations Included Within an Ordered Test Battery [31]" format="cwe"/>
				<filter mask="OM5.2[32]" title="Test/Observations Included Within an Ordered Test Battery [32]" format="cwe"/>
			</filters>
			<filters title="Charge description" group="CDM" scope="4">
				<!-- matches MFE-4 -->
				<!-- <filter mask="CDM.1" title="Primary Key Value" format="cwe"/> -->
				<filter mask="CDM.3" title="Charge Description Short" format="st"/>
				<filter mask="CDM.7[1]" title="Procedure Code [1]" format="cwe"/>
				<filter mask="CDM.7[2]" title="Procedure Code [2]" format="cwe"/>
				<filter mask="CDM.7[3]" title="Procedure Code [3]" format="cwe"/>
				<filter mask="CDM.7[4]" title="Procedure Code [4]" format="cwe"/>
				<filter mask="CDM.7[5]" title="Procedure Code [5]" format="cwe"/>
				<filter mask="CDM.7[6]" title="Procedure Code [6]" format="cwe"/>
			</filters>
			<filters title="Notes" group="NTE" scope="1:4">
				<filter mask="NTE.1" title="Set id" format="st"/>
				<filter mask="NTE.3[1]" title="Comment" format="st"/>
			</filters>
		</filter-groups>
	</xsl:variable>
	<xsl:template match="/">
		<html>
			<head>
				<style type="text/css">
                      @media screen {
                    maskByMediaType {display:table;}
                    fieldset table tbody tr th {font-size:90%}
                    fieldset table tbody tr td {font-size:90%;}
                    fieldset table tbody tr th {text-align:left;background:#C6DEFF}
                    fieldset table thead tr th {text-align:center;}
                    fieldset table thead tr th:first-child {width:50%;}
                    fieldset table thead tr th:last-child {width:50%;}
                    fieldset {text-align:center;}
		    		fieldset table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;border-collapse: collapse;}
                    fieldset table  tr { border: 3px groove; }
                    fieldset table  th { border: 2px groove;}
                    fieldset table  td { border: 2px groove; }
                    fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;}
                    fieldset table tbody tr td {text-align:left}
                    }
                     @media print {
                    maskByMediaType {display:table;}
                    fieldset table tbody tr th {font-size:90%}
                    fieldset table tbody tr td {font-size:90%;}
                    fieldset table tbody tr th {text-align:left;background:#C6DEFF}
                    fieldset table thead tr th {text-align:center;}
                    fieldset table thead tr th:first-child {width:50%;}
                   	fieldset table thead tr th:last-child {width:50%;}
		    		fieldset {text-align:center;}
 		    		fieldset table { width:98%;border: 1px groove;table-layout: fixed; margin:0 auto;border-collapse: collapse;}
   		   			fieldset table  tr { border: 3px groove;}
               		fieldset table  th { border: 2px groove;}
              		fieldset table  td { border: 2px groove;}
              		fieldset table thead {border: 1px groove;background:#446BEC;text-align:left;}
                    fieldset table tbody tr td {text-align:left}
                    }
				</style>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="event-profiles">
		<xsl:variable name="mask" select="fn:concat(':',$typeToMask/filterMasks/filterMask[@msgType=$msgType]/@mask,':')"/>
		<xsl:variable name="scope" select="fn:concat(':',$filterGroup,':')"/>
		<xsl:choose>
			<xsl:when test="$filterGroup ='FULL'">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="fn:contains($mask,$scope)">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				This tab is intentionally left blank because this test case does not include this kind of data.
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="test-message">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="segment[@id='MFI']">
		<xsl:variable name="segmentName" select="@id"/>
		<xsl:variable name="segmentId" select="@test-profile"/>
		<!-- get the template -->
		<xsl:variable name="tableTemplate" select="$dataSheetSeg/filter-groups/filters[@group=$segmentName]"/>
		<!-- get the data -->
		<xsl:variable name="segment" select="/event-profiles//test-profile[@segment=$segmentName and @id=$segmentId]"/>
		<!-- can display ? -->
		<xsl:variable name="display">
			<xsl:call-template name="canDisplay">
				<xsl:with-param name="segmentScope" select="$tableTemplate/@scope"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="count($tableTemplate) &gt; 0 and $display = 'true'">
			<fieldset>
				<legend>
					<xsl:value-of select="$tableTemplate/@title"/>
				</legend>
				<xsl:call-template name="processSegment">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="tableTemplate" select="$tableTemplate"/>
				</xsl:call-template>
			</fieldset>
			<!-- process the immediate following NTE -->
			<xsl:for-each select="following-sibling::segment[@id='NTE' and not(preceding-sibling::segment[@id='MFE'])]">
				<xsl:variable name="segmentName" select="@id"/>
				<xsl:variable name="segmentId" select="@test-profile"/>
				<xsl:variable name="tableTemplate" select="$dataSheetSeg/filter-groups/filters[@group='NTE']"/>
				<xsl:variable name="segment" select="/event-profiles//test-profile[@segment=$segmentName and @id=$segmentId]"/>
				<fieldset>
					<legend>
						<xsl:value-of select="$tableTemplate/@title"/>
					</legend>
					<xsl:call-template name="processSegment">
						<xsl:with-param name="segment" select="$segment"/>
						<xsl:with-param name="tableTemplate" select="$tableTemplate"/>
					</xsl:call-template>
				</fieldset>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="segment[@id='MFE']">
		<xsl:variable name="segmentName" select="@id"/>
		<xsl:variable name="segmentId" select="@test-profile"/>
		<xsl:variable name="next" select="following-sibling::*[@id=$segmentName][1]"/>
		<xsl:variable name="siblings1" select="following-sibling::segment intersect $next/preceding-sibling::segment"/>
		<xsl:variable name="siblings2" select="following-sibling::segment"/>
		<xsl:variable name="tableTemplate" select="$dataSheetSeg/filter-groups/filters[@group=$segmentName]"/>
		<!-- get the data -->
		<xsl:variable name="segment" select="/event-profiles//test-profile[@segment=$segmentName and @id=$segmentId]"/>
		<xsl:choose>
			<xsl:when test="count($siblings1) &gt; 0">
				<xsl:call-template name="processAsGroup">
					<xsl:with-param name="parent" select="$segment"/>
					<xsl:with-param name="children" select="$siblings1"/>
					<xsl:with-param name="parentTemplate" select="$tableTemplate"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="count($siblings2) &gt; 0">
				<xsl:call-template name="processAsGroup">
					<xsl:with-param name="parent" select="$segment"/>
					<xsl:with-param name="children" select="$siblings2"/>
					<xsl:with-param name="parentTemplate" select="$tableTemplate"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="processAsGroup">
		<xsl:param name="parent"/>
		<xsl:param name="children"/>
		<xsl:param name="parentTemplate"/>
		<!-- test if parent or one of the child is displayed -->
		<xsl:variable name="parentDisplay">
			<xsl:call-template name="canDisplay">
				<xsl:with-param name="segmentScope" select="$parentTemplate/@scope"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childrenDisplay">
			<xsl:call-template name="processChildren">
				<xsl:with-param name="children" select="$children"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="childDisplay" select="count($childrenDisplay/fieldset) &gt; 0"/>
		<xsl:if test="$parentDisplay = fn:boolean('true')">
			<fieldset>
				<legend>
					<xsl:variable name="groupTitle">
						<xsl:call-template name="groupTitle"/>
					</xsl:variable>
					<xsl:variable name="groupCount">
						<xsl:value-of select="fn:count(preceding-sibling::*[@id='MFE'])+1"/>
					</xsl:variable>
					<xsl:value-of select="fn:concat($groupTitle,' [',$groupCount,']')"/>
				</legend>
				<!-- MFE -->
				<!--				<xsl:call-template name="processSegment">
					<xsl:with-param name="segment" select="$parent"/>
					<xsl:with-param name="tableTemplate" select="$parentTemplate"/>
				</xsl:call-template> 	-->
				<fieldset>
					<legend>
						<xsl:value-of select="$parentTemplate/@title"/>
					</legend>
					<xsl:call-template name="processSegment">
						<xsl:with-param name="segment" select="$parent"/>
						<xsl:with-param name="tableTemplate" select="$parentTemplate"/>
					</xsl:call-template>
				</fieldset>
				<!-- children -->
				<xsl:call-template name="processChildren">
					<xsl:with-param name="children" select="$children"/>
				</xsl:call-template>
			</fieldset>
		</xsl:if>
	</xsl:template>
	<xsl:template name="processChildren">
		<xsl:param name="children"/>
		<!-- children processing -->
		<xsl:for-each select="$children">
			<xsl:variable name="childName" select="@id"/>
			<xsl:variable name="childId" select="@test-profile"/>
			<xsl:variable name="childTableTemplate" select="$dataSheetSeg/filter-groups/filters[@group=$childName]"/>
			<xsl:variable name="childSegment" select="/event-profiles//test-profile[@segment=$childName and @id=$childId]"/>
			<!-- can display ? -->
			<xsl:variable name="display">
				<xsl:call-template name="canDisplay">
					<xsl:with-param name="segmentScope" select="$childTableTemplate/@scope"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$display = 'true'">
				<fieldset>
					<legend>
						<xsl:value-of select="$childTableTemplate/@title"/>
					</legend>
					<xsl:call-template name="processSegment">
						<xsl:with-param name="segment" select="$childSegment"/>
						<xsl:with-param name="tableTemplate" select="$childTableTemplate"/>
					</xsl:call-template>
				</fieldset>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="processSegment">
		<xsl:param name="segment"/>
		<xsl:param name="tableTemplate"/>
		<!-- process the segment-->
		<table>
			<thead>
				<tr>
					<th>Element name</th>
					<th>Data</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="$tableTemplate/filter">
					<xsl:call-template name="displayFilter">
						<xsl:with-param name="segment" select="$segment"/>
						<xsl:with-param name="filter" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="displayFilter">
		<xsl:param name="segment"/>
		<xsl:param name="filter"/>
		<!-- element has sub elements -->
		<xsl:variable name="subElements" select="count($filter/subfilter)"/>
		<xsl:if test="$subElements &gt; 0">
			<!-- sub section title-->
			<!-- TODO : check if there are values before writting title -->
			<xsl:variable name="value">
				<xsl:for-each select="$filter/subfilter">
					<xsl:call-template name="displayFilter">
						<xsl:with-param name="segment" select="$segment"/>
						<xsl:with-param name="filter" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:variable>
			<xsl:if test="$value!=''">
				<tr>
					<xsl:call-template name="populateTitle">
						<xsl:with-param name="title" select="@title"/>
					</xsl:call-template>
				</tr>
				<xsl:for-each select="$filter/subfilter">
					<xsl:call-template name="displayFilter">
						<xsl:with-param name="segment" select="$segment"/>
						<xsl:with-param name="filter" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
		<!-- element does not have sub elements -->
		<xsl:if test="$subElements = 0">
			<xsl:variable name="value">
				<xsl:call-template name="formatValue">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="format" select="$filter/@format"/>
					<xsl:with-param name="location" select="$filter/@mask"/>
					<xsl:with-param name="table" select="$filter/@table"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$value != ''">
				<tr>
					<xsl:choose>
						<xsl:when test="$filter/@mask,' ',$filter/@title!=''">
							<td>
								<!--						<xsl:value-of select="concat($filter/@mask,' ',$filter/@title)"/>					
-->
								<xsl:value-of select="$filter/@title"/>
							</td>
						</xsl:when>
					</xsl:choose>
					<td>
						<xsl:call-template name="formatValue">
							<xsl:with-param name="segment" select="$segment"/>
							<xsl:with-param name="format" select="$filter/@format"/>
							<xsl:with-param name="location" select="$filter/@mask"/>
							<xsl:with-param name="table" select="$filter/@table"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="formatValue">
		<xsl:param name="segment"/>
		<xsl:param name="format"/>
		<xsl:param name="location"/>
		<xsl:param name="table"/>
		<xsl:choose>
			<xsl:when test="$format='st'">
				<xsl:value-of select="$segment/element[@location=$location]/@data"/>
			</xsl:when>
			<xsl:when test="$format='cwe'">
				<xsl:call-template name="format_cwe">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="location" select="$location"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$format='coded'">
				<xsl:call-template name="format_coded">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="location" select="$location"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$format='dtm'">
				<xsl:variable name="date" select="$segment/element[@location=$location]/@data"/>
				<xsl:if test="$date != ''">
					<xsl:call-template name="format_dtm">
						<xsl:with-param name="date" select="$date"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$format='cq'">
				<xsl:call-template name="format_cq">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="location" select="$location"/>
				</xsl:call-template>
			</xsl:when>
			<!-- no RFR for the moment-->
			<!--			<xsl:when test="$format='rfr'">
			</xsl:when>-->
			<xsl:when test="$format='xad'">
				<xsl:call-template name="format_xad">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="location" select="$location"/>
				</xsl:call-template>
			</xsl:when>
			<!-- <xsl:when test="$format='xpn'">
				<xsl:call-template name="format_xpn">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="location" select="$location"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$format='dtm'">
				<xsl:variable name="date" select="$segment/element[@location=$location]/@data"/>
				<xsl:if test="$date != ''">
					<xsl:call-template name="format_dtm">
						<xsl:with-param name="date" select="$date"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$format='xtn_ph'">
				<xsl:call-template name="format_xtn_ph">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="location" select="$location"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$format='xtn_em'">
				<xsl:call-template name="format_xtn_em">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="location" select="$location"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$format='xcn'">
				<xsl:call-template name="format_xcn">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="location" select="$location"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$format='varies_OBX'">
				<xsl:call-template name="format_varies_OBX">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="location" select="$location"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$format='coded_tx'">
				<xsl:call-template name="format_coded_tx">
					<xsl:with-param name="segment" select="$segment"/>
					<xsl:with-param name="location" select="$location"/>
				</xsl:call-template>
			</xsl:when> -->
		</xsl:choose>
	</xsl:template>
	<xsl:template name="format_cq">
		<xsl:param name="segment"/>
		<xsl:param name="location"/>
		<xsl:variable name="quantity" select="$segment/element[@location=concat($location,'.1')]/@data"/>
		<xsl:variable name="identifier" select="$segment/element[@location=concat($location,'.2.1')]/@data"/>
		<xsl:variable name="text" select="$segment/element[@location=concat($location,'.2.2')]/@data"/>
		<xsl:choose>
			<xsl:when test="$text != ''">
				<xsl:value-of select="concat($quantity,' ',$text)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$identifier != ''">
						<xsl:value-of select="concat($quantity,' ',$identifier)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="format_cwe">
		<xsl:param name="segment"/>
		<xsl:param name="location"/>
		<xsl:param name="table"/>
		<xsl:variable name="identifier" select="$segment/element[@location=concat($location,'.1')]/@data"/>
		<xsl:variable name="text" select="$segment/element[@location=concat($location,'.2')]/@data"/>
		<xsl:variable name="codeSystem" select="$segment/element[@location=concat($location,'.3')]/@data"/>
		<xsl:choose>
			<xsl:when test="$text != ''">
				<xsl:value-of select="$text"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$identifier != ''">
						<xsl:value-of select="concat($identifier,' ',$codeSystem)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="format_coded">
		<xsl:param name="segment"/>
		<xsl:param name="location"/>
		<xsl:param name="table"/>
		<xsl:variable name="value" select="$segment/element[@location=$location]/@data"/>
		<xsl:value-of select="$tables/table[@id=$table]/entry[@key=$value]"/>
	</xsl:template>
	<xsl:template name="format_coded_tx">
		<xsl:param name="segment"/>
		<xsl:param name="location"/>
		<xsl:param name="table"/>
		<xsl:variable name="value_2" select="$segment/element[@location=concat($location,'.2')]/@data"/>
		<xsl:variable name="value_5" select="$segment/element[@location=concat($location,'.5')]/@data"/>
		<xsl:variable name="value_9" select="$segment/element[@location=concat($location,'.9')]/@data"/>
		<xsl:choose>
			<xsl:when test="$value_9!=''">
				<xsl:value-of select="$value_9"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value_2"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="format_varies_OBX">
		<xsl:param name="segment"/>
		<xsl:param name="location"/>
		<xsl:variable name="datatype" select="$segment/element[@location=$location]/@data"/>
		<xsl:choose>
			<xsl:when test="$datatype='NM'">
				<xsl:value-of select="concat($segment/element[@location='OBX.5']/@data,' ',$segment/element[@location='OBX.6.2']/@data)"/>
			</xsl:when>
			<xsl:when test="$datatype='DT'">
				<xsl:call-template name="format_dtm">
					<xsl:with-param name="date" select="$segment/element[@location='OBX.5']/@data"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$datatype='CWE'">
				<xsl:value-of select="$segment/element[@location='OBX.5.2']/@data"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="format_xcn">
		<xsl:param name="segment"/>
		<xsl:param name="location"/>
		<xsl:variable name="Prefix">
			<xsl:value-of select="concat($segment/element[@location=concat($location,'.6')]/@data,' ')"/>
		</xsl:variable>
		<xsl:variable name="FamilyName">
			<xsl:value-of select="concat($segment/element[@location=concat($location,'.2.1')]/@data,' ')"/>
		</xsl:variable>
		<xsl:variable name="GivenName">
			<xsl:value-of select="concat($segment/element[@location=concat($location,'.3')]/@data,' ')"/>
		</xsl:variable>
		<xsl:variable name="SecondName">
			<xsl:value-of select="concat($segment/element[@location=concat($location,'.4')]/@data,' ')"/>
		</xsl:variable>
		<xsl:variable name="Suffix">
			<xsl:value-of select="concat($segment/element[@location=concat($location,'.5')]/@data,' ')"/>
		</xsl:variable>
		<xsl:value-of select="concat($Prefix, $GivenName,$SecondName,$FamilyName,$Suffix)"/>
	</xsl:template>
	<xsl:template name="format_xtn_em">
		<xsl:param name="segment"/>
		<xsl:param name="location"/>
		<xsl:value-of select="$segment/element[@location=concat($location,'.4')]/@data"/>
	</xsl:template>
	<xsl:template name="format_xtn_ph">
		<xsl:param name="segment"/>
		<xsl:param name="location"/>
		<xsl:variable name="areaCode" select="$segment/element[@location=concat($location,'.6')]/@data"/>
		<xsl:variable name="number" select="$segment/element[@location=concat($location,'.7')]/@data"/>
		<xsl:variable name="extension" select="$segment/element[@location=concat($location,'.8')]/@data"/>
		<xsl:variable name="areaCodeBis">
			<xsl:if test="$areaCode!=''">
				<xsl:value-of select="concat($areaCode,'-')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="tmp">
			<xsl:value-of select="concat($areaCodeBis,$number)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$extension!=''">
				<xsl:value-of select="concat($tmp,' ext ',$extension)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$tmp"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="format_dtm">
		<!--YYYYMMDDHHMM[SS[.S[S[S[S]]]]][+/-ZZZZ]-->
		<xsl:param name="date"/>
		<!-- extract timezone -->
		<xsl:variable name="dateTmp">
			<xsl:analyze-string select="$date" regex="(\d\d\d\d)(\d\d)?(\d\d)?(\d\d)?(\d\d)?(\d\d)?(\.\d\d?\d?\d?)?(.*)">
				<xsl:matching-substring>
					<xsl:variable name="year">
						<xsl:value-of select="regex-group(1)"/>
					</xsl:variable>
					<xsl:variable name="month">
						<xsl:value-of select="regex-group(2)"/>
					</xsl:variable>
					<xsl:variable name="day">
						<xsl:value-of select="regex-group(3)"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$day != ''">
							<xsl:value-of select="concat($year,'-',$month,'-',$day)"/>
						</xsl:when>
						<xsl:when test="$month != '' ">
							<xsl:value-of select="concat($year,'-',$month)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$year"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:matching-substring>
			</xsl:analyze-string>
		</xsl:variable>
		<xsl:variable name="time">
			<xsl:analyze-string select="$date" regex="(\d\d\d\d)(\d\d)?(\d\d)?(\d\d)?(\d\d)?(\d\d)?(\.\d\d?\d?\d?)?(.*)">
				<xsl:matching-substring>
					<xsl:variable name="hour">
						<xsl:value-of select="regex-group(4)"/>
					</xsl:variable>
					<xsl:variable name="minutes">
						<xsl:value-of select="regex-group(5)"/>
					</xsl:variable>
					<xsl:variable name="seconds">
						<xsl:value-of select="regex-group(6)"/>
					</xsl:variable>
					<xsl:variable name="milliseconds">
						<xsl:value-of select="regex-group(7)"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$milliseconds != ''">
							<xsl:call-template name="format_time">
								<xsl:with-param name="hours" select="$hour"/>
								<xsl:with-param name="minutes" select="concat(':',$minutes)"/>
								<xsl:with-param name="seconds" select="concat(':',$seconds)"/>
								<xsl:with-param name="milliseconds" select="$milliseconds"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$seconds != ''">
							<xsl:call-template name="format_time">
								<xsl:with-param name="hours" select="$hour"/>
								<xsl:with-param name="minutes" select="concat(':',$minutes)"/>
								<xsl:with-param name="seconds" select="concat(':',$seconds)"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$minutes != ''">
							<xsl:call-template name="format_time">
								<xsl:with-param name="hours" select="$hour"/>
								<xsl:with-param name="minutes" select="concat(':',$minutes)"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$hour != ''">
							<xsl:call-template name="format_time">
								<xsl:with-param name="hours" select="$hour"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:matching-substring>
			</xsl:analyze-string>
		</xsl:variable>
		<xsl:variable name="timezone">
			<xsl:analyze-string select="$date" regex="(\d\d\d\d)(\d\d)?(\d\d)?(\d\d)?(\d\d)?(\d\d)?(\.\d\d?\d?\d?)?(\\+|-\d\d)(\d\d)">
				<xsl:matching-substring>
					<xsl:value-of select="concat(regex-group(8),':',regex-group(9))"/>
				</xsl:matching-substring>
			</xsl:analyze-string>
		</xsl:variable>
		<!-- format date/time-->
		<xsl:variable name="dateTime">
			<xsl:choose>
				<xsl:when test="$time != ''">
					<xsl:value-of select="concat($dateTmp,' ',$time)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$dateTmp"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="dateTimeZone">
			<xsl:choose>
				<xsl:when test="$timezone != ''">
					<xsl:value-of select="concat($dateTime,' ',$timezone)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$dateTime"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$dateTimeZone"/>
	</xsl:template>
	<xsl:template name="format_time">
		<xsl:param name="hours"/>
		<xsl:param name="minutes"/>
		<xsl:param name="seconds"/>
		<xsl:param name="milliseconds"/>
		<xsl:variable name="am_pm">
			<xsl:choose>
				<xsl:when test="$hours &lt; 12">
					<xsl:value-of select="'am'"/>
				</xsl:when>
				<xsl:when test="$hours &gt; 11">
					<xsl:value-of select="'pm'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="time">
			<xsl:choose>
				<xsl:when test="$hours &gt; 12">
					<xsl:value-of select="$hours - 12"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$hours"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($time,$minutes,$seconds,$milliseconds,$am_pm)"/>
	</xsl:template>
	<xsl:template name="format_xpn">
		<xsl:param name="segment"/>
		<xsl:param name="location"/>
		<xsl:variable name="FamilyName">
			<xsl:if test="$segment/element[@location=concat($location,'.1.1')]/@data !=''">
				<xsl:value-of select="concat($segment/element[@location=concat($location,'.1.1')]/@data,' ')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="GivenName">
			<xsl:if test="$segment/element[@location=concat($location,'.2')]/@data !=''">
				<xsl:value-of select="concat($segment/element[@location=concat($location,'.2')]/@data,' ')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="SecondName">
			<xsl:if test="$segment/element[@location=concat($location,'.3')]/@data !=''">
				<xsl:value-of select="concat($segment/element[@location=concat($location,'.3')]/@data,' ')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="Suffix">
			<xsl:if test="$segment/element[@location=concat($location,'.4')]/@data !=''">
				<xsl:value-of select="concat($segment/element[@location=concat($location,'.4')]/@data,' ')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:value-of select="concat($GivenName,$SecondName,$FamilyName,$Suffix)"/>
	</xsl:template>
	<xsl:template name="format_xad">
		<xsl:param name="segment"/>
		<xsl:param name="location"/>
		<xsl:variable name="streetAddress" select="$segment/element[@location=concat($location,'.1.1')]/@data"/>
		<xsl:variable name="otherDesignation" select="$segment/element[@location=concat($location,'.2')]/@data"/>
		<xsl:variable name="city" select="$segment/element[@location=concat($location,'.3')]/@data"/>
		<xsl:variable name="state" select="$segment/element[@location=concat($location,'.4')]/@data"/>
		<xsl:variable name="zipcode" select="$segment/element[@location=concat($location,'.5')]/@data"/>
		<xsl:variable name="country" select="$segment/element[@location=concat($location,'.6')]/@data"/>
		<xsl:if test="$streetAddress != ''">
			<xsl:value-of select="$streetAddress"/>
			<br/>
		</xsl:if>
		<xsl:if test="$otherDesignation != ''">
			<xsl:value-of select="$otherDesignation"/>
			<br/>
		</xsl:if>
		<xsl:if test="concat($city,$state,$zipcode) != ''">
			<xsl:value-of select="concat($city,' ',$state,' ',$zipcode)"/>
			<br/>
		</xsl:if>
		<xsl:if test="$country != ''">
			<xsl:value-of select="$country"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="populateTitle">
		<xsl:param name="title"/>
		<th colspan="2">
			<xsl:value-of select="$title"/>
		</th>
	</xsl:template>
	<xsl:template name="canDisplay">
		<xsl:param name="segmentScope"/>
		<xsl:choose>
			<xsl:when test="$filterGroup ='FULL'">
				<!-- display ALL -->
				<xsl:value-of select="fn:true()"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- -->
				<xsl:choose>
					<!-- is filterGroup part of filterMask ?-->
					<xsl:when test="fn:contains(fn:concat(':',$filterMask,':'),fn:concat(':',$filterGroup,':'))">
						<!-- is filterGroup part of segment scope ? -->
						<xsl:choose>
							<xsl:when test="fn:contains(fn:concat(':',$segmentScope,':'),fn:concat(':',$filterGroup,':'))">
								<xsl:value-of select="fn:true()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="fn:false()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="fn:false()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="groupTitle">
		<xsl:choose>
			<xsl:when test="$msgType='M08'">Test information</xsl:when>
			<xsl:when test="$msgType='M10'">Battery information</xsl:when>
			<xsl:when test="$msgType='M04'">Charge description information</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
