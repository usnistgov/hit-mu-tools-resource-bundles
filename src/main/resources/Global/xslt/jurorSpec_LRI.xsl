<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:util="http://www.nist.gov/er7"
    exclude-result-prefixes="xsl xs util fn xhtml">
    <xsl:output method="xhtml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:param name="segmentName"/>
    <xsl:param name="testCaseName"/>
    <xsl:template name="commentTemplate">
        <td bgcolor="#F2F2F2">
            <!--    <div contentEditable="true"
                style="width: 100%; height: 100%; border: none; resize: none; max-width: 300px">
                <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;</div> -->
            <textarea maxLength="100"
                style="width: 100%; height: 100%; border: 1px; background: 1px  #F2F2F2; resize:vertical; overflow-y:hidden "
                rows="1"> </textarea>

        </td>
    </xsl:template>
    <xsl:template name="jurorAppearance">
        <style type="text/css">
            @media screen{
                .jurorContainer fieldset{
                    font-size:100%;
                }
                .jurorContainer fieldset table tbody tr th{
                    font-size:90%
                }
                .jurorContainer fieldset table tbody tr td{
                    font-size:90%;
                }
            }
            @media print{
                .jurorContainer fieldset{
                    font-size:small;
                }
                .jurorContainer fieldset table th{
                    font-size:x-small;
                }
                .jurorContainer fieldset table td{
                    font-size:xx-small
                }
                * [type = text]{
                    width:98%;
                    height:15px;
                    margin:2px;
                    padding:0px;
                    background:1px #ccc;
                }
            
                .jurorContainer * [type = checkbox]{
                    width:10px;
                    height:10px;
                    margin:2px;
                    padding:0px;
                    background:1px #ccc;
                }
            }
            
            
            .jurorContainer * [type = text]{
                width:95%;
            }
            
            .jurorContainer fieldset{
                page-break-inside:avoid;
            }
            .jurorContainer fieldset table{
                width:98%;
                border:1px groove;
                margin:0 auto;
                page-break-inside:avoid;
            }
            .jurorContainer fieldset table tr{
                border:1px groove;
            }
            .jurorContainer fieldset table th{
                border:1px groove;
            }
            .jurorContainer fieldset table td{
                border:1px groove;
                empty-cells:show;
            }
            .jurorContainer fieldset table[id = inspectionStatus] thead tr th:last-child{
                width:2%;
                color:black;
            }
            .jurorContainer fieldset table[id = inspectionStatus] thead tr th:nth-last-child(2){
                width:2%;
                color:black;
            }
            .jurorContainer fieldset table[id = inspectionStatus] thead tr th:nth-last-child(3){
                width:45%;
            }
            .jurorContainer fieldset table thead{
                border:1px groove;
                background:#446BEC;
                text-align:center;
                color:white;
            }
            .jurorContainer fieldset table thead tr td{
                text-align:left;
                color:black;
                background:white;
            }
            .jurorContainer fieldset table tbody tr th{
                text-align:left;
                background:#C6DEFF;
            }
            .jurorContainer fieldset table tbody tr td{
                text-align:left
            }
            .jurorContainer fieldset table tbody tr td [type = text]{
                text-align:left;
                margin-left:1%
            }
            .jurorContainer fieldset table caption{
                font-weight:bold;
                color:#0840F8;
            }
            .jurorContainer fieldset legend{
                font-weight:bold;
            }
            .jurorContainer fieldset pre{
                font-family:Times New Roman;
            }
            .jurorContainer fieldset{
                width:98%;
                border:1px solid #446BEC;
            }
            .embSpace{
                padding-left:25px;
            }
            .noData{
                background:#B8B8B8;
            }
            .boldItalic{
                font-style:italic;
                font-weight:bold;
            }
            .bold{
                font-weight:bold;
            }
            .normal{
                font-weight:normal;
            }</style>
        <script type="text/javascript">
            
            
            function comment(){
            
            $("textarea").on("keyup",function (){
            var h=$(this);
            h.height(20).height(h[0].scrollHeight);
            });
            
            } 
      
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
    </xsl:template>
  
    <xsl:function name="util:parseDate">
        <xsl:param name="elementDataIn"/>
        <xsl:variable name="elementData" select="concat($elementDataIn, '                ')"/>
        <xsl:if test="string-length(normalize-space($elementData)) > 0">
            <xsl:variable name="year" select="substring($elementData, 1, 4)"/>
            <xsl:variable name="month" select="concat(substring($elementData, 5, 2), '/')"/>
            <xsl:variable name="day" select="concat(substring($elementData, 7, 2), '/')"/>
            <xsl:value-of select="concat($month, $day, $year)"/>

        </xsl:if>
    </xsl:function>
    <xsl:function name="util:dateTime">
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
            select="format-dateTime($dateformat, '[M01]/[D01]/[Y0001] at [H01]:[m01]:[s01]')"/>
    </xsl:function>
    <xsl:function name="util:formatDateTime">

        <xsl:param name="elementDataIn"/>
        <xsl:variable name="elementData" select="concat($elementDataIn, '                ')"/>
        <xsl:if test="string-length(normalize-space($elementData)) > 0">
            <xsl:variable name="year" select="substring($elementData, 1, 4)"/>
            <xsl:variable name="month" select="concat(substring($elementData, 5, 2), '/')"/>
            <xsl:variable name="day" select="concat(substring($elementData, 7, 2), '/')"/>
            <xsl:variable name="hours" select="concat(' ', substring($elementData, 9, 2))"/>
            <xsl:variable name="minutes" select="concat(':', substring($elementData, 11, 2))"/>
            <xsl:variable name="seconds" select="concat(':', substring($elementData, 13, 2))"/>

            <xsl:value-of select="concat($month, $day, $year, $hours, $minutes, $seconds)"/>

        </xsl:if>
    </xsl:function>
    <xsl:function name="util:formatData">
        <xsl:param name="content"/>
        <xsl:param name="class"/>
        <xsl:variable name="formattedData">
            <xsl:choose>
                <xsl:when test="string-length(normalize-space($content)) = 0">
                    <td class="noData"/>
                </xsl:when>
                <xsl:otherwise>
                    <td class="{$class}">
                        <xsl:value-of select="$content"/>
                    </td>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select="$formattedData"/>
    </xsl:function>
    <xsl:function name="util:displayCond">
        <xsl:param name="seg9"/>
        <xsl:param name="seg5"/>
        <xsl:param name="seg2"/>
        <xsl:choose>
            <xsl:when test="exists($seg9)">
                <xsl:copy-of select="util:formatData($seg9, 'bold')"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="exists($seg5)">
                        <xsl:copy-of select="util:formatData($seg5, 'boldItalic')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="util:formatData($seg2, 'boldItalic')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="util:ID-text-format">
        <xsl:param name="ID"/>
        <xsl:param name="text"/>
        <xsl:param name="storeReq"/>
        <xsl:param name="data"/>
        <xsl:param name="indent"/>
        <xsl:param name="font"/>
        <xsl:variable name="temp">
            <tr>
                <th style="text-indent: {$indent}; font-weight:{$font}">
                    <xsl:value-of select="$ID"/>
                </th>
                <td>
                    <xsl:value-of select="$text"/>
                </td>
                <td>
                    <xsl:value-of select="$storeReq"/>
                </td>
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space($data)) = 0">
                        <td class="noData"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <td>
                            <xsl:value-of select="$data"/>
                        </td>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:call-template name="commentTemplate"/>
            </tr>
        </xsl:variable>
        <xsl:copy-of select="$temp"/>
    </xsl:function>

    <xsl:template name="messageHeader">
        <xsl:param name="er7MsgId"/>
        <fieldset>
            <table id="headerTable">
                <thead>
                    <tr>
                        <th colspan="2">HL7 v2.5 ORU^R01^ORU_R01 Message: Incorporation of
                            Laboratory Results</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th>Test Case ID</th>
                        <td>
                            <xsl:value-of select="$er7MsgId"/>
                        </td>
                    </tr>

                    <tr>
                        <th>Juror ID</th>
                        <td>
                            <input style="background: 1px  #E2E2E2;" type="text" maxlength="50"
                                value=""/>
                        </td>
                    </tr>
                    <tr>
                        <th>Juror Name</th>
                        <td>
                            <input style="background: 1px  #E2E2E2;" type="text" maxlength="50"
                                value=""/>
                        </td>
                    </tr>
                    <tr>
                        <th>HIT System Tested</th>
                        <td>
                            <input style="background: 1px  #E2E2E2;" type="text" maxlength="50"
                                value=""/>
                        </td>
                    </tr>
                    <tr>
                        <th>Inspection Date/Time</th>
                        <td>
                            <input style="background: 1px  #E2E2E2;" type="text" maxlength="50"
                                value=""/>
                        </td>
                    </tr>
                    <tr>
                        <th>Inspection Settlement (Pass/Fail)</th>
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
                                            <input type="checkbox" value=""/>
                                        </td>
                                        <td>
                                            <input type="checkbox" value=""/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <th>Reason Failed</th>
                        <td>
                            <input style="background: 1px  #E2E2E2;" type="text" maxlength="50"
                                value=""/>
                        </td>
                    </tr>
                    <tr>
                        <th>Juror Comments</th>
                        <td>
                            <input style="background: 1px  #E2E2E2;" type="text" maxlength="50"
                                value=""/>
                        </td>
                    </tr>


                </tbody>
            </table>
        </fieldset>
    </xsl:template>
    <xsl:template name="patientInfo-DV">

        <xsl:param name="pidSegments" as="node()*"/>
        <xsl:for-each select="$pidSegments">
            <fieldset id="Patient.1.Table">
                <table id="patientInformationDisplay">
                    <thead>
                        <tr>
                            <th colspan="5">Patient Information - Display Verification</th>
                        </tr>
                        <tr>
                            <th>Patient Identifier</th>
                            <th>Patient Name</th>
                            <th>DOB</th>
                            <th>Sex</th>
                            <th>Tester Comment</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <xsl:copy-of select="util:formatData(PID.3/PID.3.1, 'boldItalic')"/>
                            <xsl:copy-of
                                select="util:formatData(concat(PID.5/PID.5.2, ' ', PID.5/PID.5.3, ' ', PID.5/PID.5.1/PID.5.1.1, ' ', PID.5/PID.5.4), 'boldItalic')"/>
                            <xsl:copy-of
                                select="util:formatData(util:parseDate(PID.7/PID.7.1), 'normal')"/>
                            <xsl:copy-of select="util:formatData(PID.8, 'normal')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="5">When a given patient has more than one Patient ID
                                Number, the HIT module may display the ID Number that is most
                                appropriate for the context (e.g., inpatient ID Number versus
                                ambulatory ID Number.) </td>
                        </tr>
                    </tfoot>
                </table>
            </fieldset>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="labResults-DV">
        <xsl:param name="obrSegment"/>
        <fieldset>
            <xsl:for-each select="$obrSegment">
                <table id="labResultsDisplay">
                    <thead>
                        <tr>
                            <th colspan="11">Lab Results - Display Verification</th>
                        </tr>
                        <tr>
                            <th width="15%">Test Performed:</th>
                            <xsl:choose>

                                <xsl:when test="exists($obrSegment/OBR.4/OBR.4.9)">
                                    <td colspan="10" width="75%" style="font-weight:bold">
                                        <xsl:value-of select="$obrSegment/OBR.4/OBR.4.9"/>
                                    </td>

                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="exists($obrSegment/OBR.4/OBR.4.5)">
                                            <td colspan="10" width="75%"
                                                style="font-style:italic;font-weight:bold;">
                                                <xsl:value-of select="$obrSegment/OBR.4/OBR.4.5"/>
                                            </td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td colspan="10" width="75%"
                                                style="font-style:italic;font-weight:bold;">
                                                <xsl:value-of select="$obrSegment/OBR.4/OBR.4.2"/>
                                            </td>
                                        </xsl:otherwise>
                                    </xsl:choose>


                                </xsl:otherwise>
                            </xsl:choose>

                        </tr>
                        <tr>
                            <th width="15%">Test Report Date:</th>
                            <td colspan="10" width="75%" style="font-weight:normal;">
                                <xsl:value-of
                                    select="util:formatDateTime($obrSegment/OBR.22/OBR.22.1)"/>
                            </td>

                        </tr>
                        <tr>
                            <th width="15%">Result Report Status</th>
                            <td colspan="10" width="75%" style="font-weight:normal;">
                                <xsl:value-of select="$obrSegment/OBR.25"/>
                            </td>

                        </tr>
                        <tr>
                            <th colspan="11">Result Report Status</th>
                        </tr>
                        <tr>
                            <td colspan="11">
   							<!-- Caroline : change to &#160; -->
                            <!-- <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;-->
                         <xsl:text>&#160;</xsl:text>       
						</td>
                        </tr>
                        <tr>
                            <th width="15%">Result Observation Name</th>
                            <th width="5%">Result Value</th>
                            <th width="5%">UOM</th>
                            <th width="7%">Reference Range</th>
                            <th width="7%">Abnormal Flag</th>
                            <th width="6%">Status</th>
                            <th width="15%">Date/Time of Observation</th>
                            <th width="15%">End Date/Time of Observation</th>
                            <th width="15%">Date/Time of Analysis</th>
                            <th width="20%">Tester Comment</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each
                            select="$obrSegment/following-sibling::ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.OBSERVATION/OBX">

                            <xsl:variable name="resultValue">
                                <xsl:choose>
                                    <xsl:when test="OBX.2 = 'NM'">
                                        <xsl:copy-of select="util:formatData(OBX.5, 'bold')"/>
                                    </xsl:when>
                                    <xsl:when test="OBX.2 = 'SN'">
                                        <xsl:copy-of
                                            select="util:formatData(concat(OBX.5/OBX.5.1, ' ', OBX.5/OBX.5.2, ' ', OBX.5/OBX.5.3, ' ', OBX.5/OBX.5.4), 'normal')"/>

                                    </xsl:when>
                                    <xsl:when test="OBX.2 = 'FT'">
                                        <xsl:copy-of select="util:formatData(OBX.5, 'bold')"/>
                                    </xsl:when>
                                    <xsl:when test="OBX.2 = 'ST'">
                                        <xsl:copy-of select="util:formatData(OBX.5, 'bold')"/>
                                    </xsl:when>
                                    <xsl:when test="OBX.2 = 'TX'">
                                        <xsl:copy-of select="util:formatData(OBX.5, 'bold')"/>
                                    </xsl:when>
                                    <xsl:when test="OBX.2 = 'DT'">
                                        <xsl:copy-of select="util:formatData(OBX.5, 'normal')"/>
                                    </xsl:when>
                                    <xsl:when test="OBX.2 = 'TS'">
                                        <xsl:copy-of select="util:formatData(OBX.5, 'normal')"/>
                                    </xsl:when>
                                    <xsl:when test="OBX.2 = 'TM'">
                                        <xsl:copy-of select="util:formatData(OBX.5, 'normal')"/>
                                    </xsl:when>
                                    <xsl:when test="OBX.2 = 'CWE'">
                                        <xsl:copy-of
                                            select="util:displayCond(OBX.5/OBX.5.9, OBX.5/OBX.5.5, OBX.5/OBX.5.2)"/>

                                    </xsl:when>
                                </xsl:choose>
                            </xsl:variable>
                            <tr>

                                <xsl:copy-of
                                    select="util:displayCond(OBX.3/OBX.3.9, OBX.3/OBX.3.5, OBX.3/OBX.3.2)"/>
                                <xsl:copy-of select="$resultValue"/>
                                <xsl:choose>
                                    <xsl:when test="exists(OBX.6/OBX.6.9)">
                                        <xsl:copy-of select="util:formatData(OBX.6/OBX.6.9, 'bold')"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of
                                            select="util:formatData(OBX.6/OBX.6.2, 'boldItalic')"/>
                                    </xsl:otherwise>
                                </xsl:choose>

                                <xsl:copy-of select="util:formatData(OBX.7, 'bold')"/>
                                <xsl:copy-of select="util:formatData(OBX.8, 'normal')"/>
                                <xsl:copy-of select="util:formatData(OBX.11, 'normal')"/>
                                <xsl:copy-of
                                    select="util:formatData(util:formatDateTime(../../OBR/OBR.7/OBR.7.1), 'normal')"/>
                                <xsl:copy-of
                                    select="util:formatData(util:formatDateTime(../../OBR/OBR.8/OBR.8.1), 'normal')"/>
                                <xsl:copy-of
                                    select="util:formatData(util:formatDateTime(OBX.19/OBX.19.1), 'normal')"/>
                                <xsl:call-template name="commentTemplate"/>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                    <xsl:if
                        test="$obrSegment/following-sibling::ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.OBSERVATION/OBX/OBX.2 = 'NM'">
                        <tfoot>
                            <tr>
                                <td colspan="10">For all numeric Result values that are less than 1,
                                    the displayed data must include a pre-decimal &quot;0&quot; and
                                    the decimal point (e.g., &quot;.5&quot; must be displayed as
                                    &quot;0.5&quot;. The displayed data cannot change the level of
                                    precision of a numeric Result value (e.g., &quot;6&quot; cannot
                                    be displayed as &quot;6.0&quot;).</td>
                            </tr>
                        </tfoot>
                    </xsl:if>
                </table>
            </xsl:for-each>
        </fieldset>
    </xsl:template>
    <!--  <xsl:template name="processLabResults">
        <xsl:param name="er7XMLMessage"/>
        <xsl:choose>
            <xsl:when test="count($er7XMLMessage//ORC) &gt; 1">
                <xsl:call-template name="groupER7XMLLabResults">
                    <xsl:with-param name="er7XMLMessage" select="$er7XMLMessage"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="groupFinalLabResults">
                    <xsl:with-param name="groupedResults" select="$er7XMLMessage"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> -->

    <xsl:template name="performingOrganizationNameAdd-DV">
        <xsl:param name="obxSegment"/>
        <fieldset>
            <table id="performingOrganizationNameAdd">
                <thead>
                    <tr>
                        <th colspan="3">Performing Organization Information - Display
                            Verification</th>
                    </tr>
                    <tr>
                        <th width="30%">Data Element Name</th>
                        <th width="30%">Data</th>
                        <th width="40%">Tester Comment</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th>Organization Name</th>
                        <xsl:copy-of select="util:formatData($obxSegment/OBX.23/OBX.23.1, 'bold')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>
                    <tr>
                        <th colspan="3">Organization Address</th>

                    </tr>
                    <tr>
                        <th class="embSpace">Street address</th>
                        <xsl:copy-of
                            select="util:formatData($obxSegment/OBX.24/OBX.24.1/OBX.24.1.1, 'bold')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>
                    <tr>
                        <th class="embSpace">Other designation</th>
                        <xsl:copy-of select="util:formatData($obxSegment/OBX.24/OBX.24.2, 'normal')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>
                    <tr>
                        <th class="embSpace">City</th>
                        <xsl:copy-of select="util:formatData($obxSegment/OBX.24/OBX.24.3, 'bold')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>
                    <tr>
                        <th class="embSpace">State</th>
                        <xsl:copy-of select="util:formatData($obxSegment/OBX.24/OBX.24.4, 'normal')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>
                    <tr>
                        <th class="embSpace">Zip code</th>
                        <xsl:copy-of select="util:formatData($obxSegment/OBX.24/OBX.24.5, 'bold')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>

                </tbody>
            </table>
        </fieldset>
    </xsl:template>

    <xsl:template name="performingOrganizationMedDr-DV">

        <xsl:param name="obxSegment"/>
        <fieldset>
            <table id="performingOrganizationMedDr">
                <thead>
                    <tr>
                        <th colspan="3">Performing Organization Medical Director Information -
                            Display Verification</th>
                    </tr>
                    <tr>
                        <th width="30%">Data Element Name</th>
                        <th width="30%">Data</th>
                        <th width="40%">Tester Comment</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th colspan="3">Medical Director Name</th>

                    </tr>
                    <tr>
                        <th colspan="3" class="embSpace">Family Name</th>

                    </tr>
                    <tr>
                        <th class="embSpace">Surname</th>
                        <xsl:copy-of
                            select="util:formatData($obxSegment/OBX.25/OBX.25.2/OBX.25.2.1, 'normal')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>
                    <tr>
                        <th class="embSpace">Given Name</th>
                        <xsl:copy-of select="util:formatData($obxSegment/OBX.25/OBX.25.3, 'normal')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>

                    <tr>
                        <th class="embSpace">Second and Further Given Names or Initials Thereof</th>
                        <xsl:copy-of select="util:formatData($obxSegment/OBX.25/OBX.25.4, 'normal')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>
                    <tr>
                        <th class="embSpace">Suffix (e.g., JR or III)</th>
                        <xsl:copy-of select="util:formatData($obxSegment/OBX.25/OBX.25.5, 'normal')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>
                    <tr>
                        <th class="embSpace">Prefix (e.g., DR)</th>
                        <xsl:copy-of select="util:formatData($obxSegment/OBX.25/OBX.25.6, 'normal')"/>
                        <xsl:call-template name="commentTemplate"/>
                    </tr>

                </tbody>
            </table>
        </fieldset>
    </xsl:template>
    <xsl:template name="localCode">
        <xsl:param name="seg9"/>
        <xsl:param name="seg2"/>
        <xsl:param name="seg5"/>
        <xsl:param name="seg3"/>
        <xsl:param name="seg6"/>
        <xsl:param name="localCode"/>
        <xsl:choose>
            <xsl:when test="($seg9 != $seg2) or ($seg9 != $seg5)">

                <xsl:copy-of select="util:formatData($seg9, 'bold')"/>

            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>


                    <xsl:when test="($seg3 = $localCode)">
                        <xsl:copy-of select="util:formatData($seg2, 'boldItalic')"/>
                    </xsl:when>
                    <xsl:when test="($seg6 = $localCode)">
                        <xsl:copy-of select="util:formatData($seg5, 'boldItalic')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="util:formatData($seg2, 'boldItalic')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="specimenInfo-DV">
        <xsl:param name="spmSegment"/>

        <fieldset>
            <xsl:for-each select="$spmSegment">
                <table id="specimenInformation">
                    <thead>
                        <tr>
                            <th colspan="3">Specimen Information - Display Verification</th>
                        </tr>
                        <tr>
                            <th width="30%">Data Element Name</th>
                            <th width="30%">Data</th>
                            <th width="40%">Tester Comment</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th>Specimen Type(Specimen Source)</th>
                            <!--   <xsl:call-template name="localCode">
                                <xsl:with-param name="seg9" select="$spmSegment/SPM.4/SPM.4.9"/>
                                <xsl:with-param name="seg2" select="$spmSegment/SPM.4/SPM.4.2"/>
                                <xsl:with-param name="seg5" select="$spmSegment/SPM.4/SPM.4.5"/>
                                <xsl:with-param name="seg3" select="$spmSegment/SPM.4/SPM.4.3"/>
                                <xsl:with-param name="seg6" select="$spmSegment/SPM.4/SPM.4.6"/>
                                <xsl:with-param name="localCode" select="'99USA'"/>
                            </xsl:call-template> -->
                            <xsl:copy-of
                                select="util:displayCond($spmSegment/SPM.4/SPM.4.9, $spmSegment/SPM.4/SPM.4.5, $spmSegment/SPM.4/SPM.4.2)"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <tr>
                            <th>Specimen Collection Date/Time - Start</th>
                            <xsl:copy-of
                                select="util:formatData(util:formatDateTime($spmSegment/SPM.17/SPM.17.1/SPM.17.1.1), 'normal')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <tr>
                            <th>Specimen Collection Date/Time - End</th>
                            <xsl:copy-of
                                select="util:formatData(util:formatDateTime($spmSegment/SPM.17/SPM.17.2/SPM.17.2.1), 'normal')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <tr>
                            <th>Specimen Reject Reason</th>
                            <!--  <xsl:call-template name="localCode">
                                <xsl:with-param name="seg9" select="$spmSegment/SPM.21/SPM.21.9"/>
                                <xsl:with-param name="seg2" select="$spmSegment/SPM.21/SPM.21.2"/>
                                <xsl:with-param name="seg5" select="$spmSegment/SPM.21/SPM.21.5"/>
                                <xsl:with-param name="seg3" select="$spmSegment/SPM.21/SPM.21.3"/>
                                <xsl:with-param name="seg6" select="$spmSegment/SPM.21/SPM.21.6"/>
                                <xsl:with-param name="localCode" select="'99USA'"/>
                            </xsl:call-template> -->
                            <xsl:copy-of
                                select="util:displayCond($spmSegment/SPM.21/SPM.21.9, $spmSegment/SPM.21/SPM.21.5, $spmSegment/SPM.21/SPM.21.2)"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>

                        <tr>
                            <th>Specimen Condition</th>
                            <!--  <xsl:call-template name="localCode">
                                <xsl:with-param name="seg9" select="$spmSegment/SPM.24/SPM.24.9"/>
                                <xsl:with-param name="seg2" select="$spmSegment/SPM.24/SPM.24.2"/>
                                <xsl:with-param name="seg5" select="$spmSegment/SPM.24/SPM.24.5"/>
                                <xsl:with-param name="seg3" select="$spmSegment/SPM.24/SPM.24.3"/>
                                <xsl:with-param name="seg6" select="$spmSegment/SPM.24/SPM.24.6"/>
                                <xsl:with-param name="localCode" select="'99USA'"/>
                            </xsl:call-template> -->
                            <xsl:copy-of
                                select="util:displayCond($spmSegment/SPM.24/SPM.24.9, $spmSegment/SPM.24/SPM.24.5, $spmSegment/SPM.24/SPM.24.2)"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                    </tbody>
                </table>
            </xsl:for-each>
        </fieldset>
    </xsl:template>
    <xsl:template name="orderInformation-DV">

        <xsl:param name="orcSegment"/>
        <fieldset>
            <xsl:for-each select="$orcSegment/..">
                <table id="orderInformation">
                    <thead>
                        <tr>
                            <th colspan="3">Order Information - Display Verification</th>
                        </tr>
                        <tr>
                            <th width="30%">Data Element Name</th>
                            <th width="30%">Data</th>
                            <th width="40%">Tester Comment</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th>Relevant Clinical Information</th>
                            <xsl:copy-of
                                select="util:displayCond($orcSegment/following-sibling::OBR[1]/OBR.13/OBR.13.9, $orcSegment/following-sibling::OBR[1]/OBR.13/OBR.13.5, $orcSegment/following-sibling::OBR[1]/OBR.13/OBR.13.2)"/>

                            <xsl:call-template name="commentTemplate"/>

                        </tr>
                        <tr>
                            <th>Placer Order Number Entity ID</th>
                            <xsl:copy-of select="util:formatData($orcSegment/ORC.2/ORC.2.1, 'bold')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <tr>
                            <th colspan="3">Ordering Provider</th>
                        </tr>
                        <tr>
                            <th colspan="3" class="embSpace">Family Name</th>
                        </tr>
                        <tr>
                            <th class="embSpace">Surname</th>
                            <xsl:copy-of
                                select="util:formatData($orcSegment/ORC.12/ORC.12.2/ORC.12.2.1, 'bold')"/>

                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <tr>
                            <th class="embSpace">Given Name</th>
                            <xsl:copy-of
                                select="util:formatData($orcSegment/ORC.12/ORC.12.3, 'bold')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>

                        <tr>
                            <th class="embSpace">Second and Further Given Names or Initials
                                Thereof</th>
                            <xsl:copy-of
                                select="util:formatData($orcSegment/ORC.12/ORC.12.4, 'bold')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <tr>
                            <th class="embSpace">Suffix (e.g., JR or III)</th>
                            <xsl:copy-of
                                select="util:formatData($orcSegment/ORC.12/ORC.12.5, 'bold')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <tr>
                            <th class="embSpace">Prefix (e.g., DR)</th>
                            <xsl:copy-of
                                select="util:formatData($orcSegment/ORC.12/ORC.12.6, 'bold')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <xsl:choose>
                            <xsl:when
                                test="$orcSegment/following-sibling::OBR[1]/OBR.49/OBR.49.1[. = 'CC']">

                                <tr>
                                    <th colspan="3">Results Copies To</th>

                                </tr>
                                <xsl:for-each select="$orcSegment/following-sibling::OBR[1]/OBR.28">
                                    <tr>
                                        <th colspan="3" class="embSpace">Family Name</th>
                                    </tr>
                                    <tr>
                                        <th class="embSpace">Surname</th>
                                        <xsl:copy-of
                                            select="util:formatData(OBR.28.2/OBR.28.2.1, 'normal')"/>

                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                    <tr>
                                        <th class="embSpace">Given Name</th>
                                        <xsl:copy-of select="util:formatData(OBR.28.3, 'normal')"/>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>

                                    <tr>
                                        <th class="embSpace">Second and Further Given Names or
                                            Initials Thereof</th>
                                        <xsl:copy-of select="util:formatData(OBR.28.4, 'normal')"/>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                    <tr>
                                        <th class="embSpace">Suffix (e.g., JR or III)</th>
                                        <xsl:copy-of select="util:formatData(OBR.28.5, 'normal')"/>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                    <tr>
                                        <th class="embSpace">Prefix (e.g., DR)</th>
                                        <xsl:copy-of select="util:formatData(OBR.28.6, 'normal')"/>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when
                                test="$orcSegment/following-sibling::OBR[1]/OBR.49/OBR.49.1[. = 'BCC']">
                                <tr>
                                    <th colspan="3">Results Copies To</th>

                                </tr>
                                <xsl:for-each select="$orcSegment/following-sibling::OBR[1]/OBR.28">
                                    <tr>
                                        <th colspan="3" class="embSpace">Family Name</th>
                                    </tr>
                                    <tr>
                                        <th class="embSpace">Surname</th>
                                        <xsl:copy-of
                                            select="util:formatData(OBR.28.2/OBR.28.2.1, 'normal')"/>

                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                    <tr>
                                        <th class="embSpace">Given Name</th>
                                        <xsl:copy-of select="util:formatData(OBR.28.3, 'normal')"/>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>

                                    <tr>
                                        <th class="embSpace">Second and Further Given Names or
                                            Initials Thereof</th>
                                        <xsl:copy-of select="util:formatData(OBR.28.4, 'normal')"/>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                    <tr>
                                        <th class="embSpace">Suffix (e.g., JR or III)</th>
                                        <xsl:copy-of select="util:formatData(OBR.28.5, 'normal')"/>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                    <tr>
                                        <th class="embSpace">Prefix (e.g., DR)</th>
                                        <xsl:copy-of select="util:formatData(OBR.28.6, 'normal')"/>
                                        <xsl:call-template name="commentTemplate"/>
                                    </tr>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if
                            test="exists($orcSegment/following-sibling::ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.TIMING_QTY/TQ1)">
                            <tr>
                                <th colspan="3">Timing/Quantity Information</th>
                            </tr>
                            <tr>
                                <th class="embSpace">Start Date/Time</th>
                                <xsl:copy-of
                                    select="util:formatData(util:formatDateTime($orcSegment/following-sibling::ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.TIMING_QTY/TQ1/TQ1.7/TQ1.7.1), 'normal')"/>
                                <xsl:call-template name="commentTemplate"/>
                            </tr>
                            <tr>
                                <th class="embSpace">End Date/Time</th>
                                <xsl:copy-of
                                    select="util:formatData(util:formatDateTime($orcSegment/following-sibling::ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.TIMING_QTY/TQ1/TQ1.8/TQ1.8.1), 'normal')"/>
                                <xsl:call-template name="commentTemplate"/>
                            </tr>
                        </xsl:if>
                    </tbody>
                </table>
            </xsl:for-each>
        </fieldset>
    </xsl:template>
    <xsl:template name="notes-DV">
        <xsl:param name="nteSegment"/>
        <xsl:if test="exists($nteSegment)">
            <fieldset>
                <table id="notes">
                    <thead>
                        <tr>
                            <th colspan="3">Note - Display Verification</th>
                        </tr>
                        <tr>
                            <th width="30%">Data Element Name</th>
                            <th width="30%">Data</th>
                            <th width="40%">Comment</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="$nteSegment">
                            <tr>
                                <th>Note/Comment</th>
                                <xsl:copy-of select="util:formatData(NTE.3, 'bold')"/>
                                <xsl:call-template name="commentTemplate"/>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
            </fieldset>
        </xsl:if>
    </xsl:template>
    <xsl:template name="time-DV">
        <xsl:param name="timeSegment"/>
        <xsl:if test="exists($timeSegment)">
            <fieldset>
                <table id="time">
                    <thead>
                        <tr>
                            <th colspan="3">Time/Quantity - Display Verification</th>
                        </tr>
                        <tr>
                            <th width="30%">Data Element Name</th>
                            <th width="30%">Data</th>
                            <th width="40%">Comment</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <tr>
                                <th class="embSpace">Start Date/Time</th>
                                <xsl:copy-of
                                    select="util:formatData(util:formatDateTime($timeSegment/TQ1.7/TQ1.7.1), 'normal')"/>
                                <xsl:call-template name="commentTemplate"/>
                            </tr>
                            <tr>
                                <th class="embSpace">End Date/Time</th>
                                <xsl:copy-of
                                    select="util:formatData(util:formatDateTime($timeSegment/TQ1.8/TQ1.8.1), 'normal')"/>
                                <xsl:call-template name="commentTemplate"/>
                            </tr>
                        </tr>
                    </tbody>
                </table>
            </fieldset>
        </xsl:if>
    </xsl:template>
    <xsl:template name="headerforIV">
        <xsl:param name="title"/>
        <thead>
            <tr>
                <th colspan="5">
                    <xsl:value-of select="$title"/>
                </th>
            </tr>
            <tr>
                <th width="15%">Location</th>
                <th width="20%">Data Element Name</th>
                <th width="5%">Store Requirement</th>
                <th width="20%">Data</th>
                <th width="40%">Tester Comment</th>
            </tr>
        </thead>
    </xsl:template>
    <xsl:template name="patientInfo-IV">
        <xsl:param name="pidSegment"/>
        <fieldset>
            <table id="identifierInformation">
                <xsl:call-template name="headerforIV">
                    <xsl:with-param name="title">Patient Information Details- Incorporate
                        Verification</xsl:with-param>
                </xsl:call-template>

                <tbody>
                    <tr>
                        <th>PID-3</th>
                        <th>Patient Identifier List</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>

                    <xsl:copy-of
                        select="util:ID-text-format('PID-3.1', 'ID Number(Note 1)', 'S-EX-A', $pidSegment/PID.3/PID.3.1, '20px', 'normal')"/>
                    <tr>
                        <th style="text-indent:20px">PID-3.4</th>
                        <th>Assigning Property</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-3.4.1', 'Namespace ID', 'S-EX-A', $pidSegment/PID.3/PID.3.4/PID.3.4.1, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-3.4.2', 'Universal ID', 'S-EX-A', $pidSegment/PID.3/PID.3.4/PID.3.4.2, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-3.4.3', 'Universal ID Type', 'S-EX-A', $pidSegment/PID.3/PID.3.4/PID.3.4.3, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-3.5', 'Identifier Type Code', 'S-RC', $pidSegment/PID.3/PID.3.5, '20px', 'normal')"/>
                    <tr>
                        <th>PID-5</th>
                        <th>Patient Name</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <tr>
                        <th style="text-indent:20px">PID-5.1</th>
                        <th>Family Name</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-5.1.1', 'Surname', 'S-EX-A', $pidSegment/PID.5/PID.5.1/PID.5.1.1, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-5.2', 'Given Name', 'S-EX-A', $pidSegment/PID.5/PID.5.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-5.3', 'Second and Further Given Names or Initials Thereof', 'S-EX-A', $pidSegment/PID.5/PID.5.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-5.4', 'Suffix (e.g., JR or III)', 'S-EX-A', $pidSegment/PID.5/PID.5.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-5.7', 'Name Type Code', 'S-RC', $pidSegment/PID.5/PID.5.7, '20px', 'normal')"/>
                    <tr>
                        <th>PID-7</th>
                        <th>Date/Time of Birth</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-7.1', 'Time', 'S-EQ', $pidSegment/PID.7/PID.7.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('PID-8', 'Administrative Sex', 'S-TR-R', $pidSegment/PID.8, '0px', 'normal')"/>
                    <xsl:for-each select="$pidSegment/PID.10">
                        <tr>
                            <th>PID-10</th>
                            <th>Race</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('PID-10.1', 'Identifier', 'S-MA', PID.10.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('PID-10.2', 'Text', 'S-MA', PID.10.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('PID-10.3', 'Name of Coding System', 'S-MA', PID.10.3, '20px', 'normal')"
                        />
                    </xsl:for-each>

                </tbody>
            </table>
        </fieldset>
    </xsl:template>
    <xsl:template name="orderInfo-IV">

        <xsl:param name="orcSegment"/>
        <xsl:for-each select="$orcSegment">
            <fieldset>
                <table id="orderInformation">
                    <xsl:call-template name="headerforIV">
                        <xsl:with-param name="title">Order Information - Incorporate
                            Verification</xsl:with-param>
                    </xsl:call-template>

                    <tbody>
                        <tr>
                            <th> ORC-2/OBR-2 </th>
                            <th>Place Order Number</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>

                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-2.1/OBR-2.1', 'Entity Identifier', 'S-EX-A', if ($orcSegment/ORC.2/ORC.2.1 = $orcSegment/following-sibling::OBR[1]/OBR.2/OBR.2.1) then
                                    $orcSegment/ORC.2/ORC.2.1
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.2/OBR.2.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-2.2/OBR-2.2', 'Namespace ID', 'S-EX-A', if ($orcSegment/ORC.2/ORC.2.2 = $orcSegment/following-sibling::OBR[1]/OBR.2/OBR.2.2) then
                                    $orcSegment/ORC.2/ORC.2.2
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.2/OBR.2.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-2.3/OBR-2.3', 'Universal ID', 'S-EX-A', if ($orcSegment/ORC.2/ORC.2.3 = $orcSegment/following-sibling::OBR[1]/OBR.2/OBR.2.3) then
                                    $orcSegment/ORC.2/ORC.2.3
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.2/OBR.2.3, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-2.4/OBR-2.4', 'Universal ID Type', 'S-EX-A', if ($orcSegment/ORC.2/ORC.2.4 = $orcSegment/following-sibling::OBR[1]/OBR.2/OBR.2.4) then
                                    $orcSegment/ORC.2/ORC.2.4
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.2/OBR.2.4, '20px', 'normal')"/>
                        <tr>
                            <th> ORC-3/OBR-3 </th>
                            <th>Filler Order Number</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-3.1/OBR-3.1', 'Entity Identifier', 'S-EX', if ($orcSegment/ORC.3/ORC.3.1 = $orcSegment/following-sibling::OBR[1]/OBR.3/OBR.3.1) then
                                    $orcSegment/ORC.3/ORC.3.1
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.3/OBR.3.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-3.2/OBR-3.2', 'Namespace ID', 'S-EX-A', if ($orcSegment/ORC.3/ORC.3.2 = $orcSegment/following-sibling::OBR[1]/OBR.3/OBR.3.2) then
                                    $orcSegment/ORC.3/ORC.3.2
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.3/OBR.3.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-3.3/OBR-3.3', 'Universal ID', 'S-EX-A', if ($orcSegment/ORC.3/ORC.3.3 = $orcSegment/following-sibling::OBR[1]/OBR.3/OBR.3.3) then
                                    $orcSegment/ORC.3/ORC.3.3
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.3/OBR.3.3, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-3.4/OBR-3.4', 'Universal ID Type', 'S-EX-A', if ($orcSegment/ORC.3/ORC.3.4 = $orcSegment/following-sibling::OBR[1]/OBR.3/OBR.3.4) then
                                    $orcSegment/ORC.3/ORC.3.4
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.3/OBR.3.4, '20px', 'normal')"/>
                        <tr>
                            <th> ORC-12/OBR-16 </th>
                            <th>Ordering Provider</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.1/OBR-16.1', 'ID Number', 'S-RC', if ($orcSegment/ORC.12/ORC.12.1 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.1) then
                                    $orcSegment/ORC.12/ORC.12.1
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.1, '20px', 'normal')"/>
                        <tr>
                            <th style="text-indent:20px">ORC-12.2/OBR-16.2</th>
                            <th>Family Name</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.2.1/OBR-16.2.1', 'Surname', 'S-RC', if ($orcSegment/ORC.12/ORC.12.2/ORC.12.2.1 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.2/OBR.16.2.1) then
                                    $orcSegment/ORC.12/ORC.12.2/ORC.12.2.1
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.2/OBR.16.2.1, '30px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.3/OBR-16.3', 'Given Name', 'S-RC', if ($orcSegment/ORC.12/ORC.12.3 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.3) then
                                    $orcSegment/ORC.12/ORC.12.3
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.3, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.4/OBR-16.4', 'Second and Further Given Names or Initials Thereof', 'S-RC', if ($orcSegment/ORC.12/ORC.12.4 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.4) then
                                    $orcSegment/ORC.12/ORC.12.4
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.4, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.5/OBR-16.5', 'Suffix (e.g., JR or III)', 'S-RC', if ($orcSegment/ORC.12/ORC.12.5 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.5) then
                                    $orcSegment/ORC.12/ORC.12.5
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.5, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.6/OBR-16.6', 'Prefix (e.g., DR)', 'S-RC', if ($orcSegment/ORC.12/ORC.12.6 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.6) then
                                    $orcSegment/ORC.12/ORC.12.6
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.6, '20px', 'normal')"/>
                        <tr>
                            <th style="text-indent:20px">ORC-12.9/OBR-16.9</th>
                            <th>Assigning Authority</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.9.1/OBR-16.9.1', 'Namespace ID', 'S-EX-A', if ($orcSegment/ORC.12/ORC.12.9/ORC.12.9.1 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.9/OBR.16.9.1) then
                                    $orcSegment/ORC.12/ORC.12.9/ORC.12.9.1
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.9/OBR.16.9.1, '30px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.9.2/OBR-16.9.2', 'Universal ID', 'S-EX-A', if ($orcSegment/ORC.12/ORC.12.9/ORC.12.9.2 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.9/OBR.16.9.2) then
                                    $orcSegment/ORC.12/ORC.12.9/ORC.12.9.2
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.9/OBR.16.9.2, '30px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.9.3/OBR-16.9.3', 'Universal ID Type', 'S-EX-A', if ($orcSegment/ORC.12/ORC.12.9/ORC.12.9.3 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.9/OBR.16.9.3) then
                                    $orcSegment/ORC.12/ORC.12.9/ORC.12.9.3
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.9/OBR.16.9.3, '30px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.10/OBR-16.10', 'Name Type Code', 'S-RC', if ($orcSegment/ORC.12/ORC.12.10 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.10) then
                                    $orcSegment/ORC.12/ORC.12.10
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.10, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-12.13/OBR-16.13', 'Identifier Type Code', 'S-RC', if ($orcSegment/ORC.12/ORC.12.13 = $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.13) then
                                    $orcSegment/ORC.12/ORC.12.13
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.16/OBR.16.13, '20px', 'normal')"/>
                      <xsl:if test="exists($orcSegment/ORC.31) or exists($orcSegment/following-sibling::OBR[1]/ORC.50)">
                        <tr>
                            <th> ORC-31/OBR-50 </th>
                            <th>Parent Universal Service Identifier</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-31.1/OBR-50.1', 'Identifier', 'S-EX-A', if ($orcSegment/ORC.31/ORC.31.1 = $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.1) then
                                    $orcSegment/ORC.31/ORC.31.1
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-31.2/OBR-50.2', 'Text', 'S-EX-A', if ($orcSegment/ORC.31/ORC.31.2 = $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.2) then
                                    $orcSegment/ORC.31/ORC.31.2
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-31.3/OBR-50.3', 'Name of Coding System', 'S-EX-A', if ($orcSegment/ORC.31/ORC.31.3 = $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.3) then
                                    $orcSegment/ORC.31/ORC.31.3
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.3, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-31.4/OBR-50.4', 'Alternate Identifier', 'S-EX-A', if ($orcSegment/ORC.31/ORC.31.4 = $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.4) then
                                    $orcSegment/ORC.31/ORC.31.4
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.4, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-31.5/OBR-50.5', 'Alternate Text', 'S-EX-A', if ($orcSegment/ORC.31/ORC.31.5 = $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.5) then
                                    $orcSegment/ORC.31/ORC.31.5
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.5, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-31.6/OBR-50.6', 'Name of Alternate Coding System', 'S-EX-A', if ($orcSegment/ORC.31/ORC.31.6 = $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.6) then
                                    $orcSegment/ORC.31/ORC.31.6
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.6, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('ORC-31.9/OBR-50.9', 'Original Text', 'S-EX-A', if ($orcSegment/ORC.31/ORC.31.9 = $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.9) then
                                    $orcSegment/ORC.31/ORC.31.9
                                else
                                    $orcSegment/following-sibling::OBR[1]/OBR.50/OBR.50.9, '20px', 'normal')"/>
