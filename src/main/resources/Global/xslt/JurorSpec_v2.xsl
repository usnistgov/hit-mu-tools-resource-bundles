<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:util="http://hl7.nist.gov/juror-doc/util" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xhtml" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="condition"
        select="//MFE/MFE.1[contains(., 'MAD') or contains(., 'MUP') or contains(., 'MAC')]/../../OM1/OM1.12[. = 'Y']/.."/>
    <xsl:template name="commentTemplate">

        <td bgcolor="#F2F2F2">
            <!--    <div contentEditable="true"
                style="width: 100%; height: 100%; border: none; resize: none; max-width: 300px">
                <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;</div> -->
            <textarea maxLength="100"
                style="width: 100%; height: 100%; border: 1px; background: 1px  #F2F2F2; resize:vertical; overflow-y:hidden "> </textarea>

        </td>
    </xsl:template>

    <xsl:template name="headerTemp">
        <xsl:param name="colspan"/>
        <xsl:choose>
            <xsl:when test="../../..[@id = 'MFN_M08']">

                <thead>
                    <tr>
                        <th colspan="{$colspan}" width="60%">Atomic Test : <xsl:value-of
                                select="OM1.2/OM1.2.2"/></th>
                        <th width="40%">Tester Comment</th>
                    </tr>
                </thead>

            </xsl:when>
            <xsl:when test="../../..[@id = 'MFN_M10']">
                <thead>
                    <tr>
                        <th colspan="{$colspan}" width="60%">Panel : <xsl:value-of
                                select="OM1.2/OM1.2.2"/></th>
                        <th width="40%">Tester Comment</th>
                    </tr>
                </thead>

            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="util:format-date">
        <xsl:param name="elementDataIn"/>
        <xsl:variable name="elementData" select="concat($elementDataIn, '                ')"/>
        <xsl:if test="string-length(normalize-space($elementData)) > 0">
            <xsl:variable name="year" select="substring($elementData, 1, 4)"/>
            <xsl:variable name="month" select="concat(substring($elementData, 5, 2), '/')"/>
            <xsl:variable name="day" select="concat(substring($elementData, 7, 2), '/')"/>
            <xsl:value-of select="concat($month, $day, $year)"/>
            <!-- <xsl:value-of select="format-date(xs:date(concat($month,$day,$year)),'[D1o] 
				[MNn], [Y]', 'en', (), ())"/> -->
        </xsl:if>
    </xsl:function>
    <xsl:template name="specimen-tab">
        <xsl:param name="specimen"/>
        <xsl:param name="alt-specimen"/>
        <xsl:param name="noValue-specimen"/>
        <xsl:param name="specofM08orM10"/>
        <xsl:param name="spec"/>
        <xsl:choose>
            <xsl:when test="exists($specofM08orM10)">


                <xsl:for-each select="$specimen">

                    <tr>
                        <th colspan="3">Preferred Specimen Information</th>
                    </tr>

                    <xsl:apply-templates select="."/>
                    <xsl:if test="count($specimen) > 1">
                        <tr>
                            <td colspan="3">
							<!-- Caroline : change to &#160; -->
							<!-- <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp; -->
							<xsl:text>&#160;</xsl:text>
							</td>
                        </tr>
                    </xsl:if>
                    <xsl:variable name="spec" select="OM4.1"/>

                    <xsl:for-each select="$alt-specimen">
                        <xsl:if test="OM4.17 = $spec">
                            <tr>
                                <td colspan="3">
						<!-- Caroline : change to &#160; -->
							<!-- <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp; -->
							<xsl:text>&#160;</xsl:text>
								</td>
                            </tr>
                            <tr>
                                <th colspan="3">Alternate Specimen Information</th>
                            </tr>

                            <xsl:apply-templates select="."/>
                        </xsl:if>
                    </xsl:for-each>


                </xsl:for-each>

                <xsl:for-each select="$noValue-specimen">
                    <table>
                        <tbody>

                            <tr>
                                <th colspan="3"> Specimen Information</th>
                            </tr>
                            <xsl:apply-templates select="."/>

                        </tbody>
                    </table>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$spec">

                    <tr>
                        <th colspan="3"> Specimen Information</th>
                    </tr>
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="exists(following-sibling::OMC)">

            <xsl:for-each select="following-sibling::OMC">
                <tr>
                    <th colspan="3">Ask at Order Entries(AOE)</th>
                </tr>


                <tr id="noColor">
                    <th> Clinical Information Request </th>
                    <td>
                        <xsl:value-of select="OMC.4/OMC.4.2"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>

                <xsl:if test="exists(OMC.5)">
                    <tr id="noColor">
                        <th rowspan="{count(OMC.5)+1}">Collection Event/Process Step</th>
                        <td style="display:none"/>

                    </tr>
                    <xsl:for-each select="OMC.5">
                        <tr>
                            <td>
                                <xsl:value-of select="OMC.5.2"/>
                            </td>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                    </xsl:for-each>
                </xsl:if>


                <tr id="noColor">
                    <th>Communication Location</th>
                    <td>
                        <xsl:value-of select="OMC.6/OMC.6.2"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
                <tr id="noColor">
                    <th>Answer Required</th>
                    <td>
                        <xsl:value-of select="OMC.7"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
                <tr id="noColor">
                    <th>Hint/Help Text</th>
                    <td>
                        <xsl:value-of select="OMC.8"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>

                <xsl:if test="exists(OMC.11)">
                    <tr id="noColor">
                        <th rowspan="{count(OMC.11)+1}">Answer Choices</th>
                        <td style="display:none"/>

                    </tr>
                    <xsl:for-each select="OMC.11">
                        <tr>
                            <td>
                                <xsl:value-of select="OMC.11.2"/>
                            </td>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                    </xsl:for-each>
                </xsl:if>

            </xsl:for-each>

        </xsl:if>
    </xsl:template>

    <xsl:template name="dateTime">
        <xsl:param name="dateS"/>
        <xsl:variable name="dateformat"
            select="
                xs:dateTime(concat(
                substring($dateS, 1, 4), '-',
                substring($dateS, 5, 2), '-',
                substring($dateS, 7, 2), 'T',
                substring($dateS, 9, 2), ':',
                substring($dateS, 11, 2), ':',
                substring($dateS, 13, 2)
                ))"/>
        <xsl:value-of
            select="format-dateTime($dateformat, '[Y0001]/[M01]/[D01] at [H01]:[m01]:[s01]')"/>
    </xsl:template>
    <xsl:template name="testExistence">
        <xsl:param name="node"/>
        <xsl:choose>
            <xsl:when test="exists($node)">
                <td>
                    <xsl:value-of select="$node"/>
                </td>
            </xsl:when>
            <xsl:otherwise>
                <td bgcolor="#D2D2D2"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="CPOE">

        <xsl:if test="exists(OM1.37)">
            <tr id="noColor">
                <th rowspan="{count(OM1.37)+1}">Patient Preparation</th>
                <td style="display:none"/>
            </tr>

            <xsl:for-each select="OM1.37">
                <tr>
                    <td>
                        <xsl:value-of select="."/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
            </xsl:for-each>

        </xsl:if>



        <xsl:if test="exists(OM1.58)">
            <tr id="noColor">
                <th rowspan="{count(OM1.58)+1}">Gender Restrictions</th>
                <td style="display:none"/>
            </tr>
            <xsl:for-each select="OM1.58">
                <tr>
                    <td>
                        <xsl:value-of select="OM1.58.2"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="exists(OM1.59)">
            <tr id="noColor">
                <th rowspan="{count(OM1.59)+1}">Age Restrictions</th>
                <td style="display:none"/>
            </tr>
            <xsl:for-each select="OM1.59">
                <tr>
                    <td>
                        <xsl:value-of select="concat(OM1.59.1, 'to', OM1.59.2)"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="exists(OM1.52)">
            <tr id="noColor">
                <th rowspan="{count(OM1.52)+1}">Replacement Test</th>
                <td style="display:none"/>

            </tr>

            <xsl:for-each select="OM1.52">
                <tr>
                    <td>
                        <xsl:value-of select="OM1.52.2"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
            </xsl:for-each>
        </xsl:if>
        <xsl:if
            test="(exists(OM1.37) or exists(OM1.58) or exists(OM1.59) or exists(OM1.52)) and (exists(following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM5))">
            <tr>
                <td colspan="3">
						<!-- Caroline : change to &#160; -->
							<!-- <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp; -->
							<xsl:text>&#160;</xsl:text>
				</td>
            </tr>
        </xsl:if>
        <xsl:if test="exists(following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM5)">

            <xsl:for-each select="following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM5">
                <xsl:if test="position() = 1">
                    <th colspan="3">Panel Components</th>

                    <xsl:for-each select="OM5.2">
                        <tr>
                            <td colspan="2">
                                <xsl:value-of select="OM5.2.2"/>
                            </td>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="exists(OM1.34)">
            <tr>
                <td colspan="3">
						<!-- Caroline : change to &#160; -->
							<!-- <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp; -->
							<xsl:text>&#160;</xsl:text>
				</td>
            </tr>
            <th colspan="3">Reflex Information</th>
            <tr id="noColor">
                <th>Reflex Tests</th>
                <th>Trigger Rule</th>
                <th/>
            </tr>

            <xsl:for-each select="OM1.34">
                <xsl:variable name="pos" select="position()"/>
                <tr>

                    <xsl:copy-of select="util:formatData(OM1.34.2)"/>

                    <xsl:copy-of select="util:formatData(../OM1.35[$pos])"/>
                    <xsl:call-template name="commentTemplate"/>

                </tr>
            </xsl:for-each>

        </xsl:if>

    </xsl:template>
    <xsl:template match="OM4">

        <tr id="noColor">
            <th>Specimen</th>
            <xsl:copy-of select="util:formatData(OM4.6/OM4.6.2)"/>
            <xsl:call-template name="commentTemplate"/>

        </tr>

        <xsl:if test="exists(OM4.15)">
            <tr id="noColor">
                <th rowspan="{count(OM4.15)+1}">Specimen Handling Code</th>
                <td style="display:none"/>
            </tr>
            <xsl:for-each select="OM4.15">
                <tr>
                    <td>
                        <xsl:value-of select="OM4.15.2"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
            </xsl:for-each>
        </xsl:if>
        <tr id="noColor">
            <th>Minimum Collection Volume</th>

            <xsl:copy-of
                select="util:formatData(concat(OM4.11/OM4.11.1, ' ', OM4.11/OM4.11.2/OM4.11.2.2))"/>
            <xsl:call-template name="commentTemplate"/>
        </tr>
        <tr id="noColor">
            <th colspan="3">Container(s)</th>
        </tr>
        <xsl:for-each select="OM4.3">
            <tr>
                <td colspan="2">
                    <xsl:value-of select="."/>
                </td>
                <xsl:call-template name="commentTemplate"/>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="Admin">
        <xsl:if test="exists(OM1.2)">
            <tr>
                <th colspan="4">Global Information</th>
            </tr>
            <tr id="noColor">
                <th>Identifier assigned by lab </th>
                <th>Text</th>
                <th>Code System</th>
                <th/>
            </tr>
            <tr>
                <xsl:copy-of select="util:formatData(OM1.2/OM1.2.1)"/>
                <xsl:copy-of select="util:formatData(OM1.2/OM1.2.2)"/>
                <xsl:copy-of select="util:formatData(OM1.2/OM1.2.3)"/>
                <xsl:call-template name="commentTemplate"/>
            </tr>
        </xsl:if>
       <!--  <xsl:if test="exists(OM1.7)">
            <tr id="noColor">
                <th> Alternate Identifier </th>
                <th>Text</th>
                <th>Code System</th>
                <th/>
            </tr>
            <tr>
                <xsl:copy-of select="util:formatData(OM1.7/OM1.7.1)"/>
                <xsl:copy-of select="util:formatData(OM1.7/OM1.7.2)"/>
                <xsl:copy-of select="util:formatData(OM1.7/OM1.7.3)"/>
                <xsl:call-template name="commentTemplate"/>
            </tr>
        </xsl:if> -->
        
        <xsl:if test="exists(OM1.52)">

            <tr>
                <td colspan="4">
						<!-- Caroline : change to &#160; -->
							<!-- <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp; -->
							<xsl:text>&#160;</xsl:text>				</td>
            </tr>
            <tr>
                <th colspan="4">Replacement Test</th>
            </tr>
            <tr id="noColor">
                <th>Identifier</th>
                <th>Text</th>
                <th>Code System</th>
                <th/>
            </tr>
            <xsl:for-each select="OM1.52">
                <tr>
                    <xsl:copy-of select="util:formatData(OM1.52.1)"/>
                    <xsl:copy-of select="util:formatData(OM1.52.2)"/>
                    <xsl:copy-of select="util:formatData(OM1.52.3)"/>
                    <xsl:call-template name="commentTemplate"/>
                </tr>

            </xsl:for-each>
        </xsl:if>

        <xsl:if test="exists(following-sibling::OMC)">
            <tr>
                <td colspan="4">
						<!-- Caroline : change to &#160; -->
							<!-- <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp; -->
							<xsl:text>&#160;</xsl:text>				</td>
            </tr>
            <xsl:for-each select="following-sibling::OMC">
                <tr>
                    <th colspan="4">Ask at Order Entries(AOE)</th>
                </tr>
                <tr id="noColor">
                    <th>Clinical Information Request</th>
                    <td colspan="2">
                        <xsl:value-of select="OMC.4/OMC.4.2"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
                <tr id="noColor">
                    <th>Character Limit</th>
                    <td colspan="2">
                        <xsl:value-of select="OMC.12"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
                <tr id="noColor">
                    <th>Number of Decimals</th>
                    <td colspan="2">
                        <xsl:value-of select="OMC.13"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
            </xsl:for-each>
        </xsl:if>
        <xsl:variable name="cdm" select="OM1.2/OM1.2.1"/>

        <xsl:if test="exists(//CDM)">

            <xsl:for-each select="//CDM">
                <xsl:if test="$cdm = CDM.1/CDM.1.1">
                    <tr>
                        <td colspan="4">
						<!-- Caroline : change to &#160; -->
							<!-- <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp; -->
							<xsl:text>&#160;</xsl:text>						
						</td>
                    </tr>
                    <tr>
                        <th colspan="4">Charge Code Information</th>
                    </tr>
                    <xsl:for-each select="CDM.7">
                        <tr id="noColor">
                            <th>CPT4-code</th>
                            <td colspan="2">
                                <xsl:value-of select="CDM.7.1"/>
                            </td>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:function name="util:formatData">

        <xsl:param name="content"/>
        <xsl:variable name="formattedData">
            <!--   <xsl:choose>
                <xsl:when test="exists($content)">
                    <td>
                        <xsl:value-of select="$content"/>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <td class="noData"/>
                
                </xsl:otherwise>
            </xsl:choose> -->
            <xsl:choose>
                <xsl:when test="string-length(normalize-space($content)) = 0">
                    <td class="noData"/>
                </xsl:when>
                <xsl:otherwise>
                    <td>
                        <xsl:value-of select="$content"/>
                    </td>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select="$formattedData"/>
    </xsl:function>
    <xsl:function name="util:ID-text-format">
        <xsl:param name="ID"/>
        <xsl:param name="text"/>
        <xsl:param name="data"/>
        <xsl:param name="indent"/>
        <xsl:param name="font"/>
        <xsl:variable name="temp">
            <xsl:if test="exists($data)">
                <tr>
                    <th style="text-indent: {$indent}; font-weight:{$font}">
                        <xsl:value-of select="$ID"/>
                    </th>
                    <td>
                        <xsl:value-of select="$text"/>
                    </td>
                    <td>
                        <xsl:value-of select="$data"/>
                    </td>
                    <xsl:call-template name="commentTemplate"/>
                </tr>
            </xsl:if>
        </xsl:variable>
        <xsl:copy-of select="$temp"/>
    </xsl:function>
    <xsl:template name="generalInformation">

        <table>
            <thead>


                <tr>
                    <th colspan="4">General Information</th>
                </tr>
                <tr>
                    <th width="10%">Location</th>
                    <th width="20%">Data Element Name</th>
                    <th width="30%">Data</th>
                    <th width="40%">Tester Comment</th>
                </tr>
            </thead>
            <tbody>


                <xsl:if test="exists(OM1.2)">
                    <tr>
                        <th>OM1.2</th>
                        <th>Producer's Service/Test/Observation ID </th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.2.1', 'Identifier', OM1.2/OM1.2.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.2.2', 'Text', OM1.2/OM1.2.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.2.3', 'Name of Coding System', OM1.2/OM1.2.3, '20px', 'normal')"
                    />
                </xsl:if>
                <xsl:if test="exists(OM1.5)">
                    <tr>
                        <th>OM1.5</th>
                        <th>Producer ID </th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.5.1', 'Identifier', OM1.5/OM1.5.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.5.2', 'Text', OM1.5/OM1.5.2, '20px', 'normal')"
                    />
                </xsl:if>
                <xsl:if test="exists(OM1.7)">
                    <tr>
                        <th>OM1.7</th>
                        <th>Other Service/Test/Observation IDs for the Observation </th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.7.1', 'Identifier', OM1.7/OM1.7.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.7.2', 'Text', OM1.7/OM1.7.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.7.3', 'Name of Coding System', OM1.7/OM1.7.3, '20px', 'normal')"
                    />
                </xsl:if>
                <xsl:copy-of
                    select="util:ID-text-format('OM1.9', 'Preferred Report Name for the Observation', OM1.9, '0px', 'normal')"/>
                <xsl:copy-of
                    select="util:ID-text-format('OM1.10', 'Preferred Short Name on Mnemonic for Observation', OM1.10, '0px', 'normal')"/>
                <xsl:copy-of
                    select="util:ID-text-format('OM1.11', 'Preferred Long Name for the Observation', OM1.11, '0px', 'normal')"/>
                <xsl:for-each select="OM1.32">
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.32', 'Interpretation of Observations', ., '0px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:for-each select="OM1.33">
                    <tr>
                        <th>OM1.33</th>
                        <th>Contraindications to Observations </th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.33.1', 'Identifier', OM1.33.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.33.2', 'Text', OM1.33.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.33.3', 'Name of Coding System', OM1.33.3, '20px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:for-each select="OM1.34">
                    <tr>
                        <th>OM1.34</th>
                        <th>Reflex Tests/Observations </th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.34.1', 'Identifier', OM1.34.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.34.2', 'Text', OM1.34.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.34.3', 'Name of Coding System', OM1.34.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.34.4', ' Alternate Identifier', OM1.34.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.34.5', 'Alternate Text', OM1.34.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.34.6', 'Name of Alternate  Coding System', OM1.34.6, '20px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:for-each select="OM1.35">
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.35', 'Rules that Trigger Reflex Testing', ., '0px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:for-each select="OM1.37">
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.37', 'Patient Preparation', ., '0px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:copy-of
                    select="util:ID-text-format('OM1.39', 'Factors that may Affect the Observation', OM1.39, '0px', 'normal')"/>
                <xsl:for-each select="OM1.40">
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.40', 'Service/Test/Observation Performance Schedule', ., '0px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:copy-of
                    select="util:ID-text-format('OM1.48', 'Exclusive Test', OM1.48, '0px', 'normal')"/>
                <xsl:copy-of
                    select="util:ID-text-format('OM1.49', 'Diagnostic Service Sector ID', OM1.49, '0px', 'normal')"/>
                <xsl:for-each select="OM1.52">
                    <tr>
                        <th>OM1.52</th>
                        <th>Replacement Producer's Service/Test/Observation ID </th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.52.1', 'Identifier', OM1.52.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.52.2', 'Text', OM1.52.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.52.3', 'Name of Coding System', OM1.52.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.52.4', ' Alternate Identifier', OM1.52.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.52.5', 'Alternate Text', OM1.52.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.52.6', 'Name of Alternate  Coding System', OM1.52.6, '20px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:for-each select="OM1.53">
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.53', 'Prior Results Instructions', ., '0px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:for-each select="OM1.54">
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.54', 'Special Instructions', ., '0px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:for-each select="OM1.55">
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.55', 'Test Relationship Category', OM1.55.2, '0px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:for-each select="OM1.56">
                    <tr>
                        <th>OM1.56</th>
                        <th>Observation Identifier associated with Producer's
                            Service/Test/Observation ID</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.56.1', 'Identifier', OM1.56.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.56.2', 'Text', OM1.56.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.56.3', 'Name of Coding System', OM1.56.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.56.4', ' Alternate Identifier', OM1.56.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.56.5', 'Alternate Text', OM1.56.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.56.6', ' Name of Alternate Coding System', OM1.56.6, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.56.9', 'Original Text', OM1.56.9, '20px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:for-each select="OM1.57">
                    <tr>
                        <th>OM1.57</th>
                        <th>Expected Turn-Around Time</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.57.1', 'Quantity', OM1.57.1, '20px', 'normal')"/>
                    <tr>
                        <th style="text-indent:20px">OM1.57.2</th>
                        <th>Units</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.57.2.1', ' Identifier', OM1.57.2/OM1.57.2.1, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.57.2.2', 'Text', OM1.57.2/OM1.57.2.2, '30px', 'normal')"/>

                </xsl:for-each>
                <xsl:for-each select="OM1.58">
                    <tr>
                        <th>OM1.58</th>
                        <th>Gender Restriction</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.58.1', 'Identifier', OM1.58.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.58.2', 'Text', OM1.58.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.58.3', 'Name of Coding System', OM1.58.3, '20px', 'normal')"/>

                </xsl:for-each>
                <xsl:for-each select="OM1.59">
                    <tr>
                        <th>OM1.59</th>
                        <th>Age Restriction</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.59.1', 'Low Value', OM1.59.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM1.59.2', 'High Value', OM1.59.2, '20px', 'normal')"/>

                </xsl:for-each>
            </tbody>
        </table>

    </xsl:template>
    <xsl:template name="supporting-clinicalInfo">
        <table class="fourColumns">
            <thead>


                <tr>
                    <th colspan="4">Supporting Clinical Information</th>
                </tr>
                <tr>
                    <th width="10%">Location</th>
                    <th width="20%">Data Element Name</th>
                    <th width="30%">Data</th>
                    <th width="40%">Tester Comment</th>
                </tr>
            </thead>
            <tbody>


                <xsl:if test="exists(OMC.4)">
                    <tr>
                        <th>OMC.4</th>
                        <th>Clinical Information Request</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.4.1', 'Identifier', OMC.4/OMC.4.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.4.2', 'Text', OMC.4/OMC.4.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.4.3', 'Name of Coding System', OMC.4/OMC.4.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.4.4', ' Alternate Identifier', OMC.4/OMC.4.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.4.5', 'Alternate Text', OMC.4/OMC.4.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.4.6', 'Name of Alternate  Coding System', OMC.4/OMC.4.6, '20px', 'normal')"
                    />
                </xsl:if>
                <xsl:for-each select="OMC.5">
                    <tr>
                        <th>OMC.5</th>
                        <th>Collection Event/Process Step</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.5.1', 'Identifier', OMC.5.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.5.2', 'Text', OMC.5.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.5.3', 'Name of Coding System', OMC.5.3, '20px', 'normal')"/>

                </xsl:for-each>
                <xsl:if test="exists(OMC.6)">
                    <tr>
                        <th>OMC.6</th>
                        <th>Clinical Information Request</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.6.1', 'Identifier', OMC.6/OMC.6.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.6.2', 'Text', OMC.6/OMC.6.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OMC.6.3', 'Name of Coding System', OMC.6/OMC.6.3, '20px', 'normal')"
                    />
                </xsl:if>
                <xsl:copy-of
                    select="util:ID-text-format('OMC.7', 'Answer Required', OMC.7, '0px', 'normal')"/>
                <xsl:copy-of
                    select="util:ID-text-format('OMC.8', 'Hint/Help Text', OMC.8, '0px', 'normal')"/>
                <xsl:copy-of
                    select="util:ID-text-format('OMC.9', 'Type of Answer', OMC.9, '0px', 'normal')"/>
                <xsl:if test="exists(OMC.11)">
                    <xsl:for-each select="OMC.11">
                        <tr>
                            <th>OMC.11</th>
                            <th>Answer Choices</th>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OMC.11.1', 'Identifier', OMC.11.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OMC.11.2', 'Text', OMC.11.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OMC.11.3', 'Name of Coding System', OMC.11.3, '20px', 'normal')"
                        />
                    </xsl:for-each>
                </xsl:if>
                <xsl:copy-of
                    select="util:ID-text-format('OMC.12', 'Character Limit', OMC.12, '0px', 'normal')"/>
                <xsl:copy-of
                    select="util:ID-text-format('OMC.13', 'Number of Decimals', OMC.13, '0px', 'normal')"
                />
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="numeric-observationInfo">
        <table>
            <thead>


                <tr>
                    <th colspan="4"> Numeric Observation Information</th>
                </tr>
                <tr>
                    <th width="10%">Location</th>
                    <th width="20%">Data Element Name</th>
                    <th width="30%">Data</th>
                    <th width="40%">Tester Comment</th>
                </tr>
            </thead>
            <tbody>
                <xsl:if test="exists(OM2.2)">
                    <tr>
                        <th>OM2.2</th>
                        <th>Units of Measure</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM2.2.1', 'Identifier', OM2.2/OMC.2.2.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM2.2.2', 'Text', OM2.2/OM2.2.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM2.2.3', 'Name of Coding System', OM2.2/OM2.2.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM2.2.4', 'Alternate Identifier', OM2.2/OM2.2.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM2.2.5', 'Alternate Text', OM2.2/OM2.2.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM2.2.6', 'Name of Alternate Coding System', OM2.2/OM2.2.6, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM2.2.9', 'Original Text', OM2.2/OM2.2.9, '20px', 'normal')"
                    />
                </xsl:if>

                <xsl:for-each select="OM2.6">
                    <tr>
                        <th>OM2.6</th>
                        <th>Reference (Normal) Range for Ordinal and Continuous Observations</th>
                        <th/>
                        <th/>

                    </tr>
                    <xsl:if test="exists(OM2.6.1)">
                        <tr>
                            <th>OM2.6.1</th>
                            <th style="text-indent:10px">Numeric Range</th>
                            <th/>
                            <th/>

                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.6.1.1', 'Low Value', OM2.6.1/OM2.6.1.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.6.1.2', 'High Value', OM2.6.1/OM2.6.1.2, '20px', 'normal')"
                        />
                    </xsl:if>
                    <xsl:if test="exists(OM2.6.2)">
                        <tr>
                            <th>OM2.6.2</th>
                            <th style="text-indent:10px">Administrative Sex</th>
                            <th/>
                            <th/>

                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.6.2.1', 'Identifier', OM2.6.2/OM2.6.2.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.6.2.2', 'Text', OM2.6.2/OM2.6.2.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.6.2.3', 'Name of Coding System', OM2.6.2/OM2.6.2.3, '20px', 'normal')"
                        />
                    </xsl:if>
                    <xsl:if test="exists(OM2.6.6)">
                        <tr>
                            <th>OM2.6.6</th>
                            <th style="text-indent:10px">Race/Subspecies</th>
                            <th/>
                            <th/>

                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.6.6.1', 'Identifier', OM2.6.6/OM2.6.6.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.6.6.2', 'Text', OM2.6.6/OM2.6.6.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.6.6.3', 'Name of Coding System', OM2.6.6/OM2.6.6.3, '20px', 'normal')"
                        />
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="OM2.7">
                    <tr>
                        <th>OM2.7</th>
                        <th>Critical Range for Ordinal and Continuous Observations</th>
                        <th/>
                        <th/>

                    </tr>
                    <xsl:if test="exists(OM2.7.1)">
                        <tr>
                            <th>OM2.7.1</th>
                            <th style="text-indent:10px">Numeric Range</th>
                            <th/>
                            <th/>

                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.7.1.1', 'Low Value', OM2.7.1/OM2.7.1.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.7.1.2', 'High Value', OM2.7.1/OM2.7.1.2, '20px', 'normal')"
                        />
                    </xsl:if>
                    <xsl:if test="exists(OM2.7.2)">
                        <tr>
                            <th>OM2.7.2</th>
                            <th style="text-indent:10px">Administrative Sex</th>
                            <th/>
                            <th/>

                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.7.2.1', 'Identifier', OM2.7.2/OM2.7.2.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.7.2.2', 'Text', OM2.7.2/OM2.7.2.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.7.2.3', 'Name of Coding System', OM2.7.2/OM2.7.2.3, '20px', 'normal')"
                        />
                    </xsl:if>
                    <xsl:if test="exists(OM2.7.6)">
                        <tr>
                            <th>OM2.7.6</th>
                            <th style="text-indent:10px">Race/Subspecies</th>
                            <th/>
                            <th/>

                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.7.6.1', 'Identifier', OM2.7.6/OM2.7.6.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.7.6.2', 'Text', OM2.7.6/OM2.7.6.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.7.6.3', 'Name of Coding System', OM2.7.6/OM2.7.6.3, '20px', 'normal')"
                        />
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="OM2.8">
                    <tr>
                        <th>OM2.8</th>
                        <th>Absolute Range for Ordinal and Continuous Observations</th>
                        <th/>
                        <th/>

                    </tr>
                    <xsl:if test="exists(OM2.8.1)">
                        <tr>
                            <th>OM2.8.1</th>
                            <th style="text-indent:10px">Numeric Range</th>
                            <th/>
                            <th/>

                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.8.1.1', 'Low Value', OM2.8.1/OM2.8.1.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.8.1.2', 'High Value', OM2.8.1/OM2.8.1.2, '20px', 'normal')"
                        />
                    </xsl:if>
                    <xsl:if test="exists(OM2.8.2)">
                        <tr>
                            <th>OM2.8.2</th>
                            <th style="text-indent:10px">Administrative Sex</th>
                            <th/>
                            <th/>

                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.8.2.1', 'Identifier', OM2.8.2/OM2.8.2.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.8.2.2', 'Text', OM2.8.2/OM2.8.2.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.8.2.3', 'Name of Coding System', OM2.8.2/OM2.8.2.3, '20px', 'normal')"
                        />
                    </xsl:if>
                    <xsl:if test="exists(OM2.8.6)">
                        <tr>
                            <th>OM2.8.6</th>
                            <th style="text-indent:10px">Race/Subspecies</th>
                            <th/>
                            <th/>

                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.8.6.1', 'Identifier', OM2.8.6/OM2.8.6.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.8.6.2', 'Text', OM2.8.6/OM2.8.6.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OM2.7.6.3', 'Name of Coding System', OM2.8.6/OM2.8.6.3, '20px', 'normal')"
                        />
                    </xsl:if>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="categorial-testInfo">
        <table>
            <thead>

                <tr>
                    <th colspan="4">Categorial Test Information</th>
                </tr>
                <tr>
                    <th width="10%">Location</th>
                    <th width="20%">Data Element Name</th>
                    <th width="30%">Data</th>
                    <th width="40%">Tester Comment</th>
                </tr>
            </thead>
            <tbody>


                <xsl:for-each select="OM3.4">
                    <tr>
                        <th>OM3.4</th>
                        <th>Normal Text/Codes for Categorical Observations</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM3.4.1', 'Identifier', OM3.4.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM3.4.2', 'Text', OM3.4.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM3.4.3', 'Name of Coding System', OM3.4.3, '20px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:for-each select="OM3.5">
                    <tr>
                        <th>OM3.5</th>
                        <th>Abnormal Text/Codes for Categorical Observations</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM3.5.1', 'Identifier', OM3.5.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM3.5.2', 'Text', OM3.5.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM3.5.3', 'Name of Coding System', OM3.5.3, '20px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:copy-of
                    select="util:ID-text-format('OM3.7', 'Value Type', OM3.7, '0px', 'normal')"/>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="specimen-incorp">
        <table>
            <thead>

                <tr>
                    <th colspan="4">Specimen Information</th>
                </tr>
                <tr>
                    <th width="10%">Location</th>
                    <th width="20%">Data Element Name</th>
                    <th width="30%">Data</th>
                    <th width="40%">Tester Comment</th>
                </tr>
            </thead>
            <tbody>


                <xsl:for-each select="OM4.3">
                    <xsl:variable name="pos" select="position()"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.3', 'Container Description', ., '0px', 'normal')"/>

                    <xsl:copy-of
                        select="util:ID-text-format('OM4.4', 'Container Volume', ../OM4.4[$pos], '0px', 'normal')"/>

                    <tr>
                        <th>OM4.5</th>
                        <th>Container Units</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.5.2', 'Text', ../OM4.5[$pos]/OM4.5.2, '0px', 'normal')"
                    />
                </xsl:for-each>
                <xsl:if test="exists(OM4.6)">
                    <tr>
                        <th>OM4.6</th>
                        <th>Specimen</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.6.1', 'Identifier', OM4.6/OM4.6.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.6.2', 'Text', OM4.6/OM4.6.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.6.3', 'Name of Coding System', OM4.6/OM4.6.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.6.4', 'Alternate Identifer', OM4.6/OM4.6.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.6.5', 'Alternate Text', OM4.6/OM4.6.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.6.6', 'Name of Alternate Coding System', OM4.6/OM4.6.6, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.6.9', 'Original Text', OM4.6/OM4.6.9, '20px', 'normal')"
                    />
                </xsl:if>
                <xsl:if test="exists(OM4.7)">
                    <tr>
                        <th>OM4.7</th>
                        <th>Additive</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.7.2', 'Text', OM4.7/OM4.7.2, '20px', 'normal')"
                    />
                </xsl:if>
                <xsl:if test="exists(OM4.10)">
                    <tr>
                        <th>OM4.10</th>
                        <th>Normal Collection Volume</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.10.1', 'Quantity', OM4.10/OM4.10.1, '20px', 'normal')"/>
                    <tr>
                        <th style="text-indent:20px">OM4.10.2</th>
                        <th>Units</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM4.10.2.2', 'Text', OM4.10/OM4.10.2/OM4.10.2.2, '20px', 'normal')"
                    />
                </xsl:if>
            </tbody>
        </table>

    </xsl:template>
    <xsl:template name="observation-batteries">
        <table>
            <thead>

                <tr>
                    <th colspan="4">Observation Batteries(sets)</th>
                </tr>
                <tr>
                    <th width="10%">Location</th>
                    <th width="20%">Data Element Name</th>
                    <th width="30%">Data</th>
                    <th width="40%">Tester Comment</th>
                </tr>
            </thead>
            <tbody>


                <xsl:for-each select="OM5.2">
                    <tr>
                        <th>OM5.2</th>
                        <th>Test/Observations Included Within an Ordered Test Battery</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OM5.2.1', 'Identifier', OM5.2.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM5.2.2', 'Text', OM5.2.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OM5.2.3', 'Name of Coding System', OM5.2.3, '20px', 'normal')"
                    />
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="chargeDescription">
        <table>
            <thead>


                <tr>
                    <th colspan="4">Charge Description</th>
                </tr>
                <tr>
                    <th width="10%">Location</th>
                    <th width="20%">Data Element Name</th>
                    <th width="30%">Data</th>
                    <th width="40%">Tester Comment</th>
                </tr>
            </thead>
            <tbody>

                <xsl:copy-of
                    select="util:ID-text-format('CDM.3', 'Identifier', CDM.3, '0px', 'normal')"/>
                <xsl:for-each select="CDM.7">
                    <tr>
                        <th>CDM.7</th>
                        <th>Procedure Code</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('CDM.7.1', 'Identifier', CDM.7.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('CDM.7.2', 'Text', CDM.7.2, '20px', 'normal')"/>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="payerInfo">
        <table>
            <thead>

                <tr>
                    <th colspan="4">Payer Information</th>
                </tr>
                <tr>
                    <th width="10%">Location</th>
                    <th width="20%">Data Element Name</th>
                    <th width="30%">Data</th>
                    <th width="40%">Tester Comment</th>
                </tr>
            </thead>
            <tbody>


                <xsl:if test="exists(PM1.1)">
                    <tr>
                        <th>PM1.1</th>
                        <th>Health Plan ID</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('PM1.1.1', 'Identifier', PM1.1/PM1.1.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PM1.1.2', 'Text', PM1.1/PM1.1.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PM1.1.3', 'Name of Coding System', PM1.1/PM1.1.3, '20px', 'normal')"
                    />
                </xsl:if>
                <xsl:for-each select="PM1.2">
                    <tr>
                        <th>PM1.2</th>
                        <th>Insurance Company ID</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('PM1.2.1', 'ID Number', PM1.2.1, '20px', 'normal')"/>
                    <tr>
                        <th>PM1.2.4</th>
                        <th>Assiging Authority</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('PM1.2.4.1', 'Namespace ID', PM1.2.4/PM1.2.4.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PM1.2.4.2', 'Universal ID', PM1.2.4/PM1.2.4.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PM1.2.4.3', 'Universal ID Type', PM1.2.4/PM1.2.4.3, '20px', 'normal')"
                    />
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
    <xsl:template name="coveragePolicy">
        <table>
            <thead>


                <tr>
                    <th colspan="4">Coverage Policy</th>
                </tr>
                <tr>
                    <th width="10%">Location</th>
                    <th width="20%">Data Element Name</th>
                    <th width="30%">Data</th>
                    <th width="40%">Tester Comment</th>
                </tr>
            </thead>
            <tbody>


                <xsl:if test="exists(MCP.3)">
                    <tr>
                        <th>MCP.3</th>
                        <th>Universal Service Price Range – Low Value</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('MCP.3.1', 'Quantity', MCP.3/MCP.3.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('MCP.3.2', 'Denomination', MCP.3/MCP.3.2, '20px', 'normal')"
                    />
                </xsl:if>
                <xsl:if test="exists(MCP.4)">
                    <tr>
                        <th>MCP.4</th>
                        <th>Universal Service Price Range – High Value</th>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('MCP.4.1', 'Quantity', MCP.4/MCP.4.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('MCP.4.2', 'Denomination', MCP.4/MCP.4.2, '20px', 'normal')"
                    />
                </xsl:if>
                <xsl:copy-of
                    select="util:ID-text-format('MCP.5', 'Reason for Universal Service Cost Range', MCP.5, '  0px', 'normal')"
                />
            </tbody>
        </table>
    </xsl:template>
    <xsl:template match="/">

        <html>
            <head>

                <style type="text/css">
                    @media screen {
                    div[id='jurorContainer'] fieldset {font-size:100%;}
                    div[id='jurorContainer'] fieldset table tbody tr th {font-size:90%}
                    div[id='jurorContainer'] fieldset table tbody tr td {font-size:90%;}
                    }
                    @media print{div[id='jurorContainer'] fieldset {font-size:small; overflow: visible !important;}  div[id='jurorContainer'] fieldset table  th { font-size:x-small; }
                    div[id='jurorContainer'] fieldset table  td { font-size:xx-small }* [type=text]{
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
                    margin-left: 2%;
                    margin-right: 2%;
                    }
                    
                    @page :right {
                    margin-left: 2%;
                    margin-right: 2%;
                    }
                    
                    
                    * [type=text]{
                    width: 95%;
                    }
                    
                    div[id='jurorContainer'] fieldset {page-break-inside: avoid;}
                    div[id='jurorContainer'] fieldset table { width:98%;border: 1px groove; margin:0 auto;page-break-inside: avoid; }
                    div[id='jurorContainer'] fieldset table  tr { border: 1px groove; }
                    div[id='jurorContainer'] fieldset table  th { border: 1px groove; }
                    div[id='jurorContainer'] fieldset table  td { border: 1px groove;empty-cells: show; }
                    div[id='jurorContainer'] fieldset table[id = inspectionStatus] thead tr th:last-child {width:2%;}
                    div[id='jurorContainer'] fieldset table[id = inspectionStatus] thead tr th:nth-last-child(2) {width:2%;}
                    div[id='jurorContainer'] fieldset table[id = inspectionStatus] thead tr th:nth-last-child(3) {width:45%;}
                    div[id='jurorContainer'] fieldset table thead {border: 1px groove; font-weight:bold; font-size:large;background:#446BEC;text-align:left; color:black;}
                    div[id='jurorContainer'] fieldset table tbody tr th {text-align:left;background:#C6DEFF;}
                    div[id='jurorContainer'] fieldset table tbody tr[id=noColor] th {font-weight:bold;text-align:left;background:none;}
                    div[id='jurorContainer'] fieldset table tr[id=header] th {text-align:left;background:#B0C4DE; color:black; } 
                   
                    div[id='jurorContainer'] fieldset table tbody tr td {text-align:left}
                    div[id='jurorContainer'] fieldset table tbody tr td [type=text]{text-align:left;margin-left:1%}
                    div[id='jurorContainer'] fieldset table caption {font-weight:bold;color:#0840F8;}
                    div[id='jurorContainer'] fieldset {width:98%;font-weight:bold;border:1px solid #446BEC;}
                    .embSpace {padding-left:25px;}
                    .noData {background:#B8B8B8;}
                   
                   
                </style>
                <!--  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"/>-->
                <script type="text/javascript">
           
                  
                    function comment(){
                    
                    $("textarea").on("keyup",function (){
                    var h=$(this);
                    h.height(10).height(h[0].scrollHeight);
                    });
                    
                    } 
                  <!--
                        function hideTable() {
                            $("table").each(function (i, v) {
                                if ($(this).find("tbody").html().trim().length === 0) {
                                    $(this).hide();
                                    $(this).nextUntil("table").remove();
                                }
                            })
                        }//--> 
                    if(typeof jQuery =='undefined') {
                    var headTag = document.getElementsByTagName("head")[0];
                    var jqTag = document.createElement('script');
                    jqTag.type = 'text/javascript';
                    jqTag.src = 'http://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js';
                    jqTag.onload = comment;
                      
                    headTag.appendChild(jqTag);
                    }
                    else {  
                    $(document).ready(function (){
                    
                    comment();
                   
                    
                    });
                    
                    }
                </script>

            </head>
            <body>
                <div id="jurorContainer">
                    <fieldset id="juror">
                        <h3>ELECTRONIC DIRECTORY OF SERVICE(eDOS)</h3>
                        <table id="headerTable">
                            <thead>
                                <tr>
                                    <th colspan="2">Electronic Directory Of Service (eDOS)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>Test Case ID</th>

                                    <td>
                                        <xsl:value-of select="TestCase/@id"/>
                                    </td>

                                </tr>

                                <tr>
                                    <th>Juror ID</th>
                                    <td>
                                        <input style="background: 1px  #E2E2E2;" type="text"
                                            maxlength="50"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Juror Name</th>
                                    <td>
                                        <input style="background: 1px  #E2E2E2;" type="text"
                                            maxlength="50"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>HIT System Tested</th>
                                    <td>
                                        <input style="background: 1px  #E2E2E2;" type="text"
                                            maxlength="50"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Inspection Date/Time</th>
                                    <td>
                                        <input style="background: 1px  #E2E2E2;" type="text"
                                            maxlength="50"/>
                                    </td>
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
                                    <th>Reason Failed</th>
                                    <td>
                                        <input style="background: 1px  #E2E2E2;" type="text"
                                            maxlength="50"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Juror Comments</th>
                                    <td>
                                        <input style="background: 1px  #E2E2E2;" type="text"
                                            maxlength="50"/>
                                    </td>
                                </tr>

                            </tbody>
                        </table>

                    </fieldset>
                    <br/>
                    <fieldset>
                        <h3>DISPLAY VERIFICATION : CPOE View</h3>

                        <xsl:if test="exists($condition)">
                            <table id="orderablePanel">
                                <thead>
                                    <tr>
                                        <th colspan="2" width="60%">Orderable Atomic Tests and /or
                                            Panels</th>
                                        <th width="40%">Tester Comment</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th>Laboratary Name</th>
                                        <th>Name of the Test/Panel*</th>
                                        <th/>
                                    </tr>
                                    <xsl:for-each select="$condition">
                                        <tr>


                                            <xsl:copy-of select="util:formatData(OM1.5/OM1.5.2)"/>

                                            <xsl:copy-of select="util:formatData(OM1.2/OM1.2.2)"/>
                                            <xsl:call-template name="commentTemplate"/>
                                        </tr>
                                    </xsl:for-each>

                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td style="font-weight:bold;" colspan="3">* equivalent name
                                            accepted </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </xsl:if>
                        <br/>
                        <xsl:if test="exists(//MFE/MFE.1[. = 'MDC'])">
                            <table id="orderablePanel">
                                <thead>
                                    <tr>
                                        <th colspan="2" width="60%">Deactivated Atomic Tests and /or
                                            Panels</th>
                                        <th width="40%">Tester Comment</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th>Laboratary Name</th>
                                        <th>Name of the Test/Panel*</th>
                                        <th/>
                                    </tr>
                                    <xsl:for-each select="//MFE/MFE.1[. = 'MDC']/../../OM1">
                                        <tr>


                                            <xsl:copy-of select="util:formatData(OM1.5/OM1.5.2)"/>

                                            <xsl:copy-of select="util:formatData(OM1.2/OM1.2.2)"/>
                                            <xsl:call-template name="commentTemplate"/>
                                        </tr>
                                    </xsl:for-each>

                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td style="font-weight:bold;" colspan="3">* equivalent name
                                            accepted </td>
                                    </tr>
                                </tfoot>
                            </table>
                            <br/>
                        </xsl:if>

                        <xsl:for-each select="$condition">

                            <xsl:variable name="CPOE">
                                <xsl:call-template name="CPOE"/>
                            </xsl:variable>
                            <xsl:if test="string-length($CPOE) != 0">
                                <table>
                                    <xsl:call-template name="headerTemp">
                                        <xsl:with-param name="colspan" select="2"/>
                                    </xsl:call-template>
                                    <tbody>

                                        <xsl:call-template name="CPOE"/>
                                    </tbody>
                                </table>
                                <br/>
                            </xsl:if>

                            <xsl:variable name="panel"
                                select="following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM5[1]/OM5.2/OM5.2.1"/>

                            <xsl:for-each select="//OM1.2/OM1.2.1[. = $panel]/../..">
                                <xsl:if test="OM1.12[. != 'Y']">

                                    <xsl:variable name="CPOE">
                                        <xsl:call-template name="CPOE"/>
                                    </xsl:variable>
                                    <xsl:if test="string-length($CPOE) != 0">
                                        <table>
                                            <thead>
                                                <tr id="header">
                                                  <th colspan="2" width="60%"> Panel Component
                                                  Details: <xsl:value-of select="OM1.2/OM1.2.2"
                                                  /></th>
                                                  <th width="40%">Tester Comment</th>
                                                </tr>
                                            </thead>
                                            <tbody>

                                                <xsl:call-template name="CPOE"/>
                                            </tbody>
                                        </table>
                                        <br/>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>

                        </xsl:for-each>


                    </fieldset>

                    <br/>

                    <xsl:if
                        test="(exists($condition/following-sibling::OM4)) or (exists($condition/following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM4))">
                        <fieldset>
                            <h3>DISPLAY VERIFICATION : Specimen Collection / AOE View</h3>
                            <xsl:for-each select="$condition">

                                <xsl:variable name="specimen">
                                    <xsl:call-template name="specimen-tab">
                                        <xsl:with-param name="specimen"
                                            select="following-sibling::OM4/OM4.16[. = 'P']/.."/>
                                        <xsl:with-param name="alt-specimen"
                                            select="following-sibling::OM4/OM4.16[. = 'A']/.."/>
                                        <xsl:with-param name="noValue-specimen"
                                            select="following-sibling::OM4/OM4.16[. = '']/.."/>
                                        <xsl:with-param name="spec" select="following-sibling::OM4"
                                        />
                                    </xsl:call-template>
                                </xsl:variable>

                                <xsl:choose>
                                    <xsl:when test="../../..[@id = 'MFN_M08']">
                                        <xsl:if test="string-length($specimen) != 0">
                                            <table>
                                                <thead>
                                                  <tr>
                                                  <th colspan="2" width="60%">Atomic Test :
                                                  <xsl:value-of select="OM1.2/OM1.2.2"/></th>
                                                  <th width="40%">Tester Comment</th>
                                                  </tr>
                                                </thead>

                                                <tbody>


                                                  <xsl:call-template name="specimen-tab">
                                                  <xsl:with-param name="specimen"
                                                  select="following-sibling::OM4/OM4.16[. = 'P']/.."/>
                                                  <xsl:with-param name="alt-specimen"
                                                  select="following-sibling::OM4/OM4.16[. = 'A']/.."/>
                                                  <xsl:with-param name="noValue-specimen"
                                                  select="following-sibling::OM4/OM4.16[. = '']/.."/>
                                                  <xsl:with-param name="specofM08orM10"
                                                  select="following-sibling::OM4/OM4.16"/>
                                                  <xsl:with-param name="spec"
                                                  select="following-sibling::OM4"/>
                                                  </xsl:call-template>

                                                  <br/>


                                                </tbody>
                                            </table>

                                        </xsl:if>
                                    </xsl:when>

                                    <xsl:when test="../../..[@id = 'MFN_M10']">
                                        <xsl:if
                                            test="exists(following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM4)">
                                            <br/>
                                            <table>
                                                <thead>
                                                  <tr>
                                                  <th colspan="2" width="60%">Panel : <xsl:value-of
                                                  select="OM1.2/OM1.2.2"/></th>
                                                  <th width="40%">Tester Comment</th>
                                                  </tr>
                                                </thead>
                                                <tbody>


                                                  <xsl:call-template name="specimen-tab">
                                                  <xsl:with-param name="specimen"
                                                  select="following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM4/OM4.16[. = 'P']/.."/>
                                                  <xsl:with-param name="alt-specimen"
                                                  select="following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM4/OM4.16[. = 'A']/.."/>
                                                  <xsl:with-param name="noValue-specimen"
                                                  select="following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM4/OM4.16[. = '']/.."/>
                                                  <xsl:with-param name="specofM08orM10"
                                                  select="following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM4/OM4.16"/>
                                                  <xsl:with-param name="spec"
                                                  select="following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM4"
                                                  />
                                                  </xsl:call-template>

                                                </tbody>
                                            </table>
                                            <br/>
                                        </xsl:if>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>

                        </fieldset>
                    </xsl:if>
                    <br/>
                    <xsl:if test="exists($condition)">
                        <fieldset>
                            <h3>DISPLAY VERIFICATION : Directory Admin View</h3>
                            <xsl:for-each select="$condition">
                                <xsl:variable name="Admin">
                                    <xsl:call-template name="Admin"/>
                                </xsl:variable>
                                <xsl:if test="string-length($Admin) != 0">
                                    <table>
                                        <xsl:call-template name="headerTemp">
                                            <xsl:with-param name="colspan" select="3"/>
                                        </xsl:call-template>
                                        <tbody>
                                            <xsl:call-template name="Admin"/>
                                        </tbody>
                                    </table>
                                </xsl:if>
                                <br/>
                                <xsl:variable name="panel"
                                    select="following-sibling::MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM5[1]/OM5.2/OM5.2.1"/>

                                <xsl:for-each select="//OM1.2/OM1.2.1[. = $panel]/../..">

                                    <xsl:if test="OM1.12[. != 'Y']">
                                        <xsl:variable name="Admin">
                                            <xsl:call-template name="Admin"/>
                                        </xsl:variable>
                                        <xsl:if test="string-length($Admin) != 0">
                                            <table>
                                                <thead>


                                                  <tr id="header">
                                                  <th colspan="3" width="60%">Panel Component
                                                  :<xsl:value-of select="OM1.2/OM1.2.2"/></th>
                                                  <th width="40%">Tester Comment</th>
                                                  </tr>
                                                </thead>
                                                <tbody>


                                                  <xsl:call-template name="Admin"/>
                                                </tbody>
                                            </table>
                                            <br/>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>

                            </xsl:for-each>

                        </fieldset>
                    </xsl:if>
                    <br/>

                    <fieldset>
                        <h3>INCORPORATE VERIFICATION</h3>
                        <xsl:variable name="incorp" select="distinct-values(//MFE/MFE.4/MFE.4.2)"/>
                        <xsl:for-each-group select="//MFE/.." group-by="MFE/MFE.4/MFE.4.2">

                            <h3>Incorporate Verification for <xsl:value-of
                                    select="current-grouping-key()"/></h3>
                            <table>
                                <thead>


                                    <tr>
                                        <th width="20%">Data Element Name</th>
                                        <th width="40%">Data</th>
                                        <th width="40%">Tester Comment</th>
                                    </tr>
                                </thead>
                                <tbody>

                                    <tr>
                                        <th>Test Name</th>
                                        <td>
                                            <xsl:value-of
                                                select="distinct-values(MFE/MFE.4/MFE.4.2)"/>
                                        </td>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                    <tr>
                                        <th>Test Identifier</th>
                                        <td>
                                            <xsl:value-of
                                                select="distinct-values(MFE/MFE.4/MFE.4.1)"/>
                                        </td>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                    <tr>
                                        <th>Test Identifier Code System</th>
                                        <td>
                                            <xsl:value-of
                                                select="distinct-values(MFE/MFE.4/MFE.4.3)"/>
                                        </td>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                    <tr>
                                        <th>Status</th>
                                        <xsl:choose>
                                            <xsl:when
                                                test="MFE/MFE.1[contains(., 'MAD') or contains(., 'MUP') or contains(., 'MAC')]">
                                                <td>Active</td>
                                            </xsl:when>
                                            <xsl:when test="MFE/MFE.1[. = 'MDC']">
                                                <td>Deactivated</td>
                                            </xsl:when>
                                        </xsl:choose>

                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                </tbody>
                            </table>
                            <br/>
                            <xsl:choose>

                                <xsl:when test="../..[@id = 'MFN_M08']/current-group()">
                                    <xsl:choose>

                                        <xsl:when
                                            test="MFE/MFE.1[contains(., 'MAD') or contains(., 'MUP') or contains(., 'MAC')]">
                                            <xsl:if test="exists(OM1)">
                                                <xsl:for-each select="OM1">

                                                  <xsl:call-template name="generalInformation"/>
                                                </xsl:for-each>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if test="exists(OMC)">
                                                <xsl:for-each select="OMC">
                                                  <xsl:call-template name="supporting-clinicalInfo"/>
                                                  <br/>
                                                </xsl:for-each>

                                            </xsl:if>
                                            <xsl:if test="exists(OM2)">
                                                <xsl:for-each select="OM2">
                                                  <xsl:call-template name="numeric-observationInfo"
                                                  />
                                                </xsl:for-each>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if test="exists(OM3)">
                                                <xsl:for-each select="OM3">
                                                  <xsl:call-template name="categorial-testInfo"/>
                                                </xsl:for-each>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if test="exists(OM4)">
                                                <xsl:for-each select="OM4">
                                                  <xsl:call-template name="specimen-incorp"/>
                                                  <br/>
                                                </xsl:for-each>

                                            </xsl:if>
                                            <xsl:if test="exists(current-group()/CDM)">
                                                <xsl:for-each select="current-group()/CDM">
                                                  <xsl:call-template name="chargeDescription"/>
                                                  <br/>
                                                </xsl:for-each>

                                            </xsl:if>
                                            <xsl:if
                                                test="exists(current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/PM1)">
                                                <xsl:for-each
                                                  select="current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/PM1">
                                                  <br/>
                                                  <xsl:call-template name="payerInfo"/>
                                                </xsl:for-each>

                                            </xsl:if>
                                            <xsl:if
                                                test="exists(current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/MFN_M18.MF_PAYER.PAYER_MF_Entry.PAYER_MF_Coverage/MCP/MCP.3) or exists(current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/MFN_M18.MF_PAYER.PAYER_MF_Entry.PAYER_MF_Coverage/MCP/MCP.4) or exists(current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/MFN_M18.MF_PAYER.PAYER_MF_Entry.PAYER_MF_Coverage/MCP/MCP.5)">
                                                <xsl:for-each
                                                  select="current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/MFN_M18.MF_PAYER.PAYER_MF_Entry.PAYER_MF_Coverage/MCP">
                                                  <xsl:call-template name="coveragePolicy"/>
                                                  <br/>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="MFE/MFE.1[. = 'MDC']">
                                            <xsl:if test="exists(current-group()/CDM)">
                                                <xsl:for-each select="current-group()/CDM">
                                                  <xsl:call-template name="chargeDescription"/>
                                                  <br/>
                                                </xsl:for-each>

                                            </xsl:if>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="../..[@id = 'MFN_M10']/current-group()">
                                    <xsl:choose>

                                        <xsl:when
                                            test="MFE/MFE.1[contains(., 'MAD') or contains(., 'MUP') or contains(., 'MAC')]">
                                            <xsl:if test="exists(OM1)">
                                                <xsl:for-each select="OM1">
                                                  <xsl:call-template name="generalInformation"/>
                                                </xsl:for-each>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if
                                                test="exists(MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM5)">
                                                <xsl:for-each
                                                  select="MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM5">
                                                  <xsl:call-template name="observation-batteries"/>
                                                </xsl:for-each>
                                                <br/>
                                            </xsl:if>
                                            <xsl:if
                                                test="exists(MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM4)">
                                                <xsl:for-each
                                                  select="MFN_M10.MF_BATTERY.BATTERY_DETAIL/OM4">
                                                  <xsl:call-template name="specimen-incorp"/>
                                                  <br/>
                                                </xsl:for-each>

                                            </xsl:if>
                                            <xsl:if test="exists(current-group()/CDM)">
                                                <xsl:for-each select="current-group()/CDM">
                                                  <xsl:call-template name="chargeDescription"/>
                                                  <br/>
                                                </xsl:for-each>

                                            </xsl:if>
                                            <xsl:if
                                                test="exists(current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/PM1)">
                                                <xsl:for-each
                                                  select="current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/PM1">
                                                  <xsl:call-template name="payerInfo"/>
                                                  <br/>
                                                </xsl:for-each>

                                            </xsl:if>
                                            <xsl:if
                                                test="exists(current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/MFN_M18.MF_PAYER.PAYER_MF_Entry.PAYER_MF_Coverage/MCP/MCP.3) or exists(current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/MFN_M18.MF_PAYER.PAYER_MF_Entry.PAYER_MF_Coverage/MCP/MCP.4) or exists(current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/MFN_M18.MF_PAYER.PAYER_MF_Entry.PAYER_MF_Coverage/MCP/MCP.5)">
                                                <xsl:for-each
                                                  select="current-group()/MFN_M18.MF_PAYER.PAYER_MF_Entry/MFN_M18.MF_PAYER.PAYER_MF_Entry.PAYER_MF_Coverage/MCP">
                                                  <xsl:call-template name="coveragePolicy"/>
                                                  <br/>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </xsl:when>

                                        <xsl:when test="MFE/MFE.1[. = 'MDC']">
                                            <xsl:if test="exists(current-group()/CDM)">
                                                <xsl:for-each select="current-group()/CDM">
                                                  <xsl:call-template name="chargeDescription"/>
                                                  <br/>
                                                </xsl:for-each>

                                            </xsl:if>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="../..[@id = 'MFN_M04']/current-group()">
                                    <xsl:choose>

                                        <xsl:when
                                            test="MFE/MFE.1[contains(., 'MAD') or contains(., 'MUP') or contains(., 'MAC')]">
                                            <xsl:if test="exists(current-group()/CDM)">
                                                <xsl:for-each select="current-group()/CDM">
                                                  <xsl:call-template name="chargeDescription"/>
                                                  <br/>
                                                </xsl:for-each>

                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="MFE/MFE.1[. = 'MDC']">
                                            <xsl:if test="exists(current-group()/CDM)">
                                                <xsl:for-each select="current-group()/CDM">
                                                  <xsl:call-template name="chargeDescription"/>
                                                  <br/>
                                                </xsl:for-each>

                                            </xsl:if>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:when>

                            </xsl:choose>
                        </xsl:for-each-group>


                    </fieldset>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
