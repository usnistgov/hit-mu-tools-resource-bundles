<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:util="http://hl7.nist.gov/data-specs/util"
    xpath-default-namespace="" exclude-result-prefixes="xs util" version="2.0">
    <!-- param: output   values:  ng-tab-html    default: plain-html -->

    <!--  <xsl:param name="output" select="'plain-html'"/>-->
   <xsl:param name="output" select="'ng-tab-html'"/>
    <!-- param for font size in table 'td' -->
    <xsl:param name="font-size" select="'100%'"/>
    <xsl:character-map name="tags">
        <xsl:output-character character="&lt;" string="&lt;"/>
        <xsl:output-character character="&gt;" string="&gt;"/>
    </xsl:character-map>
    <xsl:output method="xhtml" use-character-maps="tags"/>
    <xsl:variable name="generate-plain-html"
        select="$output = 'plain-html' or $output = 'ng-tab-html'"/>
    <xsl:variable name="testStory" select="'TestStory'"/>
    <xsl:variable name="version" select="'1.0'"/>
    <xsl:template match="*">
        <xsl:choose>

            <xsl:when test="$output = 'plain-html'">
                <xsl:call-template name="plain-html"/>
            </xsl:when>
            <xsl:when test="$output = 'ng-tab-html'">
                <xsl:call-template name="ng-tab-html"/>
            </xsl:when>

        </xsl:choose>
    </xsl:template>

    <xsl:template name="main">

        <xsl:value-of select="util:start(name(.), 'test-story-main')"/>
        <xsl:if test="$output = 'ng-tab-html'">
            <xsl:variable name="full">
                <xsl:call-template name="_main"/>
            </xsl:variable>
            <xsl:value-of select="util:begin-tab('FULL', 'All Segments', '', false())"/>
            <xsl:value-of select="util:strip-tabsets($full)"/>
            <xsl:value-of select="util:end-tab($ind1, false())"/>
        </xsl:if>
        <xsl:call-template name="_main"/>
        <xsl:value-of select="util:end($ind1)"/>
    </xsl:template>
    <xsl:template name="_main">
        <xsl:variable name="message-type">
            <xsl:choose>
                <xsl:when test="starts-with(name(.), 'TestStory')">
                    <xsl:value-of select="$testStory"/>
                </xsl:when>

            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$message-type = $testStory">

            <xsl:call-template name="segment">
                <xsl:with-param name="segments" select="//teststorydesc"/>
                <xsl:with-param name="mode" select="'testStory'"/>
            </xsl:call-template>
            <xsl:call-template name="segment">
                <xsl:with-param name="segments" select="//comments"/>
                <xsl:with-param name="mode" select="'testStory'"/>
            </xsl:call-template>

            <xsl:call-template name="segment">
                <xsl:with-param name="segments" select="//preCondition"/>
                <xsl:with-param name="mode" select="'testStory'"/>
            </xsl:call-template>
            <xsl:call-template name="segment">
                <xsl:with-param name="segments" select="//postCondition"/>
                <xsl:with-param name="mode" select="'testStory'"/>
            </xsl:call-template>
            <xsl:call-template name="segment">
                <xsl:with-param name="segments" select="//testObjectives"/>
                <xsl:with-param name="mode" select="'testStory'"/>
            </xsl:call-template>
            <xsl:call-template name="segment">
                <xsl:with-param name="segments" select="//evaluationCriteria"/>
                <xsl:with-param name="mode" select="'testStory'"/>
            </xsl:call-template>
            <xsl:call-template name="segment">
                <xsl:with-param name="segments" select="//notes"/>
                <xsl:with-param name="mode" select="'testStory'"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="segment">
        <xsl:param name="segments"/>
        <xsl:param name="mode"/>
        <xsl:value-of
            select="util:title('title', util:segdesc(name($segments)), util:segdesc(name($segments)), $ind1, false(), false(), false())"/>
        <xsl:value-of select="util:elements($ind1, util:segdesc(name($segments)))"/>
        <xsl:value-of select="util:single-element($segments, $ind1)"/>
        <xsl:value-of select="util:end-elements($ind1, false(), false())"/>
    </xsl:template>

    <xsl:variable name="ind1" select="'&#x9;&#x9;'"/>
    <xsl:variable name="ind2" select="'&#x9;&#x9;&#x9;&#x9;&#x9;'"/>

    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:end-table">
        <xsl:param name="ind"/>
        <xsl:choose>
            <xsl:when test="$generate-plain-html">
                <xsl:value-of select="util:tag('/table', $ind)"/>
                <xsl:value-of select="util:tag('br/', $ind)"/>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:elements">
        <xsl:param name="ind"/>
        <xsl:param name="title"/>
        <xsl:choose>
            <xsl:when test="$generate-plain-html">
                <xsl:value-of select="util:tag('table', $ind)"/>
                <xsl:value-of select="util:tag('tr', $ind)"/>
                <xsl:value-of select="util:tags('th', $title, $ind)"/>

                <xsl:value-of select="util:tag('/tr', $ind)"/>
            </xsl:when>

        </xsl:choose>
    </xsl:function>

    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:single-element">
        <xsl:param name="name"/>
        <xsl:param name="ind"/>
        <xsl:choose>
            <xsl:when test="$generate-plain-html">
                <xsl:variable name="td-element">
                    <xsl:value-of select="util:tag('td', $ind)"/>
                    <xsl:value-of select="$name"/>
                    <xsl:value-of select="util:tag('/td', $ind)"/>
                </xsl:variable>
                <xsl:value-of select="util:tags('tr', $td-element, $ind)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="util:element-with-delimiter($name, '', ',', $ind)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:element-with-delimiter">
        <xsl:param name="name"/>
        <xsl:param name="value"/>
        <xsl:param name="trailing"/>
        <xsl:param name="ind"/>
        <xsl:choose>
            <xsl:when test="$generate-plain-html">
                <xsl:variable name="td-element">
                    <xsl:value-of select="util:tags('td', $name, $ind)"/>
                    <xsl:message>
                        <xsl:value-of select="$name"/>
                    </xsl:message>
                    <xsl:choose>
                        <xsl:when test="normalize-space($value) = ''">
                            <xsl:value-of select="util:tag('td class=''noData''', $ind)"/>
                            <xsl:value-of select="$value"/>
                            <xsl:value-of select="util:tag('/td', $ind)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="util:tags('td', $value, $ind)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="util:tags('tr', $td-element, $ind)"/>
            </xsl:when>

        </xsl:choose>
    </xsl:function>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:end-elements">
        <xsl:param name="ind"/>
        <xsl:param name="vertical-orientation" as="xs:boolean"/>
        <xsl:param name="full" as="xs:boolean"/>
        <xsl:choose>
            <xsl:when test="$generate-plain-html">
                <xsl:variable name="end-elements">
                    <xsl:value-of select="util:tag('/table', $ind)"/>
                    <xsl:value-of select="util:tag('br/', $ind)"/>
                    <xsl:if test="not($full)">
                        <xsl:value-of select="util:end-tab($ind, $vertical-orientation)"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$end-elements"/>
            </xsl:when>

        </xsl:choose>
    </xsl:function>
    <xsl:template xmlns:fo="http://www.w3.org/1999/XSL/Format" name="plain-html">
        <html xmlns="">
            <head>
                <xsl:call-template name="css"/>
            </head>
            <body>
                <xsl:call-template name="main"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template xmlns:fo="http://www.w3.org/1999/XSL/Format" name="ng-tab-html">
        <xsl:call-template name="css"/>
        <xsl:call-template name="main"/>
    </xsl:template>
    <xsl:template xmlns:fo="http://www.w3.org/1999/XSL/Format" name="css">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <style xmlns="" type="text/css">
            @media screen{
                .test-story-main legend{
                    text-align:center;
                    font-size:110%;
                    font-weight:bold;
                }
                .test-story-main .nav-tabs{
                    font-weight:bold;
                }
                .test-story-main .tds_obxGrpSpl{
                    background:#B8B8B8;
                }
                .test-story-main maskByMediaType{
                    display:table;
                }
                .test-story-main table tbody tr th{
                    font-size:95%
                }
                .test-story-main table tbody tr td{
                    font-size: <xsl:value-of select="$font-size"/>;
                }
                .test-story-main table tbody tr th{
                    text-align:left;
                    background:#C6DEFF;
                    font-size:100%;
                }
                .test-story-main fieldset{
                    text-align:center;
                }
                .test-story-main table{
                    width:98%;
                    border:1px groove;
                    table-layout:fixed;
                    margin:0 auto;
                    border-collapse:collapse;
                }
                .test-story-main table tr{
                    border:2px groove;
            
                }
                .test-story-main table th{
                    border:2px groove;
            
                }
                .test-story-main table td{
                    border:1px groove;
            
                }
                .test-story-main table thead{
                    border:1px groove;
                    background:#446BEC;
                    text-align:center;
                }
                .test-story-main .separator{
                    background:rgb(240, 240, 255);
                    text-align:left;
                }
                .test-story-main table tbody tr td{
                    text-align:left
                }
                .test-story-main .noData{
                    background:#B8B8B8;
                }
                .test-story-main .childField{
                    background:#B8B8B8;
                }
                .test-story-main .title{
                    text-align:left;
                }
                .test-story-main h3{
                    text-align:center;
                    page-break-inside:avoid;
                }
                .test-story-main h2{
                    text-align:center;
                }
                .test-story-main h1{
                    text-align:center;
                }
                .test-story-main .pgBrk{
                    padding-top:15px;
                }
                .test-story-main .er7Msg{
                    width:100%;
                }
                .test-story-main .embSpace{
                    padding-left:15px;
                }
                .test-story-main .accordion-heading{
                    font-weight:bold;
                    font-size:90%;
                }
                .test-story-main .accordion-heading i.fa:after{
                    content:"\00a0 ";
                }
                .test-story-main panel{
                    margin:10px 5px 5px 5px;
                }
            }
            
            @media print{
                .test-story-main legend{
                    text-align:center;
                    font-size:110%;
                    font-weight:bold;
                }
                .test-story-main .nav-tabs{
                    font-weight:bold;
                }
                .test-story-main .obxGrpSpl{
                    background:#B8B8B8;
                }
                .test-story-main maskByMediaType{
                    display:table;
                }
                .test-story-main table tbody tr th{
                    font-size:90%
                }
                .test-story-main table tbody tr td{
                    font-size:90%;
                }
                .test-story-main table tbody tr th{
                    text-align:left;
                    background:#C6DEFF;
            
                }
                .test-story-main table thead tr th{
                    text-align:center;
                    background:#4682B4;
            
                }
                .test-story-main fieldset{
                    text-align:center;
                    page-break-inside:avoid;
                }
                .test-story-main table{
                    width:98%;
                    border:1px groove;
                    table-layout:fixed;
                    margin:0 auto;
                    page-break-inside:avoid;
                    border-collapse:collapse;
                }
                .test-story-main table tr{
                    border:2px groove;
                }
                .test-story-main table th{
                    border:2px groove;
                }
                .test-story-main table td{
                    border:1px groove;
                }
                .test-story-main table thead{
                    border:1px groove;
                    background:#446BEC;
                    text-align:left;
                }
                .test-story-main .separator{
                    background:rgb(240, 240, 255);
                    text-align:left;
                }
                .test-story-main table tbody tr td{
                    text-align:left;
                }
                .test-story-main .noData{
                    background:#B8B8B8;
                }
                .test-story-main .childField{
                    background:#B8B8B8;
                }
                .test-story-main .tds_title{
                    text-align:left;
                    margin-bottom:1%
                }
                .test-story-main h3{
                    text-align:center;
                }
                .test-story-main h2{
                    text-align:center;
                }
                .test-story-main h1{
                    text-align:center;
                }
                .test-story-main .tds_pgBrk{
                    page-break-after:always;
                }
                .test-story-main #er7Message table{
                    border:0px;
                    width:80%
                }
                .test-story-main #er7Message td{
                    background:#B8B8B8;
                    font-size:65%;
                    margin-top:6.0pt;
                    border:0px;
                    text-wrap:preserve-breaks;
                    white-space:pre;
                }
                .test-story-main .er7Msg{
                    width:100%;
                    font-size:80%;
                }
                .test-story-main .er7MsgNote{
                    width:100%;
                    font-style:italic;
                    font-size:80%;
                }
                .test-story-main .embSpace{
                    padding-left:15px;
                }
                .test-story-main .embSubSpace{
                    padding-left:25px;
                }
                .test-story-main .accordion-heading{
                    font-weight:bold;
                    font-size:90%;
                }
                .test-story-main .accordion-heading i.fa:after{
                    content:"\00a0 ";
                }
                .test-story-main panel{
                    margin:10px 5px 5px 5px;
                }
            }</style>
    </xsl:template>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:tags">
        <xsl:param name="tag"/>
        <xsl:param name="content"/>
        <xsl:param name="ind"/>
        <xsl:value-of select="concat($nl, $ind)"/>
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:value-of select="$tag"/>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        <xsl:value-of select="$content"/>
        <xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
        <xsl:value-of select="$tag"/>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    </xsl:function>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:tag">
        <xsl:param name="tag"/>
        <xsl:param name="ind"/>
        <xsl:value-of select="concat($nl, $ind)"/>
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:value-of select="$tag"/>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    </xsl:function>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:start">
        <xsl:param name="profile"/>
        <xsl:param name="div"/>
        <xsl:choose>
            <xsl:when test="$generate-plain-html">
                <!-- output version number and profile info at the start with the comment -->
                <xsl:variable name="comment-string">
                    <xsl:value-of select="'!-- generated by TestStory_v1.xslt Version:'"/>
                    <xsl:value-of select="$version"/>
                    <xsl:value-of select="'   Profile:'"/>
                    <xsl:value-of select="$profile"/>
                    <xsl:value-of select="'--'"/>
                </xsl:variable>
                <xsl:value-of select="util:tag($comment-string, '')"/>
                <xsl:value-of select="util:tag('fieldset', '')"/>
                <xsl:value-of select="util:tag(concat('div class=&quot;', $div, '&quot;'), '')"/>
                <!-- generate tabset outer block for angular -->
                <xsl:if test="$output = 'ng-tab-html'">
                    <xsl:value-of select="util:tag('tabset', '')"/>
                </xsl:if>
            </xsl:when>

        </xsl:choose>

    </xsl:function>

    <xsl:variable xmlns:xalan="http://xml.apache.org/xslt" name="indent" select="'&#x9;'"/>
    <xsl:variable xmlns:xalan="http://xml.apache.org/xslt" name="nl" select="'&#xA;'"/>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:title">
        <xsl:param name="name"/>
        <xsl:param name="tabname"/>
        <xsl:param name="value"/>
        <xsl:param name="ind"/>
        <xsl:param name="endprevioustable" as="xs:boolean"/>
        <xsl:param name="vertical-orientation" as="xs:boolean"/>
        <xsl:param name="full" as="xs:boolean"/>
        <xsl:variable name="prelude">
            <xsl:choose>
                <xsl:when test="$endprevioustable">
                    <xsl:choose>
                        <xsl:when test="$generate-plain-html">
                            <xsl:value-of select="util:tag('/table', $ind)"/>
                            <xsl:value-of select="util:tag('br/', $ind)"/>
                            <xsl:value-of select="util:end-tab($ind, $vertical-orientation)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($ind, '},', $nl)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$generate-plain-html">
                <xsl:if test="not($full)">
                    <xsl:value-of
                        select="util:begin-tab($tabname, $value, '', $vertical-orientation)"/>
                </xsl:if>
            </xsl:when>

        </xsl:choose>
    </xsl:function>


    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:begin-tab">
        <xsl:param name="tabname"/>
        <xsl:param name="val"/>
        <xsl:param name="ind"/>
        <xsl:param name="vertical-orientation" as="xs:boolean"/>
        <!-- use the tabname to convert into a valid javascript variable name that is used to track open and close of the accordions -->
        <xsl:variable name="isOpenVar" select="concat('xsl', replace($tabname, '[ \\-]', ''))"/>
        <xsl:choose>
            <xsl:when test="$output = 'ng-tab-html'">
                <xsl:value-of
                    select="util:tag(concat(util:IfThenElse($vertical-orientation, concat('accordion-group class=&quot;panel-info&quot; type=&quot;pills&quot; style=&quot;margin-top:0;border: 1px ridge  #C6DEFF;&quot; is-open=&quot;', $isOpenVar, '&quot; '), 'tab'), util:IfThenElse($vertical-orientation, '', concat(' heading=&quot;', $tabname, '&quot; ')), ' vertical=&quot;', $vertical-orientation, '&quot;'), '')"/>
                <xsl:if test="$vertical-orientation">
                    <xsl:value-of select="util:tag('accordion-heading', '')"/>
                    <xsl:value-of select="util:tag('span class=&quot;clearfix&quot;', '')"/>
                    <xsl:value-of
                        select="util:tag('span class=&quot;accordion-heading pull-left&quot;', '')"/>
                    <xsl:value-of
                        select="util:tag(concat('i class=&quot;pull-left fa&quot; ng-class=&quot;{''fa-caret-down'': ', $isOpenVar, ', ''fa-caret-right'': !', $isOpenVar, '}&quot;'), '')"/>
                    <xsl:value-of select="util:tag('/i', '')"/>
                    <xsl:value-of select="$tabname"/>
                    <xsl:value-of select="util:tag('/span', '')"/>
                    <xsl:value-of select="util:tag('/span', '')"/>
                    <xsl:value-of select="util:tag('/accordion-heading', '')"/>
                </xsl:if>

                <xsl:value-of select="util:tag('div class=&quot;panel-body&quot;', $ind)"/>

            </xsl:when>
            <xsl:when test="$output = 'plain-html'"> </xsl:when>
        </xsl:choose>
    </xsl:function>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:end-tab">
        <xsl:param name="ind"/>
        <xsl:param name="vertical-orientation" as="xs:boolean"/>
        <xsl:choose>
            <xsl:when test="$output = 'ng-tab-html'">


                <xsl:value-of select="util:tag('/div', '')"/>
                <xsl:value-of
                    select="util:tag(util:IfThenElse($vertical-orientation, '/accordion-group', '/tab'), '')"
                />
            </xsl:when>
            <xsl:when test="$output = 'plain-html'"> </xsl:when>
        </xsl:choose>
    </xsl:function>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:strip-tabsets">
        <xsl:param name="html"/>
        <xsl:variable name="pass1"
            select="replace($html, '&lt;tab heading=&quot;([^&quot;]*)&quot; *vertical=&quot;false&quot;>', '')"/>
        <xsl:variable name="pass2" select="replace($pass1, '&lt;/tab>', '')"/>

        <xsl:value-of
            select="replace(replace($pass2, '(&lt;tab heading=&quot;.*&quot;)', '&lt;div'), '(&lt;/tab>)|(&lt;/tabset>)', '&lt;/div>')"
        />
    </xsl:function>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:end">
        <xsl:param name="ind"/>
        <xsl:choose>
            <xsl:when test="$generate-plain-html">
                <xsl:if test="$output = 'ng-tab-html'">
                    <xsl:value-of select="util:tag('/tabset', '')"/>
                </xsl:if>
                <xsl:value-of select="util:tag('/div', $ind)"/>
                <xsl:value-of select="util:tag('/fieldset', '')"/>
            </xsl:when>

        </xsl:choose>
    </xsl:function>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:IfThenElse">
        <xsl:param name="cond" as="xs:boolean"/>
        <xsl:param name="ifData"/>
        <xsl:param name="ifNotData"/>
        <xsl:choose>
            <xsl:when test="$cond">
                <xsl:value-of select="$ifData"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$ifNotData"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function xmlns:xalan="http://xml.apache.org/xslt" name="util:segdesc">
        <xsl:param name="seg"/>
        <xsl:choose>
            <xsl:when test="$seg = 'teststorydesc'">
                <xsl:value-of select="'Description'"/>
            </xsl:when>
            <xsl:when test="$seg = 'comments'">
                <xsl:value-of select="'Comments'"/>
            </xsl:when>
            <xsl:when test="$seg = 'preCondition'">
                <xsl:value-of select="'Pre Condition'"/>
            </xsl:when>
            <xsl:when test="$seg = 'postCondition'">
                <xsl:value-of select="'Post Condition'"/>
            </xsl:when>
            <xsl:when test="$seg = 'testObjectives'">
                <xsl:value-of select="'Test Objectives'"/>
            </xsl:when>
            <xsl:when test="$seg = 'evaluationCriteria'">
                <xsl:value-of select="'Evaluation Criteria'"/>
            </xsl:when>
            <xsl:when test="$seg = 'notes'">
                <xsl:value-of select="'Notes for Testers'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
