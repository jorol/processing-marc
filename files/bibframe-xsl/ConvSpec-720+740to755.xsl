<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for 720, 740-754
  -->

  <!-- Processing of 720 is handled in ConvSpec-1XX,6XX,7XX,8XX-names.xsl -->

  <!-- Processing of 740 is handled in ConvSpec-X30and240-UnifTitle.xsl -->

  <xsl:template match="marc:datafield[@tag='752' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='752')]" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="recordid"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vLabel">
      <xsl:call-template name="chopPunctuation">
        <xsl:with-param name="punctuation"><xsl:text>- </xsl:text></xsl:with-param>
        <xsl:with-param name="chopString">
          <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='f' or @code='g' or @code='h']">
            <xsl:value-of select="concat(.,'--')"/>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="vPlaceUri">
      <xsl:apply-templates mode="generateUri" select="."/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization='rdfxml'">
        <bf:place>
          <bf:Place>
            <xsl:if test="$vPlaceUri != ''">
              <xsl:attribute name="rdf:about"><xsl:value-of select="$vPlaceUri"/></xsl:attribute>
            </xsl:if>
            <rdf:type>
              <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($madsrdf,'HierarchicalGeographic')"/></xsl:attribute>
            </rdf:type>
            <rdfs:label><xsl:value-of select="$vLabel"/></rdfs:label>
            <madsrdf:componentList rdf:parseType="Collection">
              <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c' or @code='d' or @code='f' or @code='g' or @code='h']">
                <xsl:variable name="vResource">
                  <xsl:choose>
                    <xsl:when test="@code='a'">madsrdf:Country</xsl:when>
                    <xsl:when test="@code='b'">madsrdf:State</xsl:when>
                    <xsl:when test="@code='c'">madsrdf:County</xsl:when>
                    <xsl:when test="@code='d'">madsrdf:City</xsl:when>
                    <xsl:when test="@code='f'">madsrdf:CitySection</xsl:when>
                    <xsl:when test="@code='g'">madsrdf:Region</xsl:when>
                    <xsl:when test="@code='h'">madsrdf:ExtraterrestrialArea</xsl:when>
                  </xsl:choose>
                </xsl:variable>
                <xsl:element name="{$vResource}">
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                  </rdfs:label>
                </xsl:element>
              </xsl:for-each>
            </madsrdf:componentList>
            <xsl:for-each select="marc:subfield[@code='0' or @code='w'][starts-with(text(),'(uri)') or starts-with(text(),'http')]">
              <xsl:if test="position() != 1">
                <xsl:apply-templates mode="subfield0orw" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='0' or @code='w']">
              <xsl:if test="substring(text(),1,5) != '(uri)' and substring(text(),1,4) != 'http'">
                <xsl:apply-templates mode="subfield0orw" select=".">
                  <xsl:with-param name="serialization" select="$serialization"/>
                </xsl:apply-templates>
              </xsl:if>
            </xsl:for-each>
            <xsl:apply-templates select="marc:subfield[@code='2']" mode="subfield2">
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="marc:subfield[@code='e']" mode="contributionRole">
              <xsl:with-param name="pMode">relationship</xsl:with-param>
              <xsl:with-param name="pRelatedTo"><xsl:value-of select="$recordid"/>#Work</xsl:with-param>
              <xsl:with-param name="serialization" select="$serialization"/>
            </xsl:apply-templates>
            <xsl:for-each select="marc:subfield[@code='4']">
              <xsl:variable name="encoded">
                <xsl:call-template name="url-encode">
                  <xsl:with-param name="str" select="normalize-space(substring(.,1,3))"/>
                </xsl:call-template>
              </xsl:variable>
              <bflc:relationship>
                <bflc:Relationship>
                  <bflc:relation>
                    <bflc:Relation>
                      <xsl:attribute name="rdf:about"><xsl:value-of select="concat($relators,$encoded)"/></xsl:attribute>
                    </bflc:Relation>
                  </bflc:relation>
                  <bf:relatedTo>
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$recordid"/>#Work</xsl:attribute>
                  </bf:relatedTo>
                </bflc:Relationship>
              </bflc:relationship>
            </xsl:for-each>
          </bf:Place>
        </bf:place>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='753' or (@tag='880' and substring(marc:subfield[@code='6'],1,3)='753')]" mode="instance">
    <xsl:param name="serialization" select="$serialization"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:for-each select="marc:subfield[@code='a' or @code='b' or @code='c']">
          <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
          <xsl:variable name="vCurrentNodeUri">
            <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
              <xsl:if test="position() = 1">
                <xsl:choose>
                  <xsl:when test="starts-with(.,'(uri)')">
                    <xsl:value-of select="substring-after(.,'(uri)')"/>
                  </xsl:when>
                  <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
                </xsl:choose>
              </xsl:if>
            </xsl:for-each>
          </xsl:variable>
          <xsl:variable name="vResource">
            <xsl:choose>
              <xsl:when test="@code='a'">bflc:MachineModel</xsl:when>
              <xsl:when test="@code='b'">bflc:ProgrammingLanguage</xsl:when>
              <xsl:when test="@code='c'">bflc:OperatingSystem</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <bf:systemRequirement>
            <xsl:element name="{$vResource}">
              <xsl:if test="$vCurrentNodeUri != ''">
                <xsl:attribute name="rdf:about"><xsl:value-of select="$vCurrentNodeUri"/></xsl:attribute>
              </xsl:if>
              <rdfs:label>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:value-of select="."/>
              </rdfs:label>
              <xsl:for-each select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and contains(text(),'://')]">
                <xsl:if test="position() != 1">
                  <xsl:apply-templates select="." mode="subfield0orw">
                    <xsl:with-param name="serialization" select="$serialization"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
              <xsl:apply-templates select="following-sibling::marc:subfield[@code='0' and generate-id(preceding-sibling::marc:subfield[@code != '0'][1])=$vCurrentNode and not(contains(text(),'://'))]" mode="subfield0orw">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="../marc:subfield[@code='2']" mode="subfield2">
                <xsl:with-param name="serialization" select="$serialization"/>
              </xsl:apply-templates>
            </xsl:element>
          </bf:systemRequirement>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
