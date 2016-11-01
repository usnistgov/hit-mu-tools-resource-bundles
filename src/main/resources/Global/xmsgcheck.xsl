<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:util="http://www.nist.gov/jurordoc" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">
<xsl:param name="file1name" select="'file:///C:/Users/sna10/DEV/Source/xslt/nistmu2hl7xslt/trunk/er7/IZ-QR-1.1_Query_Q11_Z44.txt'"/>
<xsl:param name="file2name" select="'file:///C:/Users/sna10/DEV/Source/xslt/nistmu2hl7xslt/trunk/er7/IZ-QR-1.2_Response_K11_Z42.txt'"/>
<xsl:output method="text"/>

<xsl:param name="er7Message"/>
	<xsl:variable name="testCaseInterim" select="segments"/>
	<xsl:variable name="segmentSplitter" select="'&#xD;'"/>
	<xsl:variable name="fieldSplitter" select="'[|]'"/>
	<xsl:variable name="componentSplitter" select="'[\^]'"/>
	<xsl:variable name="fieldRepeatSplitter" select="'[~]'"/>
	<xsl:variable name="subComponentSplitter" select="'[&amp;]'"/>
	<xsl:variable name="er7Profile" select="HL7v2xConformanceProfile/HL7v2xStaticDef"/>
	<xsl:function name="util:isPassesFilter" as="xs:boolean">
		<xsl:param name="data"/>
		<xsl:param name="dataPath"/>
		<xsl:value-of select="true()"/>
	</xsl:function>
	<xsl:template name="parseER7Message">
		<xsl:param name="er7Message"/>
		<xsl:variable name="segmentList" select="tokenize($er7Message,$segmentSplitter)"/>
		<xsl:text></xsl:text>
		<ADT_A04>
			<xsl:for-each select="$segmentList">
				<xsl:choose>
					<xsl:when test="string-length(.) &gt; 0">
						<xsl:text></xsl:text>
							<xsl:call-template name="parseSegment">
								<xsl:with-param name="segmentData" select="."/>
								<xsl:with-param name="segmentStage" select="position()"/>
							</xsl:call-template>
						<xsl:text></xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
			<xsl:copy-of select="$testCaseInterim/messageProfile"/>
		</ADT_A04>
		<xsl:text></xsl:text>
	</xsl:template>
	<xsl:template name="parseSegment">
		<xsl:param name="segmentData"/>
		<xsl:param name="segmentStage"/>
		<xsl:variable name="segmentFields" select="tokenize($segmentData,$fieldSplitter)"/>
		<xsl:element name="{$segmentFields[1]}">
		<xsl:variable name="segmentProfile" as="node()*">
			<xsl:copy-of select="$er7Profile//Segment[@Name=$segmentFields[1]]"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="util:isPassesFilter(.,$segmentFields[1])">
				<xsl:call-template name="parseFields">
					<xsl:with-param name="fieldsList" select="$segmentFields"/>
					<xsl:with-param name="segmentIdentifier" select="$segmentFields[1]"/>
					<xsl:with-param name="isSegment" select="true()"/>
					<xsl:with-param name="segmentProfile" select="$segmentProfile"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template name="parseFields">
		<xsl:param name="fieldsList"/>
		<xsl:param name="segmentIdentifier"/>
		<xsl:param name="isSegment"/>
		<xsl:param name="fieldRepeatStage"/>
		<xsl:param name="segmentProfile" as="node()*"/>
		<xsl:choose>
			<xsl:when test="$isSegment and $segmentIdentifier='MSH'">
				<xsl:for-each select="$fieldsList">
					<xsl:choose>
						<xsl:when test="position() &gt; 2 and string-length(.) &gt; 0">
							<xsl:call-template name="parseField">
								<xsl:with-param name="fieldData" select="."/>
								<xsl:with-param name="fieldRepeatStage" select="$fieldRepeatStage"/>
								<xsl:with-param name="isSegment" select="false()"/>
								<xsl:with-param name="segmentIdentifier" select="$segmentIdentifier"/>
								<xsl:with-param name="segmentProfile" select="$segmentProfile"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$isSegment">
				<xsl:for-each select="$fieldsList[position() &gt; 1]">
					<xsl:if test="string-length(.) &gt; 0">
						<xsl:call-template name="parseField">
							<xsl:with-param name="fieldData" select="."/>
							<xsl:with-param name="fieldRepeatStage" select="$fieldRepeatStage"/>
							<xsl:with-param name="isSegment" select="false()"/>
							<xsl:with-param name="segmentIdentifier" select="$segmentIdentifier"/>
							<xsl:with-param name="segmentProfile" select="$segmentProfile"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$fieldsList">
					<xsl:if test="string-length(.) &gt; 0">
						<xsl:call-template name="parseField">
							<xsl:with-param name="fieldData" select="."/>
							<xsl:with-param name="fieldRepeatStage" select="$fieldRepeatStage"/>
							<xsl:with-param name="isSegment" select="false()"/>
							<xsl:with-param name="segmentIdentifier" select="$segmentIdentifier"/>
							<xsl:with-param name="segmentProfile" select="$segmentProfile"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="parseField">
		<xsl:param name="segmentIdentifier"/>
		<xsl:param name="isSegment"/>
		<xsl:param name="fieldRepeatStage"/>
		<xsl:param name="fieldData"/>
		<xsl:param name="segmentProfile" as="node()*"/>
		<xsl:variable name="segPath">
			<xsl:choose>
				<xsl:when test="$isSegment">
					<xsl:value-of select="concat($segmentIdentifier,'.',position())"/>
					
				</xsl:when>
				<xsl:when test="string-length($fieldRepeatStage) = 0">
					<xsl:value-of select="concat($segmentIdentifier,'.',position())"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($segmentIdentifier,'.',$fieldRepeatStage)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="currentFieldStage">
			<xsl:choose>
				<xsl:when test="string-length($fieldRepeatStage) &gt; 0">
					<xsl:value-of select="$fieldRepeatStage"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="position()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="fieldProfile" as="node()*">
			<xsl:choose>
				<xsl:when test="count($segmentProfile) &gt;1">
					<xsl:copy-of select="$segmentProfile[1]/Field[position()=$currentFieldStage]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$segmentProfile/Field[position()=$currentFieldStage]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="matches(.,$fieldRepeatSplitter)">
				<xsl:call-template name="parseFields">
					<xsl:with-param name="fieldsList" select="tokenize(.,$fieldRepeatSplitter)"/>
					<xsl:with-param name="segmentIdentifier" select="$segmentIdentifier"/>
					<xsl:with-param name="isSegment" select="false()"/>
					<xsl:with-param name="fieldRepeatStage" select="$currentFieldStage"/>
					<xsl:with-param name="segmentProfile" select="$segmentProfile"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
		<xsl:variable name="isFieldRepeated" select="matches(.,$fieldRepeatSplitter)"/>
		<xsl:choose>
			<xsl:when test="not($isFieldRepeated) and util:isPassesFilter(.,$segPath)">
			<xsl:text></xsl:text>
				<xsl:element name="{$segPath}">
					<xsl:choose>
						<xsl:when test="matches(.,$componentSplitter)">
							<xsl:call-template name="parseComponent">
								<xsl:with-param name="componentList" select="tokenize(.,$componentSplitter)"/>
								<xsl:with-param name="fieldStage" select="$currentFieldStage"/>
								<xsl:with-param name="segmentID" select="$segmentIdentifier"/>
								<xsl:with-param name="segmentPath" select="$segPath"/>
								<xsl:with-param name="fieldProfile" select="$fieldProfile"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="util:isPassesFilter(.,$segPath)">
							<xsl:value-of select="."/>
						</xsl:when>
					</xsl:choose>
				</xsl:element>
				<xsl:text></xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="parseComponent">
		<xsl:param name="componentList"/>
		<xsl:param name="fieldStage"/>
		<xsl:param name="segmentID"/>
		<xsl:param name="segmentPath"/>
		<xsl:param name="fieldProfile"/>
		<xsl:for-each select="$componentList">
			<xsl:variable name="compPath" select="concat($segmentPath,'.',position())"/>
			<xsl:variable name="currentComponentStage" select="position()"/>
			<xsl:choose>
				<xsl:when test="matches(.,$subComponentSplitter) and util:isPassesFilter(.,$compPath) and string-length(.) &gt; 0">
					<xsl:text></xsl:text>
					<xsl:element name="{$compPath}">
						<xsl:call-template name="parseSubComponent">
							<xsl:with-param name="subComponentList" select="tokenize(.,$subComponentSplitter)"/>
							<xsl:with-param name="componentStage" select="position()"/>
							<xsl:with-param name="segmentID" select="$segmentID"/>
							<xsl:with-param name="componentPath" select="$compPath"/>
							<xsl:with-param name="fieldStage" select="$fieldStage"/>
							<xsl:with-param name="fieldProfile" select="$fieldProfile"/>
						</xsl:call-template>
					</xsl:element> <xsl:text></xsl:text>
				</xsl:when>
				<xsl:when test="util:isPassesFilter(.,$compPath) and string-length(.) &gt; 0">
					<xsl:text></xsl:text>
					<xsl:element name="{$compPath}">
						<xsl:value-of select="."/>
					</xsl:element>
					<xsl:text></xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="parseSubComponent">
		<xsl:param name="subComponentList"/>
		<xsl:param name="componentStage"/>
		<xsl:param name="segmentID"/>
		<xsl:param name="componentPath"/>
		<xsl:param name="fieldStage"/>
		<xsl:param name="fieldProfile"/>
		<xsl:for-each select="$subComponentList">
			<xsl:variable name="subCompPath" select="concat($componentPath,'.',position())"/>
			<xsl:choose>
				<xsl:when test="util:isPassesFilter(.,$subCompPath) and string-length(.) &gt; 0">
					<xsl:element name="{$subCompPath}">
						<xsl:variable name="subCompStage" select="position()"/>
						<xsl:value-of select="."/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

