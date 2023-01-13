<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:f="http://functions" xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.loc.gov/MARC21/slim https://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"
    exclude-result-prefixes="f marc xs">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0" name="unprefixed"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0" name="prefixed"/>

    <xsl:include href="NAL-MARC21slimUtils.xsl"/>
  
    <!-- Purpose: Adds marc:prefixes and MARCXML Schema Validation-->
    
    <xsl:template match="/">
        <xsl:variable name="in-xml" select="descendant::node()" as="node()*"/>    
        
        <xsl:for-each select="//collection">
            <xsl:result-document method="xml" encoding="UTF-8" version="1.0" format="prefixed"
                href="{replace(base-uri(), '(.*/)(.*)(\.xml|\.json)','$1')}N-{replace(base-uri(), '(.*/)(.*)(\.xml|\.json)','$2')}_{'non-prefixed'}_{position()}.xml">
            <collection>
                <xsl:copy-of select="."/>
            </collection>
       
            </xsl:result-document>
            <!--for unprefixed-->
                <xsl:result-document method="xml" encoding="UTF-8" version="1.0" format="prefixed"
                    href="{replace(base-uri(), '(.*/)(.*)(\.xml|\.json)','$1')}N-{replace(base-uri(), '(.*/)(.*)(\.xml|\.json)','$2')}_{'prefixed'}_{position()}.xml">                
             <marc:collection>
                <xsl:namespace name="marc">http://www.loc.gov/MARC21/slim</xsl:namespace>
                <xsl:namespace name="xs">http://www.w3.org/2001/XMLSchema</xsl:namespace>
                <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:attribute 
                    name="xsi:schemaLocation" 
                    select="normalize-space(
                    'http://www.loc.gov/MARC21/slim
                    https://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd')
                    "/>
                 <xsl:copy-of select="f:change-element-ns-deep(
                     $in-xml, 
                     'http://www.loc.gov/MARC21/slim',
                     'marc')
                     "/>
                </marc:collection>
                </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <!--identity template-->
    <xsl:template match="node() | @*">
        <xsl:copy-of select="node() | @*"/>
    </xsl:template>



</xsl:stylesheet>