</xsl:if>
                    </tbody>

                </table>
            </fieldset>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="orderInfocontd-IV">
        <xsl:param name="obrSegment"/>
        <xsl:for-each select="$obrSegment">
            <fieldset>
                <table id="orderInformation">
                    <xsl:call-template name="headerforIV">
                        <xsl:with-param name="title">Order Information (cont'd)- Incorporate
                            Verification</xsl:with-param>
                    </xsl:call-template>

                    <tbody>
                        <tr>
                            <th> OBR-4 </th>
                            <th>Universal Service Identifier (Note 1)</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-4.1', 'Identifier', 'S-TR-R', OBR.4/OBR.4.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-4.2', 'Text', 'S-EX-A', OBR.4/OBR.4.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-4.3', 'Name of the Coding System', 'S-RC', OBR.4/OBR.4.3, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-4.4', 'Alternate Identifier', 'S-TR-R', OBR.4/OBR.4.4, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-4.5', 'Alternate Text', 'S-EX-A', OBR.4/OBR.4.5, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-4.6', 'Name of Alternate Coding System', 'S-RC', OBR.4/OBR.4.6, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-4.9', 'Original Text', 'S-EX', OBR.4/OBR.4.9, '20px', 'normal')"/>

                        <tr>
                            <th> OBR-7/SPM-17.1 </th>
                            <th>Observation Date/Time</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('OBR-7.1/SPM-17.1.1', 'Time', 'S-EQ', if ($obrSegment/OBR.7/OBR.7.1 = $obrSegment/following-sibling::ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.SPECIMEN/SPM/SPM.17/SPM.17.1/SPM.17.1.1) then
                                    util:formatDateTime($obrSegment/OBR.7/OBR.7.1)
                                else
                                    util:formatDateTime(following-sibling::ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.SPECIMEN/SPM/SPM.17/SPM.17.1/SPM.17.1.1), '20px', 'normal')"/>
                        <tr>
                            <th> OBR-8/SPM-17.2 </th>
                            <th>Observation End Date/Time</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="
                                util:ID-text-format('OBR-8.1/SPM-17.2.1', 'Time', 'S-EQ', if ($obrSegment/OBR.8/OBR.8.1 = $obrSegment/following-sibling::ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.SPECIMEN/SPM/SPM.17/SPM.17.2/SPM.17.2.1) then
                                    util:formatDateTime($obrSegment/OBR.8/OBR.8.1)
                                else
                                    util:formatDateTime(following-sibling::ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.SPECIMEN/SPM/SPM.17/SPM.17.2/SPM.17.2.1), '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-11', 'Specimen Action Code', 'S-MA', OBR.4/OBR.4.1, '0px', 'normal')"/>
                        <tr>
                            <th> OBR-13 </th>
                            <th>Relevant Clinical Information</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-13.1', 'Identifier', 'S-TR-R', OBR.13/OBR.13.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-13.2', 'Text', 'S-EX-A', OBR.13/OBR.13.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-13.3', 'Name of the Coding System', 'S-RC', OBR.13/OBX.13.3, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-13.9', 'Original Text', 'S-EX', OBR.13/OBR.13.9, '20px', 'normal')"/>
                        <tr>
                            <th> OBR-22 </th>
                            <th>Results Rpt/Status Chng - Date/Time</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-22.1', 'Time', 'S-EQ', util:formatDateTime(OBR.22/OBR.22.1), '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-25', 'Result Status', 'S-TR-R', OBR.25, '0px', 'normal')"/>
                        <xsl:if test="exists(OBR.26)">
                            <tr>
                                <th> OBR-26 </th>
                                <th>Parent Result</th>
                                <th/>
                                <th/>
                                <th/>
                            </tr>
                            <tr>
                                <th style="text-indent:20px"> OBR-26.1 </th>
                                <th>Parent Observation Identifier (Note 2)</th>
                                <th/>
                                <th/>
                                <th/>
                            </tr>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-26.1.1', 'Identifier', 'S-EX-A', OBR.26/OBR.26.1/OBR.26.1.1, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-26.1.2', 'Text', 'S-EX-A', OBR.26/OBR.26.1/OBR.26.1.2, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-26.1.3', 'Name of the Coding System', 'S-EX-A', OBR.26/OBR.26.1/OBR.26.1.3, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-26.1.4', 'Alternate Identifier', 'S-EX-A', OBR.26/OBR.26.1/OBR.26.1.4, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-26.1.5', 'Alternate Text', 'S-EX-A', OBR.26/OBR.26.1/OBR.26.1.5, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-26.1.6', 'Name of Alternate Coding System', 'S-EX-A', OBR.26/OBR.26.1/OBR.26.1.6, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-26.2', 'Parent Observation Sub-Identifier', 'S-EX-A', OBR.26/OBR.26.2, '20px', 'normal')"
                            />
                        </xsl:if>
                        <xsl:for-each select="OBR.28">
                            <tr>
                                <th> OBR-28 </th>
                                <th>Result Copies To (Note 3)</th>
                                <th/>
                                <th/>
                                <th/>
                            </tr>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.1', 'ID Number', 'S-RC', OBR.28.1, '20px', 'normal')"/>
                            <tr>
                                <th style="text-indent:20px"> OBR-28.2 </th>
                                <th>Family Name</th>
                                <th/>
                                <th/>
                                <th/>
                            </tr>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.2.1', 'Surname', 'S-RC', OBR.28.2/OBR.28.2.1, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.3', 'Given Name', 'S-RC', OBR.28.3, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.4', 'Second and Further Given Names or Initials Thereof', 'S-RC', OBR.28.4, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.5', 'Suffix (e.g., JR or III)', 'S-RC', OBR.28.5, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.6', 'Prefix (e.g., DR)', 'S-RC', OBR.28.6, '20px', 'normal')"/>

                            <tr>
                                <th style="text-indent:20px"> OBR-28.9 </th>
                                <th>Assigning Authority (Note 4)</th>
                                <th/>
                                <th/>
                                <th/>
                            </tr>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.9.1', 'Namespace ID', 'S-EX-A', OBR.28.9/OBR.28.9.1, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.9.2', 'Universal ID', 'S-EX-A', OBR.28.9/OBR.28.9.2, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.9.3', 'Universal ID Type', 'S-EX-A', OBR.28.9/OBR.28.9.3, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.10', 'Name Type Code', 'S-TR-R', OBR.28.10, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-28.13', 'Identifier Type Code', 'S-RC', OBR.28.13, '20px', 'normal')"
                            />
                        </xsl:for-each>
                        <xsl:if test="exists(OBR.29)">
                            <tr>
                                <th> OBR-29 </th>
                                <th>Parent (Note 2)</th>
                                <th/>
                                <th/>
                                <th/>
                            </tr>
                            <tr>
                                <th style="text-indent:20px"> OBR-29.1 </th>
                                <th>Placer Assigned Identifier (Note 4)</th>
                                <th/>
                                <th/>
                                <th/>
                            </tr>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-29.1.1', 'Entity Identifier', 'S-EX-A', OBR.29/OBR.29.1/OBR.29.1.1, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-29.1.2', 'Namespace ID', 'S-EX-A', OBR.29/OBR.29.1/OBR.29.1.2, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-29.1.3', 'Universal ID', 'S-EX-A', OBR.29/OBR.29.1/OBR.29.1.3, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-29.1.4', 'Universal ID Type', 'S-EX-A', OBR.29/OBR.29.1/OBR.29.1.4, '30px', 'normal')"/>
                            <tr>
                                <th style="text-indent:20px"> OBR-29.2 </th>
                                <th>Filler Assigned Identifier (Note 4)</th>
                                <th/>
                                <th/>
                                <th/>
                            </tr>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-29.2.1', 'Entity Identifier', 'S-EX-A', OBR.29/OBR.29.2/OBR.29.2.1, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-29.2.2', 'Namespace ID', 'S-EX-A', OBR.29/OBR.29.2/OBR.29.2.2, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-29.2.3', 'Universal ID', 'S-EX-A', OBR.29/OBR.29.2/OBR.29.2.3, '30px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-29.2.4', 'Universal ID Type', 'S-EX-A', OBR.29/OBR.29.2/OBR.29.2.4, '30px', 'normal')"
                            />
                        </xsl:if>
                        <tr>
                            <th> OBR-49 </th>
                            <th>Results Handling</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-49.1', 'Identifier', 'S-MA', OBR.49/OBR.49.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-49.2', 'Text', 'S-MA', OBR.49/OBR.49.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBR-49.3', 'Name of Coding System', 'S-MA', OBR.49/OBR.49.3, '20px', 'normal')"/>

                        <xsl:copy-of
                            select="util:ID-text-format('OBR-49.9', 'Original Text', 'S-MA', OBR.49/OBR.49.9, '20px', 'normal')"/>
                        <xsl:if test="exists(OBR.50)">
                            <tr>
                                <th> OBR-50 </th>
                                <th>Parent Universal Service Identifier (Note 2)</th>
                                <th/>
                                <th/>
                                <th/>
                            </tr>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-50.1', 'Identifier', 'S-EX-A', OBR.50/OBR.50.1, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-50.2', 'Text', 'S-EX-A', OBR.50/OBR.50.2, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-50.3', 'Name of Coding System', 'S-EX-A', OBR.50/OBR.50.3, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-50.4', 'Alternate Identifier', 'S-EX-A', OBR.50/OBR.50.4, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-50.5', 'Alternate Text', 'S-EX-A', OBR.50/OBR.50.5, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-50.6', 'Name of Alternate Coding System', 'S-EX-A', OBR.50/OBR.50.6, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBR-50.9', 'Original Text', 'S-EX-A', OBR.50/OBR.50.9, '20px', 'normal')"
                            />
                        </xsl:if>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="5"><b>Note 1</b> - Store the Identifier and the Text for
                                each populated triplet using the S-EX-A, S-TR-R, or S-EX store
                                requirement as indicated. If Original Text field is populated, MUST
                                store the exact data received.</td>
                        </tr>
                        <tr>
                            <td colspan="5"><b>Note 2 </b>- The HIT Module is not required to store
                                the actual received data.</td>
                        </tr>
                        <tr>
                            <td colspan="5"><b>Note 3</b> - When OBR-49 = 'CC', then OBR-28 fields =
                                S-RC; when OBR-49 = 'BCC' then OBR-28 fields should not be
                                populated, but if populated = S-EX</td>
                        </tr>

                    </tfoot>
                </table>
            </fieldset>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="performingOrderInfo-IV">
        <xsl:param name="obxSegment"/>
        <fieldset>
            <table id="identifierInformation">
                <xsl:call-template name="headerforIV">
                    <xsl:with-param name="title">Performing Organization Information - Incorporate
                        Verification</xsl:with-param>
                </xsl:call-template>

                <tbody>
                    <tr>
                        <th>OBX-23</th>
                        <th>Performing Organization Name</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-23.1', 'Organization Name (Note 1)', 'S-EX-TR', $obxSegment/OBX.23/OBX.23.1, '20px', 'normal')"/>
                    <tr>
                        <th style="text-indent:20px">OBX-23.6</th>
                        <th>Assigning Authority (Note 2)</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-23.6.1', 'Namespace ID', 'S-EX-A', $obxSegment/OBX.23/OBX.23.6/OBX.23.6.1, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-23.6.2', 'Universal ID', 'S-EX-A', $obxSegment/OBX.23/OBX.23.6/OBX.23.6.2, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-23.6.3', 'Universal ID Type', 'S-EX-A', $obxSegment/OBX.23/OBX.23.6/OBX.23.6.3, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-23.7', 'Identifier Type Code', 'S-RC', $obxSegment/OBX.23/OBX.23.7, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-23.10', 'Organization Identifier', 'S-TR-R', $obxSegment/OBX.23/OBX.23.10, '20px', 'normal')"/>
                    <tr>
                        <th>OBX-24</th>
                        <th>Performing Organization Address</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <tr>
                        <th style="text-indent:20px">OBX-24.1</th>
                        <th>Street Address</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-24.1.1', 'Street or Mailing Address', 'S-EX-A', $obxSegment/OBX.24/OBX.24.1/OBX.24.1.1, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-24.2', 'Other Designation', 'S-EX-A', $obxSegment/OBX.24/OBX.24.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX.24.3', 'City', 'S-EX-A', $obxSegment/OBX.24/OBX.24.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-24.4', 'State or Province', 'S-EX-A', $obxSegment/OBX.24/OBX.24.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-24.5', 'Zip or Postal Code', 'S-EX-A', $obxSegment/OBX.24/OBX.24.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-24.6', 'Country', 'S-TR-R', $obxSegment/OBX.24/OBX.24.6, '20px', 'normal')"/>
                    <tr>
                        <th>OBX-25</th>
                        <th>Performing Organization Medical Director</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.1', 'ID Number', 'S-RC', $obxSegment/OBX.25/OBX.25.1, '20px', 'normal')"/>
                    <tr>
                        <th style="text-indent:20px">OBX-25.2</th>
                        <th>Family Name</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.2.1', 'Surname', 'S-TR-R', $obxSegment/OBX.25/OBX.25.2/OBX.25.2.1, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.3', 'Given Name', 'S-TR-R', $obxSegment/OBX.25/OBX.25.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.4', 'Second and Further Given Names or Initials Thereof', 'S-TR-R', $obxSegment/OBX.25/OBX.25.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.5', 'Suffix (e.g., JR or III)', 'S-TR-R', $obxSegment/OBX.25/OBX.25.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.6', 'Prefix (e.g., DR)', 'S-TR-R', $obxSegment/OBX.23/OBX.25.6, '20px', 'normal')"/>
                    <tr>
                        <th style="text-indent:20px">OBX-25.9</th>
                        <th>Assigning Authority (Note 2)</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.9.1', 'Namespace ID', 'S-EX-A', $obxSegment/OBX.25/OBX.25.9/OBX.25.9.1, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.9.2', 'Universal ID', 'S-EX-A', $obxSegment/OBX.25/OBX.25.9/OBX.25.9.2, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.9.3', 'Universal ID Type', 'S-EX-A', $obxSegment/OBX.25/OBX.25.9/OBX.25.9.3, '30px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.10', 'Name Type Code', 'S-RC', $obxSegment/OBX.25/OBX.25.10, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('OBX-25.13', 'Identifier Type Code', 'S-RC', $obxSegment/OBX.25/OBX.25.13, '20px', 'normal')"/>

                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="5">
                            <b>Note 1</b> - The HIT Module must store the Organization Name or be
                            able to recreate it. If the HIT Module is able to demonstrate
                            OrganizationName: ID is always 1:1, then the HIT Module is permitted to
                            store and recreate (S-TR-R). </td>
                    </tr>
                    <tr>
                        <td colspan="5"><b>Note 2</b> - Determine requirement for support of 2nd
                            component or 3rd and 4th component based on the EI or HD Profile </td>
                    </tr>
                </tfoot>
            </table>
        </fieldset>
    </xsl:template>
    <xsl:template name="resultInfo-IV">
        <xsl:param name="obxSegment"/>

        <fieldset>
            <xsl:for-each
                select="$obxSegment/following-sibling::ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.OBSERVATION/OBX">
                <xsl:variable name="resultValue">
                    <xsl:choose>
                        <xsl:when test="OBX.2 = 'NM'">

                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5', 'Observation Value', 'S-EX', OBX.5, '0px', 'normal')"
                            />
                        </xsl:when>
                        <xsl:when test="OBX.2 = 'SN'">
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5', 'Observation Value', 'S-EX', OBX.5, '0px', 'normal')"
                            />
                        </xsl:when>
                        <xsl:when test="OBX.2 = 'FT'">
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5', 'Observation Value', 'S-EX', OBX.5, '0px', 'normal')"
                            />
                        </xsl:when>
                        <xsl:when test="OBX.2 = 'ST'">
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5', 'Observation Value', 'S-EX', OBX.5, '0px', 'normal')"
                            />
                        </xsl:when>
                        <xsl:when test="OBX.2 = 'TX'">
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5', 'Observation Value', 'S-EX', OBX.5, '0px', 'normal')"
                            />
                        </xsl:when>
                        <xsl:when test="OBX.2 = 'DT'">
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5', 'Observation Value', 'S-EQ', OBX.5, '0px', 'normal')"
                            />
                        </xsl:when>
                        <xsl:when test="OBX.2 = 'TS'">
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5', 'Observation Value', 'S-EQ', OBX.5, '0px', 'normal')"
                            />
                        </xsl:when>
                        <xsl:when test="OBX.2 = 'TM'">
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5', 'Observation Value', 'S-EQ', OBX.5, '0px', 'normal')"
                            />
                        </xsl:when>
                        <xsl:when test="OBX.2 = 'CWE'">
                            <tr>
                                <th>OBX-5</th>
                                <th>Observation Value</th>
                                <th/>
                                <th/>
                                <th/>
                            </tr>
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5.1', 'Identifier', 'S-TR-R', OBX.5/OBX.5.1, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5.2', 'Text', 'S-EX-A', OBX.5/OBX.5.2, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5.3', 'Name of the Coding System', 'S-RC', OBX.5/OBX.5.3, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5.4', 'Alternate Identifier', 'S-TR-R', OBX.5/OBX.5.4, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5.5', 'Alternate Text', 'S-EX-A', OBX.5/OBX.5.5, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5.6', 'Name of Alternate Coding System', 'S-RC', OBX.5/OBX.5.6, '20px', 'normal')"/>
                            <xsl:copy-of
                                select="util:ID-text-format('OBX-5.9', 'Original Text', 'S-EX', OBX.5/OBX.5.9, '20px', 'normal')"/>

                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <table id="identifierInformation">
                    <xsl:call-template name="headerforIV">
                        <xsl:with-param name="title">Result Information - Incorporate
                            Verification</xsl:with-param>
                    </xsl:call-template>

                    <tbody>
                        <tr>
                            <th>OBX-3</th>
                            <th>Observation Identifier (Note 1)</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-3.1', 'Identifier', 'S-TR-R', OBX.3/OBX.3.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-3.2', 'Text', 'S-EX-A', OBX.3/OBX.3.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-3.3', 'Name of the Coding System', 'S-RC', OBX.3/OBX.3.3, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-3.4', 'Alternate Identifier', 'S-TR-R', OBX.3/OBX.3.4, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-3.5', 'Alternate Text', 'S-EX-A', OBX.3/OBX.3.5, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-3.6', 'Name of Alternate Coding System', 'S-RC', OBX.3/OBX.3.6, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-3.9', 'Original Text', 'S-EX', OBX.3/OBX.3.9, '20px', 'normal')"/>
                        <xsl:copy-of select="$resultValue"/>
                        <tr>
                            <th>OBX-6</th>
                            <th>Units (Note 2)</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-6.1', 'Identifier', 'S-TR-R', OBX.6/OBX.6.1, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-6.2', 'Text', 'S-EX-A', OBX.6/OBX.6.2, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-6.3', 'Name of the Coding System', 'S-RC', OBX.6/OBX.6.3, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-6.4', 'Alternate Identifier', 'S-TR-R', OBX.6/OBX.6.4, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-6.5', 'Alternate Text', 'S-TR-R', OBX.6/OBX.6.5, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-6.6', 'Name of Alternate Coding System', 'S-RC', OBX.6/OBX.6.6, '20px', 'normal')"/>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-6.9', 'Original Text', 'S-EX', OBX.6/OBX.6.9, '20px', 'normal')"/>
                        <tr>
                            <th>OBX-7</th>
                            <th>Reference Range</th>
                            <td>S-EX</td>
                            <xsl:copy-of select="util:formatData(OBX.7, 'normal')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <tr>
                            <th>OBX-8</th>
                            <th>Abnormal Flags</th>
                            <td>S-TR-R</td>
                            <xsl:copy-of select="util:formatData(OBX.8, 'normal')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <tr>
                            <th>OBX-11</th>
                            <th>Observation Result Status</th>
                            <td>S-TR-R</td>
                            <xsl:copy-of select="util:formatData(OBX.11, 'normal')"/>
                            <xsl:call-template name="commentTemplate"/>
                        </tr>
                        <tr>
                            <th>OBX-14</th>
                            <th>Date/Time of the Observation</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-14.1', 'Time', 'S-EQ', util:formatDateTime(OBX.14/OBX.14.1), '20px', 'normal')"/>
                        <tr>
                            <th>OBX-19</th>
                            <th>Date/Time of the Analysis</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('OBX-19.1', 'Time', 'S-EQ', util:formatDateTime(OBX.19/OBX.19.1), '20px', 'normal')"
                        />
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="5">
                                <b>Note 1</b> - Store the Identifier and the Text for each populated
                                triplet using the S-EX-A, S-TR-R, or S-EX store requirement as
                                indicated. If Original Text field is populated, MUST store the exact
                                data received.</td>
                        </tr>
                        <tr>
                            <td colspan="5">
                                <b>Note 2</b> - If both UOM triplets are populated, receiver may
                                choose to store the data received in either triplet; translations
                                must result in equivalent UOM that do not require a change in the
                                numeric result. </td>
                        </tr>
                    </tfoot>
                </table>
                <br/>
            </xsl:for-each>
        </fieldset>
    </xsl:template>
    <xsl:template name="specimentInfo-IV">
        <xsl:param name="spmSegment"/>
        <fieldset>
            <table id="specimenInformation">
                <xsl:call-template name="headerforIV">
                    <xsl:with-param name="title">Specimen Information - Incorporate
                        Verification</xsl:with-param>
                </xsl:call-template>

                <tbody>
                    <tr>
                        <th>SPM-4</th>
                        <th>Specimen Type (Note 1)</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-4.1', 'Identifier', 'S-TR-R', $spmSegment/SPM.4/SPM.4.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-4.2', 'Text', 'S-EX-A', $spmSegment/SPM.4/SPM.4.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-4.3', 'Name of the Coding System', 'S-RC', $spmSegment/SPM.4/SPM.4.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-4.4', 'Alternate Identifier', 'S-TR-R', $spmSegment/SPM.4/SPM.4.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-4.5', 'Alternate Text', 'S-EX-A', $spmSegment/SPM.4/SPM.4.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-4.6', 'Name of Alternate Coding System', 'S-RC', $spmSegment/SPM.4/SPM.4.6, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-4.9', 'Original Text', 'S-EX', $spmSegment/SPM.4/SPM.4.9, '20px', 'normal')"/>
                    <tr>
                        <th>SPM-21</th>
                        <th>Specimen Reject Reason (Note 1)</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-21.1', 'Identifier', 'S-TR-R', $spmSegment/SPM.21/SPM.21.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-21.2', 'Text', 'S-EX-A', $spmSegment/SPM.21/SPM.21.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-21.3', 'Name of the Coding System', 'S-RC', $spmSegment/SPM.21/SPM.21.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-21.4', 'Alternate Identifier', 'S-TR-R', $spmSegment/SPM.21/SPM.21.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-21.5', 'Alternate Text', 'S-EX-A', $spmSegment/SPM.21/SPM.21.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-21.6', 'Name of Alternate Coding System', 'S-RC', $spmSegment/SPM.21/SPM.21.6, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-21.9', 'Original Text', 'S-EX', $spmSegment/SPM.21/SPM.21.9, '20px', 'normal')"/>
                    <tr>
                        <th>SPM-24</th>
                        <th>Specimen Condition (Note 1)</th>
                        <th/>
                        <th/>
                        <th/>
                    </tr>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-24.1', 'Identifier', 'S-TR-R', $spmSegment/SPM.24/SPM.24.1, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-24.2', 'Text', 'S-EX-A', $spmSegment/SPM.24/SPM.24.2, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-24.3', 'Name of the Coding System', 'S-RC', $spmSegment/SPM.24/SPM.24.3, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-24.4', 'Alternate Identifier', 'S-TR-R', $spmSegment/SPM.24/SPM.24.4, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-24.5', 'Alternate Text', 'S-EX-A', $spmSegment/SPM.24/SPM.24.5, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-24.6', 'Name of Alternate Coding System', 'S-RC', $spmSegment/SPM.24/SPM.24.6, '20px', 'normal')"/>
                    <xsl:copy-of
                        select="util:ID-text-format('SPM-24.9', 'Original Text', 'S-EX', $spmSegment/SPM.24/SPM.24.9, '20px', 'normal')"
                    />
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="5">
                            <b>Note 1</b> - Store the Identifier and the Text for each populated
                            triplet using the S-EX-A, S-TR-R, or S-EX store requirement as
                            indicated. If Original Text field is populated, MUST store the exact
                            data received. </td>
                    </tr>
                </tfoot>
            </table>
        </fieldset>
    </xsl:template>
    <xsl:template name="note-IV">
        <xsl:param name="nteSegment"/>
        <xsl:if test="exists($nteSegment)">
            <fieldset>
                <table id="note">
                    <xsl:call-template name="headerforIV">
                        <xsl:with-param name="title">Note- Incorporate Verification</xsl:with-param>
                    </xsl:call-template>

                    <tbody>
                        <xsl:for-each select="$nteSegment">

                            <xsl:copy-of
                                select="util:ID-text-format('NTE.3', 'Note', 'S-EX', NTE.3, '0px', 'normal')"/>


                        </xsl:for-each>
                    </tbody>
                </table>
            </fieldset>
        </xsl:if>
    </xsl:template>
    <xsl:template name="time-IV">
        <xsl:param name="timeSegment"/>
        <xsl:if test="exists($timeSegment)">
            <fieldset>
                <table id="note">
                    <xsl:call-template name="headerforIV">
                        <xsl:with-param name="title">Timing/Quantity Information- Incorporate
                            Verification</xsl:with-param>
                    </xsl:call-template>

                    <tbody>
                        <tr>
                            <th>TQ1-7</th>
                            <th>Start Date/Time</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>

                        <xsl:copy-of
                            select="util:ID-text-format('TQ1-7.1', 'Time', 'S-EQ', util:formatDateTime($timeSegment/TQ1.7/TQ1.7.1), '20px', 'normal')"/>
                        <tr>
                            <th>TQ1-8</th>
                            <th>End Date/Time</th>
                            <th/>
                            <th/>
                            <th/>
                        </tr>
                        <xsl:copy-of
                            select="util:ID-text-format('TQ1-8.1', 'Time', 'S-EQ', util:formatDateTime($timeSegment/TQ1.8/TQ1.8.1), '20px', 'normal')"/>

                    </tbody>
                </table>
            </fieldset>
        </xsl:if>
    </xsl:template>

    <xsl:template name="instructions">
        <fieldset>
            <h3 align="center">Instructions to Testers for Verification of Store Requirements</h3>
            <p>
                <i>Note: The HIT Module being tested is always allowed to incorporate/store the
                    exact data received in the LRI message even if a given Store Requirement does
                    not explicitly state that the HIT Module is permitted to do so. </i>
            </p>
            <table>
                <thead>
                    <tr>
                        <td style="text-align:center">
                            <b>Store Requirement</b>
                        </td>
                        <td style="text-align:center">
                            <b>Definition</b>
                        </td>
                        <td style="text-align:center">
                            <b> Instructions for Verification of Requirement During Conformance
                                Testing</b>
                        </td>
                    </tr>

                </thead>
                <tbody>
                    <tr>
                        <td>S-EX</td>
                        <td>Store Exact</td>
                        <td>
                            <p>The HIT Module being tested must be designed to incorporate/store
                                only the exact data received in the LRI message.</p>
                            <ul>
                                <li> Tester must verify that the HIT Module being tested
                                    incorporates/stores <b>in the patient&apos;s laboratory result
                                        record only the exact data received</b> in the LRI message,
                                    and that the HIT Module does not just store an equivalent of
                                    that exact data or just a pointer to the exact data. </li>
                            </ul>
                        </td>

                    </tr>
                    <tr>
                        <td>S-EX-TR</td>
                        <td>Store exact; translation allowed, and if translated store
                            translation</td>
                        <td>
                            <p>The HIT Module being tested must be designed to incorporate/store the
                                exact data received in the LRI message AND may also be designed to
                                transform the exact data received in the LRI message to an
                                equivalent value and then incorporate/store the equivalent value in
                                addition to the exact value.</p>
                            <ul>
                                <li>Tester must verify that the HIT Module being tested
                                    incorporates/stores <b>in the patient&apos;s laboratory result
                                        record the exact data received</b> in the LRI message; </li>
                                <li>Tester also must verify that the HIT Module incorporates/stores
                                        <b>the equivalent value in the patient&apos;s laboratory
                                        result record</b> if the system being tested is designed to
                                    transform the exact data received in the LRI message to an
                                    equivalent value and then incorporate/store the equivalent value
                                    in addition to the exact value. </li>
                            </ul>
                        </td>

                    </tr>
                    <tr>
                        <td>S-EX-A</td>
                        <td>Store exact by association</td>
                        <td>
                            <p>The HIT Module being tested must be designed to incorporate/store the
                                exact data received in the LRI message OR to use a pointer to a
                                location (e.g., file/table in or accessible to the HIT Module) where
                                the exact data can be obtained. </p>
                            <ul>
                                <li>Tester must verify that the HIT Module being tested
                                    incorporates/stores <b>in the patient&apos;s laboratory result
                                        record the exact data received</b> in the LRI message OR
                                    that the HIT Module incorporates/stores <b>in the patient&apos;s
                                        laboratory result record a pointer to the exact data
                                        received</b> in the LRI message. </li>
                            </ul>
                            <p>Example: Placer Number; the HIT-originated Placer Number received in
                                the LRI message may be incorporated/stored using a pointer rather
                                than being stored redundantly in the patient&apos;s lab result
                                record.</p>
                        </td>
                    </tr>
                    <tr>
                        <td> S-EQ </td>
                        <td>Store equivalent</td>
                        <td>
                            <p>The HIT Module being tested must be designed to transform the exact
                                data received in the LRI message to an equivalent value and then
                                incorporate/store the equivalent value.</p>
                            <ul>
                                <li>Tester must verify that the HIT Module being tested transforms
                                    the exact data received in the LRI message to an equivalent
                                    value and incorporates/stores <b>the equivalent value in the
                                        patient&apos;s laboratory result record.</b>
                                </li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>S-TR-R</td>
                        <td> Translate and store translation (exact value can be re-created from
                            translation any time) </td>
                        <td>
                            <p>The HIT Module being tested must be designed to transform the exact
                                data received in the LRI message to an equivalent value and then
                                incorporate/store the equivalent value. </p>
                            <ul>
                                <li>Tester must verify that the HIT Module being tested
                                    incorporates/stores <b>in the patient&apos;s laboratory result
                                        record the equivalent value.</b></li>
                                <li>Tester must also verify that the HIT Module is able to re-create
                                    from this equivalent value the exact data received in the LRI
                                    message.</li>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <td>S-RC</td>
                        <td>Process and re-create</td>
                        <td>
                            <p>The HIT Module being tested must be designed to process and
                                incorporate/store in an &quot;abstract-able manner&quot; (e.g.,
                                using the HIT Module&apos;s data model) the exact data received in
                                the LRI message and to re-create the exact data (e.g., from the HIT
                                Module&apos;s data model). </p>
                            <ul>
                                <li>Tester must verify that the HIT Module being tested processes
                                    and abstractly incorporates/stores<b> in the patient&apos;s
                                        laboratory result record the exact data received</b> in the
                                    LRI message. </li>
                                <li> Tester also must verify that the HIT Module is able to
                                    re-create the exact data received in the LRI message by
                                    abstracting the data (e.g., from the HIT Module&apos;s data
                                    model). </li>
                            </ul>
                            <p>Example: Identifier Type Code; the HIT Module uses a separate
                                file/table to store Social Security Numbers versus internal Medical
                                Record Numbers, and does not need to retain the Identifier Type Code
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>S-MA</td>
                        <td>Made available for specific processing</td>
                        <td>
                            <p>The HIT Module being tested must be designed to use the exact data
                                received in the LRI message to accomplish certain tasks defined by
                                the Incorporate Lab Results Use Case (e.g., performing a patient
                                match), but need not be designed to incorporate/store the data once
                                it has been used for the specified purpose. </p>
                            <ul>
                                <li>Tester must verify that the HIT Module being tested uses the
                                    exact data received in the LRI message to accomplish the
                                    incorporation/storing of the lab result information in the
                                    patient&apos;s laboratory result record.</li>
                                <li>The HIT Module may persist the data used for this purpose, but
                                    Tester is not required to verify that the HIT Module is able to
                                    incorporate/store the exact data that are used for this
                                    purpose</li>
                            </ul>
                        </td>
                    </tr>
                </tbody>
            </table>
        </fieldset>
    </xsl:template>
    <xsl:template name="buildJurorDoc">
        <xsl:param name="er7XMLMessage"/>
        <xsl:param name="groupedLabResults"/>
        <html>
            <head>
                <!--  <title>
                    <xsl:value-of select="$segmentName"/>
                </title> -->
                <xsl:call-template name="jurorAppearance"/>
            </head>
            <body>
                <div class="jurorContainer">

                    <xsl:call-template name="messageHeader">
                        <xsl:with-param name="er7MsgId">
                            <xsl:value-of select="$testCaseName"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <br/>
                    <fieldset>
                        <p>This Test Case-specific Juror Document provides a checklist for the
                            Tester to use during testing for assessing the Health IT Module’s
                            ability to display and incorporate required data elements from the
                            information received in the LRI message. Additional data from the
                            message or from the Health IT Module are permitted to be displayed and
                            incorporated by the Module. Grayed-out fields in the Juror Document
                            indicate where no data for the data element indicated were included in
                            the LRI message for the given Test Case. </p>
                        <p>The format of the Display Verification section of this Juror Document is
                            for ease-of-use by the Tester and does not indicate how the Health IT
                            Module display must be designed.</p>
                    </fieldset>
                    <h2>Display Verification</h2>
                    <fieldset>
                        <legend>Legend for Display Requirement</legend>
                        <p>Data in <b>bold</b> text: HIT Module must display exact version of stored
                            data</p>
                        <p>Data in <b><i>bold italics</i></b> text: HIT Module must display exact
                            version of data received in the LRI message</p>
                        <p>Data in regular text: HIT Module may display equivalent version of stored
                            data</p>
                    </fieldset>
                    <br/>
                    <xsl:call-template name="patientInfo-DV">
                        <xsl:with-param name="pidSegments" select="//PID"/>
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="labResults-DV">
                        <xsl:with-param name="obrSegment" select="//OBR"/>
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="performingOrganizationNameAdd-DV">
                        <xsl:with-param name="obxSegment"
                            select="//ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.OBSERVATION[1]/OBX[1]"
                        />
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="performingOrganizationMedDr-DV">
                        <xsl:with-param name="obxSegment"
                            select="//ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.OBSERVATION[1]/OBX[1]"
                        />
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="specimenInfo-DV">
                        <xsl:with-param name="spmSegment" select="//SPM"/>
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="orderInformation-DV">
                        <xsl:with-param name="orcSegment" select="//ORC"/>

                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="notes-DV">
                        <xsl:with-param name="nteSegment" select="//NTE"/>
                    </xsl:call-template>
                    <br/>

                    <xsl:call-template name="time-DV">
                        <xsl:with-param name="timeSegment" select="//TQ1"/>
                    </xsl:call-template>

                    <h2>Incorporate Verification</h2>
                    <fieldset>
                        <legend>Legend for Store Requirement</legend>

                        <pre> S-EX         Store exact</pre>
                        <pre> S-EX-TR  Store exact; translation allowed, and if translated store translation</pre>
                        <pre> S-EX-A	  Store exact by association</pre>
                        <pre> S-TR-R	  Translate and store translation (exact value can be re-created from translation any time)</pre>
                        <pre> S-EQ 	  Store equivalent</pre>
                        <pre> S-RC	  Process and re-create</pre>
                        <pre> S-MA	  Made available for specific processing</pre>
                        <p>(See <b> &quot;Instructions to Testers for Verification of Store
                                Requirements&quot;</b> at the end of this Juror Document for
                            additional details.)</p>


                    </fieldset>
                    <br/>
                    <xsl:call-template name="patientInfo-IV">
                        <xsl:with-param name="pidSegment" select="//PID"/>
                    </xsl:call-template>

                    <br/>
                    <xsl:call-template name="orderInfo-IV">
                        <xsl:with-param name="orcSegment" select="//ORC"/>
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="orderInfocontd-IV">
                        <xsl:with-param name="obrSegment" select="//OBR"/>
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="performingOrderInfo-IV">
                        <xsl:with-param name="obxSegment"
                            select="//ORU_R01.PATIENT_RESULT.ORDER_OBSERVATION.OBSERVATION[1]/OBX[1]"
                        />
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="resultInfo-IV">
                        <xsl:with-param name="obxSegment" select="//OBR"/>
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="specimentInfo-IV">
                        <xsl:with-param name="spmSegment" select="//SPM"/>
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="note-IV">
                        <xsl:with-param name="nteSegment" select="//NTE"/>
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="time-IV">
                        <xsl:with-param name="timeSegment" select="//TQ1"/>
                    </xsl:call-template>
                    <br/>
                    <xsl:call-template name="instructions"/>

                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="/">

        <xsl:call-template name="buildJurorDoc"> </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