<xsl:variable name="text-encoding" as="xs:string" select="'ISO-8859-1'"/>

<xsl:variable name="file1text" select="unparsed-text($file1name, $text-encoding)"/>
<xsl:variable name="file2text" select="unparsed-text($file2name, $text-encoding)"/>

<xsl:template match="/" priority="1000">

	<xsl:variable name="file1nodes" as="node()*">
		<xsl:call-template name="parseER7Message">
			<xsl:with-param name="er7Message" select="replace($file1text, '&#xA;', '&#xD;')"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="file2nodes" as="node()*">
		<xsl:call-template name="parseER7Message">
			<xsl:with-param name="er7Message" select="replace($file2text, '&#xA;', '&#xD;')"/>
		</xsl:call-template>
	</xsl:variable>
	
<xsl:variable name="config">
<check file1="MSH.3" file2="MSH.5"/>
<check file1="MSH.4" file2="MSH.6"/>
<check file1="MSH.5" file2="MSH.3"/>
<check file1="MSH.6" file2="MSH.4"/>
<check file1="MSH.10" file2="MSA.2"/>
<check file1="MSH.22" file2="MSH.23"/>
<check file1="MSH.23" file2="MSH.22"/>

<check file1="QPD.2" file2="QAK.1"/>
<check file1="QPD" file2="QPD"/>
<check file1="QPD.3.1" file2="PID.3.1"/>
<check file1="QPD.3.4" file2="PID.3.4"/>
<check file1="QPD.3.5" file2="PID.3.5"/>
<check file1="QPD.4.1" file2="PID.5.1"/>
<check file1="QPD.4.2" file2="PID.5.2"/>
<check file1="QPD.4.3" file2="PID.5.3"/>
<check file1="QPD.4.4" file2="PID.5.4"/>
<check file1="QPD.5.1" file2="PID.6.1"/>
<check file1="QPD.5.2" file2="PID.6.2"/>
<check file1="QPD.5.7" file2="PID.6.7"/>
<check file1="QPD.6" file2="PID.7"/>
<check file1="QPD.7" file2="PID.8"/>
<check file1="QPD.8.1" file2="PID.11.1"/>
<check file1="QPD.8.3" file2="PID.11.3"/>
<check file1="QPD.8.4" file2="PID.11.4"/>
<check file1="QPD.8.5" file2="PID.11.5"/>
<check file1="QPD.8.7" file2="PID.11.7"/>
<check file1="QPD.9.2" file2="PID.13.2"/>
<check file1="PQD.9.3" file2="PID.13.3"/>
<check file1="QPD.9.4" file2="PID.13.4"/>
<check file1="QPD.9.6" file2="PID.13.6"/>
<check file1="QPD.9.7" file2="PID.13.7"/>
<check file1="QPD.10" file2="PID.24"/>
<check file1="QPD.11" file2="PID.25"/>
<check file1="QPD.12" file2="PID.33"/>
<check file1="QPD.13" file2="PID.34"/>





</xsl:variable>

<xsl:for-each select="$config/check">
<xsl:variable name="file1field" select="@file1"/>
<xsl:variable name="file2field" select="@file2"/>

<xsl:choose>


	<xsl:when test="fn:compare(normalize-space(($file1nodes//*[name()=$file1field])[1]), normalize-space(($file2nodes//*[name()=$file2field])[1])) = 0">
	<xsl:text>Good</xsl:text> <xsl:value-of select="@file1"/> <xsl:text>= </xsl:text>
					<xsl:value-of select="@file2"/>
					<xsl:text>
	</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>Bad : file1</xsl:text> <xsl:value-of select="@file1"/> 
		<xsl:text>(</xsl:text>
					<xsl:value-of select="normalize-space(($file1nodes//*[name()=$file1field])[1])"/> <xsl:text>) 		not = </xsl:text>
					<xsl:value-of select="@file2"/>	<xsl:text>(</xsl:text>
					<xsl:value-of select="normalize-space(($file2nodes//*[name()=$file2field])[1])"/>
					<xsl:text>)	
		</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
</xsl:template>

<xsl:function name="util:first">
<xsl:param name="nset" as="node()*"/>

</xsl:function>
</xsl:stylesheet>