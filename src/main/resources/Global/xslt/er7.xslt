<?xml version="1.0" encoding="UTF-8"?>
<!-- Generic transformation used to create er7 message as html -->
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="fn xs fn">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="windowLength" select="120"/>
	<xsl:param name="er7Message"/>
	<xsl:template match="/">
			<html>
			<head/>
			<body>
				<div class="hl7Message">
					<xsl:for-each select="tokenize($er7Message,'&#xD;')">
						<xsl:variable name="segment" select="."/>
						<xsl:variable name="length" select="string-length($segment)"/> 
						<xsl:if test="$length &gt;0">
							<p>
								<xsl:choose>
									<xsl:when test="$length &gt; $windowLength">
										<xsl:variable name="maxLength" select="xs:integer(string-length(.) div $windowLength)"/>
										<xsl:for-each select="1 to $maxLength + 1">
											<xsl:variable name="start" select="(position() -1) * $windowLength"/>
											<xsl:value-of select="substring($segment,$start,$windowLength)"/>
											<br/>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="."/>
										<br/>
									</xsl:otherwise>
								</xsl:choose>
							</p>
						</xsl:if>
					</xsl:for-each>
				</div>
			</body>
			</html>
	</xsl:template>
</xsl:stylesheet>