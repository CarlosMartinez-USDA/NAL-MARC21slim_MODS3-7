<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.loc.gov/mods/v3" xmlns:f="http://functions"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:marccountry="http://www.local.gov/marc/countries"
    xmlns:nalsubcat="http://nal-subject-category-codes" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="f marc marccountry nalsubcat saxon xd xlink xs xsi">


    <!-- includes -->

    <xsl:include href="NAL-MARC21slimUtils.xsl"/>
    <xsl:include href="commons/functions.xsl"/>
    <xsl:include href="commons/params.xsl"/>

    <!-- outputs -->

    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="saxon"
        saxon:next-in-chain="fix_characters.xsl"/>

    <!-- whitespace control -->
    <xsl:strip-space elements="*"/>


    <!-- Maintenance note: For each revision, change the content of <recordInfo><recordOrigin> to reflect the new revision number.
	MARC21slim2MODS3-7
	
	┌ ━ ━ ━ ━ ━ ┐ 
	│ MODS 3.7 │  
	└ ━ ━ ━ ━ ━ ┘
	Revision 1.170 - Added $controlField008-0-14 variable to get correct dates is "w3cdtf" format 20221123 cm3
	Revision 1.169 - Added $this variables to <title>, <subtitle>, <abstract>, <relatedItem><title> , etc. (any lenthy text field to resolve MODS Schema whitespace error. 20230108 cm3
	Revision 1.168 - Removed 778 from 76X-78X template, added 914 for local identifier, "agid:" number 20230108 cm3
	Revision 1.167 - Custom function f:decodeMARCCountry($marcCode) returns the country/state name
	Revision 1.166 - Filters 008 field for 2 or 3 letter country/state codes 
	Revision 1.165 - Remnamed displayForm template, added specialSubfieldSelect from 1.164 as variable, parsed it as output. 20230106 cm3
	Revision 1.164 - Removed specialSubfieldSelect template. 20230106 cm3
	Revision 1.163 - "agid:" mapped from createNoteFrom974 into local identifier; removed from extension. 20220105 cm3
	Revision 1.162 - NAL control number mapped to local idenfifer. 20230105 cm3
	Revision 1.161 - NAL Agricola accession number (e.g.,CAT87882125). 20230105 cm3		
	Revision 1.160 - NAL Classification number. 20230104 cm3
	Revision 1.159 - Added if test to prevent extra whitespace. 2022/12/23 cm3
	Revision 1.158 - Added conditional statement above issuance to focus on monographs, single part items and multipart monographs cm3 12/08/2022
	Revision 1.157 - Added condtional statement if agid:# is empty from 773, use 914 subfield a cm3 12/09/2022
	Revision 1.156 - Added condtional statement if ISSN is empty from 773, use 914 subfield b cm3 12/09/2022
    Revision 1.155 - Added custom function to map category code to subject. cm3 2022/12/08
    Revision 1.154 - Commented out conditional statements within issuance element for serials, contininuing resources, and integrating resources. cm3 2022/12/08	
    Revision 1.153 - Used subtring-before function to get subfield b (ie., publisher) and subfield c (i.e., dateIssued). cm3 2022/12/08
	Revision 1.152 - Added conditional statement outside of issuance element to allow monographs, multipart monographs, and single items only. cm3 2022/12/08 
	Revision 1.151 - $controlField008-35-37replace, uses replace function and regex to capture 3 letter string. cm3 2022/12/05
	Revision 1.150 - Updated recordOrigin to reflect the XSLT filename Used in transform. cm3 2022/12/08
	Revision 1.149 - Added if tests to originInfo producer elements to avoid empty tag cm3 2022/11/10
	Revision 1.148 - Used analyze-string function 008 to pull out 2-3 letter text and apply custom marc country conversion function
	Revision 1.147 - Removed  prefix from XSLT to accomodate prefix-less elements from Alma 
	Revision 1.146 - Upgraded stylesheet to use XSLT 2.0 cm3 2022/10/05 
	Revision 1.145 - Fixed dateIssued to include year only date from the 008  JG 2014/12/16
	Revision 1.144 - Fixed dateIssued to include month and date from the 008  JG 2014/08/18
	Revision 1.143 - Added displayForm to 700 JG 2014/05/29
	Revision 1.141 - Added subject from 072, classification from 070, identifier from 024, identifier from 001, and notes from 910, 930, 945, 946, 974 LC 2014/04/23
	┌ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ┐ 
	│  NAL Revisions (Revision 1.160) 20230104      |    
	└ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ┘ 
	┌ ━ ━ ━ ━ ━ ┐ 
	│ MODS 3.6  │  
	└ ━ ━ ━ ━ ━ ┘ 
	Revision 1.140 - Fixed admin metadata - XSLT was referencing MODS 3.6 - 2020/07/17 - tmee
	Revision 1.139 - Update to MODS v.3.7 - 2020/02/13 ws
	Revision 1.138 - Update output to notes fields for 500. - 2020/01/06 ws
	Revision 1.137 - Add displayLabel to tableOfContents. - 2020/01/06 ws
	Revision 1.136 - Update language objectPart to match mapping. - 2020/01/06 ws
	Revision 1.135 - Add 588 to notes. - 2020/01/06 ws
	Revision 1.134 - Update dates to match mapping. - 2020/01/06 ws
	Revision 1.133 - Update placeTerm to match mapping. - 2020/01/06 ws
	Revision 1.132 - Remove xlink from 655, icorrect mapping. - 2020/01/06 ws
	Revision 1.131 - Fix bug in 730[@ind2!=2]/880[@ind2!=2] output . - 2020/01/06 ws
	Revision 1.130 - Update originInfo altRepGroup and subfields. - 2020/01/06 ws
	Revision 1.129 - Update physicalDescription altRepGroup. - 2020/01/06 ws
	Revision 1.128 - Bug fix for 260$c altRepGroup output, strip punctuation. - 2019/12/27 ws 
	Revision 1.127 - Add 521 displayLabel based on mapping. - 2019/12/27 ws
	Revision 1.126 - Consistent handling of punctiaion in name elements, 100/700/110/710 - 2019/12/02 ws 
	Revision 1.125 - Correct partNumber output for 710,711,810,811 $n after $t  - 2019/11/22 ws
	Revision 1.124 - Correct incorrect type attribute on 520/abstract. Should be @displayLabel, not @type. - 2019/11/22 ws
	Revision 1.123 - Correct bugs in @nameTitleGroup - 2019/11/22 ws
	Revision 1.122 - Add xlink for 6XX, 130, 240, 730, 100, 700, 110, 710, 111, 711, 655  - 2019/11/22 ws
	Revision 1.121 - Update 880 subfield 6 output to better reflect mapping. - 2019/11/20 ws
	Revision 1.120 - Update relatedItems output to better match mapping. See specific changes below. - 2019/11/20 ws
						1.120 - @76X-78X$g adds subfield g as partNumber
						1.120 - @76X-78X$z add isbn identifier
						1.120 - @76X-78X$i add displayLabel
						1.120 - @762@type fix 762 type
						1.120 - @775@type test for ind2
						1.120 - @777 add all fields for 777 relatedItem output
						1.120 - @787 add all fields for 787 relatedItem output
						1.120 - @800$0 add $0 xlink="contents of $0" as URI 800,810, 811, 830
						1.120 - @800$v a1.120 - @787dd partNumber 800,810, 811, 830 
						1.120 - @711$v $v incorrectly added to title in 710,711 and 730
						1.120 - @711$4 add role and roleTerm
						1.120 - @510$ind1 add ind1 conditions
						1.120 - @534$ind1 add ind1 conditions
						1.120 - @440$ind1 add ind1 conditions
						1.120 - @440$a$v fix subfield output
						1.120 - @440$a$v add conditions
						1.120 - @490$ind1 add ind1 conditions
						1.120 - @490$v add partNumber
						1.120 - @830$v add partNumber
						1.120 - @856@ind2=2$q added physicalDescription tag
						1.120 - @245/@880$ind2 - fix nonSort bugs
						1.120 - @246/ind2=1 fix type to translated
						1.120 - @264/ind2 fix mapping
						1.120 - @260$issuance make conditional so no empty issuance elements can be output
	Revision 1.119 - Fixed 700 ind1=0 to transform - tmee 2018/06/21
	Revision 1.118 - Fixed namePart termsOfAddress subelement order - 2018/01/31 tmee
	Revision 1.117 - Fixed name="corporate" RE: MODS 3.6 - 2017/2/14 tmee
	Revision 1.116 - Added nameIdentifier to 700/710/711/100/110/111 $0 RE: MODS 3.6 - 2016/3/15 ws
	Revision 1.115 - Added @otherType for 7xx RE: MODS 3.6 - 2016/3/15 ws
	Revision 1.114 - Added <itemIdentifier> for 852$p and <itemIdentifier > with type="copy number" for 852$t RE: MODS 3.6 - 2016/3/15 ws
	Revision 1.113 - Added @valueURI="contents of $0" for 752/662 RE: MODS 3.6 - 2016/3/15 ws
	Revision 1.112 - Added @xml:space="preserve" to title/nonSort on 245 and 242 RE: MODS 3.6 - 2016/3/15 ws
	
	Revision 1.111 - Added test to prevent empty authority attribute for 047 with no subfield 2. - ws 2016/03/24
	Revision 1.110 - Added test to prevent empty authority attribute for 336 with no subfield 2. - ws 2016/03/24
	Revision 1.109 - Added test to prevent empty authority attribute for 655 and use if ind2 if no subfield 2 is available. - ws 2016/03/24
	Revision 1.108 - Added filter to name templates to exclude names with title subfields. - ws 2016/03/24
	
	Revision 1.107 - Added support for 024/@ind1=7 - ws 2016/1/7	
	Revision 1.106 - Added a xsl:when to deal with '#' and ' ' in $marcLeader19 and $controlField008-18 - ws 2014/12/19		
	Revision 1.105 - Add @unit to extent - ws 2014/11/20	
	Revision 1.104 - Fixed 111$n and 711$n to reflect mapping to <namePart> tmee 20141112
	Revision 1.103 - Fixed 008/28 to reflect revised mapping for government publication tmee 20141104	
	Revision 1.102 - Fixed 240$s duplication tmee 20140812
	Revision 1.101 - Fixed 130 tmee 20140806
	Revision 1.100 - Fixed 245c tmee 20140804
	Revision 1.99 - Fixed 240 issue tmee 20140804
	Revision 1.98 - Fixed 336 mapping tmee 20140522
	Revision 1.97 - Fixed 264 mapping tmee 20140521
	Revision 1.96 - Fixed 310 and 321 and 008 frequency authority for marcfrequency tmee 2014/04/22
	Revision 1.95 - Modified 035 to include identifier type (WlCaITV) tmee 2014/04/21	
	Revision 1.94 - Leader 07 b changed mapping from continuing to serial tmee 2014/02/21
	┌ ━ ━ ━ ━ ━ ┐ 
	│ MODS 3.5 │  
	└ ━ ━ ━ ━ ━ ┘
	Revision 1.95 - Added a xsl:when to deal with '#' and ' ' in $marcLeader19 and $controlField008-18 - ws 2014/12/19
	Revision 1.94 - Leader 07 b mapping changed from "continuing" to "serial" tmee 2014/02/21
	Revision 1.93 - Fixed personal name transform for ind1=0 tmee 2014/01/31
	Revision 1.92 - Removed duplicate code for 856 1.51 tmee 2014/01/31
	Revision 1.91 - Fixed createnameFrom720 duplication tmee 2014/01/31
	Revision 1.90 - Fixed 520 displayLabel tmee tmee 2014/01/31
	Revision 1.89 - Fixed 008-06 when value = 's' for cartographics tmee tmee 2014/01/31
	Revision 1.88 - Fixed 510c mapping - tmee 2013/08/29
	Revision 1.87 - Fixed expressions of <accessCondition> type values - tmee 2013/08/29
	Revision 1.86 - Fixed 008 <frequency> subfield to occur w/i <originiInfo> - tmee 2013/08/29
	Revision 1.85 - Fixed 245$c - tmee 2013/03/07
	Revision 1.84 - Fixed 1.35 and 1.36 date mapping for 008 when 008/06=e,p,r,s,t so only 008/07-10 displays, rather than 008/07-14 - tmee 2013/02/01   
	Revision 1.83 - Deleted mapping for 534 to note - tmee 2013/01/18
	Revision 1.82 - Added mapping for 264 ind 0,1,2,3 to originInfo - 2013/01/15 tmee
	Revision 1.81 - Added mapping for 336$a$2, 337$a$2, 338$a$2 - 2012/12/03 tmee
	Revision 1.80 - Added 100/700 mapping for "family" - 2012/09/10 tmee
	Revision 1.79 - Added 245 $s mapping - 2012/07/11 tmee
	Revision 1.78 - Fixed 852 mapping <shelfLocation> was changed to <shelfLocator> - 2012/05/07 tmee
	Revision 1.77 - Fixed 008-06 when value = 's' - 2012/04/19 tmee
	Revision 1.76 - Fixed 242 - 2012/02/01 tmee
	Revision 1.75 - Fixed 653 - 2012/01/31 tmee
	Revision 1.74 - Fixed 510 note - 2011/07/15 tmee
	Revision 1.73 - Fixed 506 540 - 2011/07/11 tmee
	Revision 1.72 - Fixed frequency error - 2011/07/07 and 2011/07/14 tmee
	Revision 1.71 - Fixed subject titles for subfields t - 2011/04/26 tmee 
	Revision 1.70 - Added mapping for OCLC numbers in 035s to go into <identifier type="oclc"> 2011/02/27 - tmee 	
	Revision 1.69 - Added mapping for untyped identifiers for 024 - 2011/02/27 tmee 
	Revision 1.68 - Added <subject><titleInfo> mapping for 600/610/611 subfields t,p,n - 2010/12/22 tmee
	Revision 1.67 - Added frequency values and authority="marcfrequency" for 008/18 - 2010/12/09 tmee
	Revision 1.66 - Fixed 008/06=c,d,i,m,k,u, from dateCreated to dateIssued - 2010/12/06 tmee
	Revision 1.65 - Added back marcsmd and marccategory for 007 cr- 2010/12/06 tmee
	Revision 1.64 - Fixed identifiers - removed isInvalid template - 2010/12/06 tmee
	Revision 1.63 - Fixed descriptiveStandard value from aacr2 to aacr - 2010/12/06 tmee
	Revision 1.62 - Fixed date mapping for 008/06=e,p,r,s,t - 2010/12/01 tmee
	Revision 1.61 - Added 007 mappings for marccategory - 2010/11/12 tmee
	Revision 1.60 - Added altRepGroups and 880 linkages for relevant fields, see mapping - 2010/11/26 tmee
	Revision 1.59 - Added scriptTerm type=text to language for 546b and 066c - 2010/09/23 tmee
	Revision 1.58 - Expanded script template to include code conversions for extended scripts - 2010/09/22 tmee
	Revision 1.57 - Added Ldr/07 and Ldr/19 mappings - 2010/09/17 tmee
	Revision 1.56 - Mapped 1xx usage="primary" - 2010/09/17 tmee
	Revision 1.55 - Mapped UT 240/1xx nameTitleGroup - 2010/09/17 tmee
	┌ ━ ━ ━ ━ ━ ┐ 
	│ MODS 3.4 │  
	└ ━ ━ ━ ━ ━ ┘
	Revision 1.54 - Fixed 086 redundancy - 2010/07/27 tmee
	Revision 1.53 - Added direct href for MARC21slimUtils - 2010/07/27 tmee
	Revision 1.52 - Mapped 046 subfields c,e,k,l - 2010/04/09 tmee
	Revision 1.51 - Corrected 856 transform - 2010/01/29 tmee
	Revision 1.50 - Added 210 $2 authority attribute in <titleInfo type=”abbreviated”> 2009/11/23 tmee
	Revision 1.49 - Aquifer revision 1.14 - Added 240s (version) data to <titleInfo type="uniform"><xsl:variable name="this">
 2009/11/23 tmee
	Revision 1.48 - Aquifer revision 1.27 - Added mapping of 242 second indicator (for nonfiling characters) to <titleInfo><nonSort > subelement  2007/08/08 tmee/dlf
	Revision 1.47 - Aquifer revision 1.26 - Mapped 300 subfield f (type of unit) - and g (size of unit) 2009 ntra
	Revision 1.46 - Aquifer revision 1.25 - Changed mapping of 767 so that <type="otherVersion>  2009/11/20  tmee
	Revision 1.45 - Aquifer revision 1.24 - Changed mapping of 765 so that <type="otherVersion>  2009/11/20  tmee 
	Revision 1.44 - Added <recordInfo><recordOrigin> canned text about the version of this stylesheet 2009 ntra
	Revision 1.43 - Mapped 351 subfields a,b,c 2009/11/20 tmee
	Revision 1.42 - Changed 856 second indicator=1 to go to <location><url displayLabel=”electronic resource”> instead of to <relatedItem type=”otherVersion”><url> 2009/11/20 tmee
	Revision 1.41 - Aquifer revision 1.9 Added variable and choice protocol for adding usage=”primary display” 2009/11/19 tmee 
	Revision 1.40 - Dropped <note> for 510 and added <relatedItem type="isReferencedBy"> for 510 2009/11/19 tmee
	Revision 1.39 - Aquifer revision 1.23 Changed mapping for 762 (Subseries Entry) from <relatedItem type="series"> to <relatedItem type="constituent"> 2009/11/19 tmee
	Revision 1.38 - Aquifer revision 1.29 Dropped 007s for electronic versions 2009/11/18 tmee
	Revision 1.37 - Fixed date redundancy in output (with questionable dates) 2009/11/16 tmee
	Revision 1.36 - If mss material (Ldr/06=d,p,f,t) map 008 dates and 260$c/$g dates to dateCreated 2009/11/24, otherwise map 008 and 260$c/$g to dateIssued 2010/01/08 tmee
	Revision 1.35 - Mapped appended detailed dates from 008/07-10 and 008/11-14 to dateIssued or DateCreated w/encoding="marc" 2010/01/12 tmee
	Revision 1.34 - Mapped 045b B.C. and C.E. date range info to iso8601-compliant dates in <subject><temporal> 2009/01/08 ntra
	Revision 1.33 - Mapped Ldr/06 "o" to <typeOfResource>kit 2009/11/16 tmee
	Revision 1.32 - Mapped specific note types from the MODS Note Type list <http://www.loc.gov/standards/mods/mods-notes.html> tmee 2009/11/17
	Revision 1.31 - Mapped 540 to <accessCondition type="use and reproduction"> and 506 to <accessCondition type="restriction on access"> and delete mappings of 540 and 506 to <note>
	Revision 1.30 - Mapped 037c to <identifier displayLabel=""> 2009/11/13 tmee
	Revision 1.29 - Corrected schemaLocation to 3.3 2009/11/13 tmee
	Revision 1.28 - Changed mapping from 752,662 g going to mods:hierarchicalGeographic/area instead of "region" 2009/07/30 ntra
	Revision 1.27 - Mapped 648 to <subject> 2009/03/13 tmee
	Revision 1.26 - Added subfield $s mapping for 130/240/730  2008/10/16 tmee
	Revision 1.25 - Mapped 040e to <descriptiveStandard> and Leader/18 to <descriptive standard>aacr2  2008/09/18 tmee
	Revision 1.24 - Mapped 852 subfields $h, $i, $j, $k, $l, $m, $t to <shelfLocation> and 852 subfield $u to <physicalLocation> with @xlink 2008/09/17 tmee
	Revision 1.23 - Commented out xlink/uri for subfield 0 for 130/240/730, 100/700, 110/710, 111/711 as these are currently unactionable  2008/09/17 tmee
	Revision 1.22 - Mapped 022 subfield $l to type "issn-l" subfield $m to output identifier element with corresponding @type and @invalid eq 'yes'2008/09/17 tmee
	Revision 1.21 - Mapped 856 ind2=1 or ind2=2 to <relatedItem><location><url>  2008/07/03 tmee
	Revision 1.20 - Added genre w/@auth="contents of 2" and type= "musical composition"  2008/07/01 tmee
	Revision 1.19 - Added genre offprint for 008/24+ BK code 2  2008/07/01  tmee
	Revision 1.18 - Added xlink/uri for subfield 0 for 130/240/730, 100/700, 110/710, 111/711  2008/06/26 tmee
	Revision 1.17 - Added mapping of 662 2008/05/14 tmee	
	Revision 1.16 - Changed @authority from "marc" to "marcgt" for 007 and 008 codes mapped to a term in <genre> 2007/07/10 tmee
	Revision 1.15 - For field 630, moved call to part template outside title element  2007/07/10 tmee
	Revision 1.14 - Fixed template isValid and fields 010, 020, 022, 024, 028, and 037 to output additional identifier elements with corresponding @type and @invalid eq 'yes' when subfields z or y (in the case of 022) exist in the MARCXML ::: 2007/01/04 17:35:20 cred
	Revision 1.13 - Changed order of output under cartographics to reflect schema  2006/11/28 tmee
	Revision 1.12 - Updated to reflect MODS 3.2 Mapping  2006/10/11 tmee
	Revision 1.11 - The attribute objectPart moved from <languageTerm> to <language>  2006/04/08  jrad
	Revision 1.10 - MODS 3.1 revisions to language and classification elements (plus ability to find collection embedded in wrapper elements such as SRU zs: wrappers)  2006/02/06  ggar
	Revision 1.09 - Subfield $y was added to field 242 2004/09/02 10:57 jrad
	Revision 1.08 - Subject chopPunctuation expanded and attribute fixes 2004/08/12 jrad
	Revision 1.07 - 2004/03/25 08:29 jrad
	Revision 1.06 - Various validation fixes 2004/02/20 ntra
	Revision 1.05 - MODS2 to MODS3 updates, language unstacking and de-duping, chopPunctuation expanded  2003/10/02 16:18:58  ntra
	Revision 1.03 - Additional Changes not related to MODS Version 2.0 by ntra
	Revision 1.02 - Added Log Comment  2003/03/24 19:37:42  ckeith
	-->
    <!--href="{replace(saxon:system-id(),'(.*/)(.*)(\.xml)','$1')}N-{replace(saxon:system-id(),'(.*/)(.*)(\.xml)','$2')}_{position()}.xml">-->

    <xd:doc id="root" scope="stylesheet">
        <xd:desc>Processes the marcRecord template</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:result-document encoding="UTF-8" version="1.0" method="xml" media-type="text/xml"
            indent="yes" format="saxon"
            href="file:///{$workingDir}N-{replace($originalFilename,'(.*/)(.*)(\.xml)','$2')}_{position()}.xml">
            <xsl:choose>
                <xsl:when test="//collection/record">
                    <modsCollection xmlns:mods="http://www.loc.gov/mods/v3"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                        <xsl:for-each select="//collection/record">
                            <mods xmlns:mods="http://www.loc.gov/mods/v3" version="3.7">
                                <xsl:call-template name="marcRecord"/>
                            </mods>
                        </xsl:for-each>
                    </modsCollection>
                </xsl:when>
                <xsl:otherwise>
                    <mods xmlns:mods="http://www.loc.gov/mods/v3"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd"
                        version="3.7">
                        <xsl:for-each select="//record">
                            <xsl:call-template name="marcRecord"/>
                        </xsl:for-each>
                    </mods>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:result-document>
    </xsl:template>
    <xd:doc id="marcRecord" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="marcRecord">
        <xsl:variable name="marcLeader" select="leader"/>
        <xsl:variable name="marcLeader6" select="substring($marcLeader, 7, 1)"/>
        <xsl:variable name="marcLeader7" select="substring($marcLeader, 8, 1)"/>
        <xsl:variable name="marcLeader19" select="substring($marcLeader, 20, 1)"/>
        <xsl:variable name="controlField008" select="controlfield[@tag = '008']"/>
        <xsl:variable name="typeOf008">
            <xsl:choose>
                <xsl:when test="$marcLeader6 = 'a'">
                    <xsl:choose>
                        <xsl:when
                            test="$marcLeader7 = 'a' or $marcLeader7 = 'c' or $marcLeader7 = 'd' or $marcLeader7 = 'm'"
                            >BK</xsl:when>
                        <xsl:when
                            test="$marcLeader7 = 'b' or $marcLeader7 = 'i' or $marcLeader7 = 's'"
                            >SE</xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$marcLeader6 = 't'">BK</xsl:when>
                <xsl:when test="$marcLeader6 = 'p'">MM</xsl:when>
                <xsl:when test="$marcLeader6 = 'm'">CF</xsl:when>
                <xsl:when test="$marcLeader6 = 'e' or $marcLeader6 = 'f'">MP</xsl:when>
                <xsl:when
                    test="$marcLeader6 = 'g' or $marcLeader6 = 'k' or $marcLeader6 = 'o' or $marcLeader6 = 'r'"
                    >VM</xsl:when>
                <xsl:when
                    test="$marcLeader6 = 'c' or $marcLeader6 = 'd' or $marcLeader6 = 'i' or $marcLeader6 = 'j'"
                    >MU</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <!-- titleInfo -->
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '245'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '245')]">
            <xsl:call-template name="createTitleInfoFrom245"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '210'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '210')]">
            <xsl:call-template name="createTitleInfoFrom210"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '246'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '246')]">
            <xsl:call-template name="createTitleInfoFrom246"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '240'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '240')]">
            <xsl:call-template name="createTitleInfoFrom240"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '740'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '740')]">
            <xsl:call-template name="createTitleInfoFrom740"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '130'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '130')]">
            <xsl:call-template name="createTitleInfoFrom130"/>
        </xsl:for-each>
        <!-- 1.121, 1.131-->
        <xsl:for-each
            select="datafield[@tag = '730'][@ind2 != '2'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '730')][@ind2 != '2']">
            <xsl:call-template name="createTitleInfoFrom730"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '242']">
            <titleInfo type="translated">

                <!--09/01/04 Added subfield $y-->
                <xsl:for-each select="subfield[@code = 'y']">
                    <xsl:attribute name="lang">
                        <xsl:value-of select="text()"/>
                    </xsl:attribute>
                </xsl:for-each>

                <!-- AQ1.27 tmee/dlf -->
                <xsl:variable name="title">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="subfieldSelect">
                                <!-- 1/04 removed $h, b -->
                                <xsl:with-param name="codes">a</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="titleChop">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="$title"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <!-- 1.120 - @245/@880$ind2-->
                    <xsl:when test="@ind2 != ' ' and @ind2 &gt; 0">
                        <!-- 1.112 -->
                        <nonSort xml:space="preserve"><xsl:value-of select="substring($titleChop, 1, @ind2)"/> </nonSort>
                        <title>
                            <xsl:value-of select="normalize-space(substring($titleChop, @ind2 + 1))"
                            />
                        </title>
                    </xsl:when>
                    <xsl:otherwise>
                        <title>
                            <xsl:value-of select="normalize-space($titleChop)"/>
                        </title>
                    </xsl:otherwise>
                </xsl:choose>

                <!-- 1/04 fix -->
                <xsl:call-template name="subtitle"/>
                <xsl:call-template name="part"/>
            </titleInfo>
        </xsl:for-each>

        <!-- name -->
        <!-- 1.121 -->
        <!-- 1.108  -->
        <xsl:for-each
            select="datafield[@tag = '100'][not(subfield[@code = 't'])] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '100')][not(subfield[@code = 't'])]">
            <xsl:call-template name="createNameFrom100"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '110'][not(subfield[@code = 't'])] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '110')][not(subfield[@code = 't'])]">
            <xsl:call-template name="createNameFrom110"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '111'][not(subfield[@code = 't'])] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '111')][not(subfield[@code = 't'])]">
            <xsl:call-template name="createNameFrom111"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '700'][not(subfield[@code = 't'])] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '700')][not(subfield[@code = 't'])]">
            <xsl:call-template name="createNameFrom700"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '710'][not(subfield[@code = 't'])] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '710')][not(subfield[@code = 't'])]">
            <xsl:call-template name="createNameFrom710"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '711'][not(subfield[@code = 't'])] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '711')][not(subfield[@code = 't'])]">
            <xsl:call-template name="createNameFrom711"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '720'][not(subfield[@code = 't'])] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '720')][not(subfield[@code = 't'])]">
            <xsl:call-template name="createNameFrom720"/>
        </xsl:for-each>

        <typeOfResource>
            <xsl:if test="$marcLeader7 = 'c'">
                <xsl:attribute name="collection">yes</xsl:attribute>
            </xsl:if>
            <xsl:if
                test="$marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't'">
                <xsl:attribute name="manuscript">yes</xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$marcLeader6 = 'a' or $marcLeader6 = 't'">text</xsl:when>
                <xsl:when test="$marcLeader6 = 'e' or $marcLeader6 = 'f'">cartographic</xsl:when>
                <xsl:when test="$marcLeader6 = 'c' or $marcLeader6 = 'd'">notated music</xsl:when>
                <xsl:when test="$marcLeader6 = 'i'">sound recording-nonmusical</xsl:when>
                <xsl:when test="$marcLeader6 = 'j'">sound recording-musical</xsl:when>
                <xsl:when test="$marcLeader6 = 'k'">still image</xsl:when>
                <xsl:when test="$marcLeader6 = 'g'">moving image</xsl:when>
                <xsl:when test="$marcLeader6 = 'r'">three dimensional object</xsl:when>
                <xsl:when test="$marcLeader6 = 'm'">software, multimedia</xsl:when>
                <xsl:when test="$marcLeader6 = 'p'">mixed material</xsl:when>
            </xsl:choose>
        </typeOfResource>
        <xsl:if test="substring($controlField008, 26, 1) = 'd'">
            <genre authority="marcgt">globe</genre>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'r']">
            <genre authority="marcgt">remote-sensing image</genre>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'MP'">
            <xsl:variable name="controlField008-25" select="substring($controlField008, 26, 1)"/>
            <xsl:choose>
                <xsl:when
                    test="$controlField008-25 = 'a' or $controlField008-25 = 'b' or $controlField008-25 = 'c' or controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'j']">
                    <genre authority="marcgt">map</genre>
                </xsl:when>
                <xsl:when
                    test="$controlField008-25 = 'e' or controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'd']">
                    <genre authority="marcgt">atlas</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'SE'">
            <xsl:variable name="controlField008-21" select="substring($controlField008, 22, 1)"/>
            <xsl:choose>
                <xsl:when test="$controlField008-21 = 'd'">
                    <genre authority="marcgt">database</genre>
                </xsl:when>
                <xsl:when test="$controlField008-21 = 'l'">
                    <genre authority="marcgt">loose-leaf</genre>
                </xsl:when>
                <xsl:when test="$controlField008-21 = 'm'">
                    <genre authority="marcgt">series</genre>
                </xsl:when>
                <xsl:when test="$controlField008-21 = 'n'">
                    <genre authority="marcgt">newspaper</genre>
                </xsl:when>
                <xsl:when test="$controlField008-21 = 'p'">
                    <genre authority="marcgt">periodical</genre>
                </xsl:when>
                <xsl:when test="$controlField008-21 = 'w'">
                    <genre authority="marcgt">web site</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'BK' or $typeOf008 = 'SE'">
            <xsl:variable name="controlField008-24" select="substring($controlField008, 25, 4)"/>
            <xsl:choose>
                <xsl:when test="contains($controlField008-24, 'a')">
                    <genre authority="marcgt">abstract or summary</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'b')">
                    <genre authority="marcgt">bibliography</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'c')">
                    <genre authority="marcgt">catalog</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'd')">
                    <genre authority="marcgt">dictionary</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'e')">
                    <genre authority="marcgt">encyclopedia</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'f')">
                    <genre authority="marcgt">handbook</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'g')">
                    <genre authority="marcgt">legal article</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'i')">
                    <genre authority="marcgt">index</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'k')">
                    <genre authority="marcgt">discography</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'l')">
                    <genre authority="marcgt">legislation</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'm')">
                    <genre authority="marcgt">theses</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'n')">
                    <genre authority="marcgt">survey of literature</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'o')">
                    <genre authority="marcgt">review</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'p')">
                    <genre authority="marcgt">programmed text</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'q')">
                    <genre authority="marcgt">filmography</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'r')">
                    <genre authority="marcgt">directory</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 's')">
                    <genre authority="marcgt">statistics</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 't')">
                    <genre authority="marcgt">technical report</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'v')">
                    <genre authority="marcgt">legal case and case notes</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'w')">
                    <genre authority="marcgt">law report or digest</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'z')">
                    <genre authority="marcgt">treaty</genre>
                </xsl:when>
            </xsl:choose>
            <xsl:variable name="controlField008-29" select="substring($controlField008, 30, 1)"/>
            <xsl:choose>
                <xsl:when test="$controlField008-29 = '1'">
                    <genre authority="marcgt">conference publication</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'CF'">
            <xsl:variable name="controlField008-26" select="substring($controlField008, 27, 1)"/>
            <xsl:choose>
                <xsl:when test="$controlField008-26 = 'a'">
                    <genre authority="marcgt">numeric data</genre>
                </xsl:when>
                <xsl:when test="$controlField008-26 = 'e'">
                    <genre authority="marcgt">database</genre>
                </xsl:when>
                <xsl:when test="$controlField008-26 = 'f'">
                    <genre authority="marcgt">font</genre>
                </xsl:when>
                <xsl:when test="$controlField008-26 = 'g'">
                    <genre authority="marcgt">game</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'BK'">
            <xsl:if test="substring($controlField008, 25, 1) = 'j'">
                <genre authority="marcgt">patent</genre>
            </xsl:if>
            <xsl:if test="substring($controlField008, 25, 1) = '2'">
                <genre authority="marcgt">offprint</genre>
            </xsl:if>
            <xsl:if test="substring($controlField008, 31, 1) = '1'">
                <genre authority="marcgt">festschrift</genre>
            </xsl:if>
            <xsl:variable name="controlField008-34" select="substring($controlField008, 35, 1)"/>
            <xsl:if
                test="$controlField008-34 = 'a' or $controlField008-34 = 'b' or $controlField008-34 = 'c' or $controlField008-34 = 'd'">
                <genre authority="marcgt">biography</genre>
            </xsl:if>
            <xsl:variable name="controlField008-33" select="substring($controlField008, 34, 1)"/>
            <xsl:choose>
                <xsl:when test="$controlField008-33 = 'e'">
                    <genre authority="marcgt">essay</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'd'">
                    <genre authority="marcgt">drama</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'c'">
                    <genre authority="marcgt">comic strip</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'l'">
                    <genre authority="marcgt">fiction</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'h'">
                    <genre authority="marcgt">humor, satire</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'i'">
                    <genre authority="marcgt">letter</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'f'">
                    <genre authority="marcgt">novel</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'j'">
                    <genre authority="marcgt">short story</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 's'">
                    <genre authority="marcgt">speech</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'MU'">
            <xsl:variable name="controlField008-30-31" select="substring($controlField008, 31, 2)"/>
            <xsl:if test="contains($controlField008-30-31, 'b')">
                <genre authority="marcgt">biography</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'c')">
                <genre authority="marcgt">conference publication</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'd')">
                <genre authority="marcgt">drama</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'e')">
                <genre authority="marcgt">essay</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'f')">
                <genre authority="marcgt">fiction</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'o')">
                <genre authority="marcgt">folktale</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'h')">
                <genre authority="marcgt">history</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'k')">
                <genre authority="marcgt">humor, satire</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'm')">
                <genre authority="marcgt">memoir</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'p')">
                <genre authority="marcgt">poetry</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'r')">
                <genre authority="marcgt">rehearsal</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'g')">
                <genre authority="marcgt">reporting</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 's')">
                <genre authority="marcgt">sound</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'l')">
                <genre authority="marcgt">speech</genre>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'VM'">
            <xsl:variable name="controlField008-33" select="substring($controlField008, 34, 1)"/>
            <xsl:choose>
                <xsl:when test="$controlField008-33 = 'a'">
                    <genre authority="marcgt">art original</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'b'">
                    <genre authority="marcgt">kit</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'c'">
                    <genre authority="marcgt">art reproduction</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'd'">
                    <genre authority="marcgt">diorama</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'f'">
                    <genre authority="marcgt">filmstrip</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'g'">
                    <genre authority="marcgt">legal article</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'i'">
                    <genre authority="marcgt">picture</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'k'">
                    <genre authority="marcgt">graphic</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'l'">
                    <genre authority="marcgt">technical drawing</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'm'">
                    <genre authority="marcgt">motion picture</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'n'">
                    <genre authority="marcgt">chart</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'o'">
                    <genre authority="marcgt">flash card</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'p'">
                    <genre authority="marcgt">microscope slide</genre>
                </xsl:when>
                <xsl:when
                    test="$controlField008-33 = 'q' or controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'q']">
                    <genre authority="marcgt">model</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'r'">
                    <genre authority="marcgt">realia</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 's'">
                    <genre authority="marcgt">slide</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 't'">
                    <genre authority="marcgt">transparency</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'v'">
                    <genre authority="marcgt">videorecording</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'w'">
                    <genre authority="marcgt">toy</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>

        <!-- 111$n, 711$n 1.103 -->

        <xsl:if test="$typeOf008 = 'BK'">
            <xsl:variable name="controlField008-28" select="substring($controlField008, 29, 1)"/>
            <xsl:choose>
                <xsl:when test="contains($controlField008-28, 'a')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'c')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'f')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'm')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'i')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'l')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'm')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'o')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 's')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'u')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'z')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, '|')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'CF'">
            <xsl:variable name="controlField008-28" select="substring($controlField008, 29, 1)"/>
            <xsl:choose>
                <xsl:when test="contains($controlField008-28, 'a')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'c')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'f')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'm')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'i')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'l')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'm')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'o')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 's')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'u')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'z')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, '|')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'CR'">
            <xsl:variable name="controlField008-28" select="substring($controlField008, 29, 1)"/>
            <xsl:choose>
                <xsl:when test="contains($controlField008-28, 'a')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'c')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'f')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'm')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'i')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'l')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'm')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'o')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 's')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'u')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'z')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, '|')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'MP'">
            <xsl:variable name="controlField008-28" select="substring($controlField008, 29, 1)"/>
            <xsl:choose>
                <xsl:when test="contains($controlField008-28, 'a')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'c')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'f')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'm')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'i')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'l')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'm')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'o')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 's')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'u')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'z')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, '|')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'VM'">
            <xsl:variable name="controlField008-28" select="substring($controlField008, 29, 1)"/>
            <xsl:choose>
                <xsl:when test="contains($controlField008-28, 'a')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'c')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'f')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'm')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'i')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'l')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'm')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'o')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 's')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'u')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, 'z')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-28, '|')">
                    <genre authority="marcgt">government publication</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>


        <!-- genre -->
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '047'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '047')]">
            <xsl:call-template name="createGenreFrom047"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '336'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '336')]">
            <xsl:call-template name="createGenreFrom336"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '655'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '655')]">
            <xsl:call-template name="createGenreFrom655"/>
        </xsl:for-each>

        <!-- 1.130 originInfo  -->
        <xsl:call-template name="originInfo">
            <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
            <xsl:with-param name="marcLeader7" select="$marcLeader7"/>
            <xsl:with-param name="marcLeader19" select="$marcLeader19"/>
            <xsl:with-param name="typeOf008" select="$typeOf008"/>
            <xsl:with-param name="controlField008" select="$controlField008"/>
        </xsl:call-template>

        <!-- 1.130 depreciated - originInfo (archived) -->

        <!-- originInfo - 264 -->
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '264'][@ind2 = 0] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '264')][@ind2 = 0]">
            <!-- 1.120 - @264/ind2 -->
            <originInfo eventType="producer">
                <!-- Template checks for altRepGroup - 880 $6 -->
                <xsl:call-template name="xxx880"/>
                <!-- 1.133 -->
                <xsl:choose>
                    <xsl:when test="count(subfield[@code = 'a']) &gt; 1">
                        <xsl:for-each select="subfield[@code = 'a']">
                            <place>
                                <placeTerm type="text">
                                    <xsl:value-of select="."/>
                                </placeTerm>
                            </place>
                            <xsl:if test="following-sibling::subfield[@code = 'b']">
                                <xsl:for-each select="following-sibling::subfield[@code = 'b'][1]">
                                    <publisher>
                                        <xsl:value-of select="."/>
                                    </publisher>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <place>
                            <placeTerm type="text">
                                <xsl:value-of select="subfield[@code = 'a']"/>
                            </placeTerm>
                        </place>
                        <publisher>
                            <xsl:value-of select="subfield[@code = 'b']"/>
                        </publisher>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- 1.134 -->
                <xsl:if test="subfield[@code = 'c']">
                    <dateOther type="production">
                        <xsl:value-of select="subfield[@code = 'c']"/>
                    </dateOther>
                </xsl:if>
            </originInfo>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '264'][@ind2 = 1] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '264')][@ind2 = 1]">
            <!-- 1.120 - @264/ind2 -->
            <originInfo eventType="publisher">
                <!-- Template checks for altRepGroup - 880 $6 1.88 20130829 added chopPunc-->
                <xsl:call-template name="xxx880"/>
                <!-- 1.133 -->
                <xsl:choose>
                    <xsl:when test="count(subfield[@code = 'a']) &gt; 1">
                        <xsl:for-each select="subfield[@code = 'a']">
                            <place>
                                <placeTerm type="text">
                                    <xsl:value-of select="."/>
                                </placeTerm>
                            </place>
                            <xsl:if test="following-sibling::subfield[@code = 'b']">
                                <xsl:for-each select="following-sibling::subfield[@code = 'b'][1]">
                                    <publisher>
                                        <xsl:value-of select="substring-before(., ',')"/>
                                    </publisher>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:if test="following-sibling::subfield[@code = 'c']">
                                <xsl:for-each select="following-sibling::subfield[@code = 'c'][1]">
                                    <publisher>
                                        <xsl:value-of select="substring-before(., ',')"/>
                                    </publisher>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <place>
                            <placeTerm type="text">
                                <xsl:value-of select="subfield[@code = 'a']"/>
                            </placeTerm>
                        </place>
                        <publisher>
                            <xsl:value-of select="subfield[@code = 'b']"/>
                        </publisher>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- 1.134 -->
                <xsl:if test="subfield[@code = 'c']">
                    <dateIssued>
                        <xsl:value-of select="subfield[@code = 'c']"/>
                    </dateIssued>
                </xsl:if>
            </originInfo>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '264'][@ind2 = 2] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '264')][@ind2 = 2]">
            <!-- 1.120 - @264/ind2 -->
            <originInfo eventType="distributor">
                <!-- Template checks for altRepGroup - 880 $6 -->
                <xsl:call-template name="xxx880"/>
                <!-- 1.133 -->
                <xsl:choose>
                    <xsl:when test="count(subfield[@code = 'a']) &gt; 1">
                        <xsl:for-each select="subfield[@code = 'a']">
                            <place>
                                <placeTerm type="text">
                                    <xsl:value-of select="."/>
                                </placeTerm>
                            </place>
                            <xsl:if test="following-sibling::subfield[@code = 'b']">
                                <xsl:for-each select="following-sibling::subfield[@code = 'b'][1]">
                                    <publisher>
                                        <xsl:value-of select="."/>
                                    </publisher>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <place>
                            <placeTerm type="text">
                                <xsl:value-of select="subfield[@code = 'a']"/>
                            </placeTerm>
                        </place>
                        <publisher>
                            <xsl:value-of select="subfield[@code = 'b']"/>
                        </publisher>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- 1.134 -->
                <xsl:if test="subfield[@code = 'c']">
                    <dateOther type="distribution">
                        <xsl:value-of select="subfield[@code = 'c']"/>
                    </dateOther>
                </xsl:if>
            </originInfo>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '264'][@ind2 = 3] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '264')][@ind2 = 3]">
            <!-- 1.120 - @264/ind2 -->
            <originInfo eventType="manufacturer">
                <!-- Template checks for altRepGroup - 880 $6 -->
                <xsl:call-template name="xxx880"/>
                <!-- 1.133 -->
                <xsl:choose>
                    <xsl:when test="count(subfield[@code = 'a']) &gt; 1">
                        <xsl:for-each select="subfield[@code = 'a']">
                            <place>
                                <placeTerm type="text">
                                    <xsl:value-of select="."/>
                                </placeTerm>
                            </place>
                            <xsl:if test="following-sibling::subfield[@code = 'b']">
                                <xsl:for-each select="following-sibling::subfield[@code = 'b'][1]">
                                    <publisher>
                                        <xsl:value-of select="."/>
                                    </publisher>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <place>
                            <placeTerm type="text">
                                <xsl:value-of select="subfield[@code = 'a']"/>
                            </placeTerm>
                        </place>
                        <publisher>
                            <xsl:value-of select="subfield[@code = 'b']"/>
                        </publisher>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- 1.134 -->
                <xsl:if test="subfield[@code = 'c']">
                    <dateOther type="manufacture">
                        <xsl:value-of select="subfield[@code = 'c']"/>
                    </dateOther>
                </xsl:if>
            </originInfo>
        </xsl:for-each>
        <!-- 1.130 depreciated
		<xsl:for-each select="datafield[@tag=880]">
			<xsl:variable name="related_datafield" select="substring-before(subfield[@code='6'],'-')"/>
			<xsl:variable name="occurence_number" select="substring( substring-after(subfield[@code='6'],'-') , 1 , 2 )"/>
			<xsl:variable name="hit" select="../datafield[@tag=$related_datafield and contains(subfield[@code='6'] , concat('880-' , $occurence_number))]/@tag"/>
			 
			<xsl:choose>
				<xsl:when test="$hit='260'">
					<originInfo>
						<xsl:call-template name="scriptCode"/>
						<xsl:for-each select="../datafield[@tag=260 and subfield[@code='a' or code='b' or @code='c' or code='g']]">
							<xsl:call-template name="z2xx880"/>
						</xsl:for-each>
						<xsl:if test="subfield[@code='a']">
							<place>
								<placeTerm type="text">
									<xsl:value-of select="subfield[@code='a']"/>
								</placeTerm>
							</place>
						</xsl:if>
						<xsl:if test="subfield[@code='b']">
							<publisher>
								<xsl:value-of select="subfield[@code='b']"/>
							</publisher>
						</xsl:if>
						<xsl:if test="subfield[@code='c']">
							<dateIssued>
								//- 1.128 -//
								<xsl:call-template name="chopPunctuation">
									<xsl:with-param name="chopString" select="subfield[@code='c']"/>
								</xsl:call-template>
							</dateIssued>
						</xsl:if>
						<xsl:if test="subfield[@code='g']">
							<dateCreated>
								<xsl:value-of select="subfield[@code='g']"/>
							</dateCreated>
						</xsl:if>
						<xsl:for-each select="../datafield[@tag=880]/subfield[@code=6][contains(text(),'250')]">
							<edition>
								<xsl:value-of select="following-sibling::subfield"/>
							</edition>
						</xsl:for-each>
					</originInfo>
				</xsl:when>
				<xsl:when test="$hit='300'">
					<physicalDescription>
						<xsl:for-each select="../datafield[@tag=300]">
							<xsl:call-template name="z3xx880"/>
						</xsl:for-each>
						<extent>
							<xsl:for-each select="subfield">
								<xsl:if test="@code='a' or @code='3' or @code='b' or @code='c'">
									<xsl:value-of select="."/>
									<xsl:text>&#160;</xsl:text>
								</xsl:if>
							</xsl:for-each>
						</extent>
						<form>
							<xsl:attribute name="authority">
								<xsl:value-of select="subfield[@code='2']"/>
							</xsl:attribute>
							<xsl:call-template name="xxx880"/>
							<xsl:call-template name="subfieldSelect">
								<xsl:with-param name="codes">a</xsl:with-param>
							</xsl:call-template>
						</form>
					</physicalDescription>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
-->

        <!-- language 041 -->
        <xsl:variable name="controlField008-35-37"
            select="normalize-space(translate(substring($controlField008, 36, 3), '|#', ''))"/>
        <xsl:if test="$controlField008-35-37">
            <language>
                <languageTerm authority="iso639-2b" type="code">
                    <xsl:choose>
                        <xsl:when test="ends-with($controlField008-35-37, 'ng')">
                            <xsl:value-of select="string('eng')"/>
                        </xsl:when>
                        <xsl:when test="matches($controlField008-35-37, '[a-z]{3}')">
                            <xsl:value-of select="string($controlField008-35-37)"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </languageTerm>
            </language>
        </xsl:if>
        <xsl:for-each select="datafield[@tag = '041']">
            <xsl:for-each
                select="subfield[@code = 'a' or @code = 'b' or @code = 'd' or @code = 'e' or @code = 'f' or @code = 'g' or @code = 'h']">
                <xsl:variable name="langCodes" select="."/>
                <xsl:choose>
                    <xsl:when test="../subfield[@code = '2'] = 'rfc3066'">
                        <!-- not stacked but could be repeated -->
                        <xsl:call-template name="rfcLanguages">
                            <xsl:with-param name="nodeNum">
                                <xsl:value-of select="1"/>
                            </xsl:with-param>
                            <xsl:with-param name="usedLanguages">
                                <xsl:text/>
                            </xsl:with-param>
                            <xsl:with-param name="controlField008-35-37">
                                <xsl:value-of select="$controlField008-35-37"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- iso -->
                        <xsl:variable name="allLanguages">
                            <xsl:copy-of select="$langCodes"/>
                        </xsl:variable>
                        <xsl:variable name="currentLanguage">
                            <xsl:value-of select="substring($allLanguages, 1, 3)"/>
                        </xsl:variable>
                        <xsl:call-template name="isoLanguage">
                            <xsl:with-param name="currentLanguage">
                                <xsl:value-of select="substring($allLanguages, 1, 3)"/>
                            </xsl:with-param>
                            <xsl:with-param name="remainingLanguages">
                                <xsl:value-of
                                    select="substring($allLanguages, 4, string-length($allLanguages) - 3)"
                                />
                            </xsl:with-param>
                            <xsl:with-param name="usedLanguages">
                                <xsl:if test="$controlField008-35-37">
                                    <xsl:value-of select="$controlField008-35-37"/>
                                </xsl:if>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>

        <!-- 1.129 physicalDescription  -->
        <xsl:variable name="physicalDescription">
            <xsl:call-template name="digitalOrigin">
                <xsl:with-param name="typeOf008" select="$typeOf008"/>
            </xsl:call-template>
            <xsl:call-template name="form">
                <xsl:with-param name="controlField008" select="$controlField008"/>
                <xsl:with-param name="typeOf008" select="$typeOf008"/>
                <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
            </xsl:call-template>
            <xsl:call-template name="reformattingQuality"/>
            <xsl:apply-templates select="
                    datafield[@tag = '130']/subfield[@code = 'h'] | datafield[@tag = '240']/subfield[@code = 'h'] |
                    datafield[@tag = '242']/subfield[@code = 'h'] | datafield[@tag = '245']/subfield[@code = 'h']
                    | datafield[@tag = '246']/subfield[@code = 'h'] | datafield[@tag = '730']/subfield[@code = 'h']
                    | datafield[@tag = '256']/subfield[@code = 'a'] | datafield[@tag = '337']/subfield[@code = 'a'] | datafield[@tag = '338']/subfield[@code = 'a']"
                mode="physDesc"/>
            <xsl:apply-templates select="datafield[@tag = '856']/subfield[@code = 'q']"
                mode="physDesc"/>
            <xsl:apply-templates select="datafield[@tag = '300']" mode="physDesc"/>
            <xsl:apply-templates select="datafield[@tag = '351']" mode="physDesc"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="
                    datafield[@tag = '130'][subfield[@code = '6']][child::*[@code = 'h']] or
                    datafield[@tag = '240'][subfield[@code = '6']][child::*[@code = 'h']] or
                    datafield[@tag = '242'][subfield[@code = '6']][child::*[@code = 'h']] or
                    datafield[@tag = '245'][subfield[@code = '6']][child::*[@code = 'h']] or
                    datafield[@tag = '246'][subfield[@code = '6']][child::*[@code = 'h']] or
                    datafield[@tag = '730'][subfield[@code = '6']][child::*[@code = 'h']] or
                    datafield[@tag = '256'][subfield[@code = '6']][child::*[@code = 'a']] or
                    datafield[@tag = '337'][subfield[@code = '6']][child::*[@code = 'a']] or
                    datafield[@tag = '338'][subfield[@code = '6']][child::*[@code = 'a']] or
                    datafield[@tag = '300'][subfield[@code = '6']] or
                    datafield[@tag = '856'][subfield[@code = '6']][child::*[@code = 'q']]">
                <xsl:for-each select="
                        datafield[@tag = '130'][subfield[@code = '6']]/child::*[@code = 'h'] |
                        datafield[@tag = '240'][subfield[@code = '6']]/child::*[@code = 'h'] |
                        datafield[@tag = '242'][subfield[@code = '6']]/child::*[@code = 'h'] |
                        datafield[@tag = '245'][subfield[@code = '6']]/child::*[@code = 'h'] |
                        datafield[@tag = '246'][subfield[@code = '6']]/child::*[@code = 'h'] |
                        datafield[@tag = '730'][subfield[@code = '6']]/child::*[@code = 'h'] |
                        datafield[@tag = '256'][subfield[@code = '6']]/child::*[@code = 'a'] |
                        datafield[@tag = '337'][subfield[@code = '6']]/child::*[@code = 'a'] |
                        datafield[@tag = '338'][subfield[@code = '6']]/child::*[@code = 'a'] |
                        datafield[@tag = '300'][subfield[@code = '6']] |
                        datafield[@tag = '856'][subfield[@code = '6']]/child::*[@code = 'q']">
                    <physicalDescription>
                        <!--  880 field -->
                        <xsl:choose>
                            <xsl:when test="self::subfield">
                                <xsl:call-template name="xxs880"/>
                            </xsl:when>
                            <xsl:when test="self::datafield">
                                <xsl:call-template name="xxx880"/>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:call-template name="digitalOrigin">
                            <xsl:with-param name="typeOf008" select="$typeOf008"/>
                        </xsl:call-template>
                        <xsl:call-template name="form">
                            <xsl:with-param name="controlField008" select="$controlField008"/>
                            <xsl:with-param name="typeOf008" select="$typeOf008"/>
                            <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
                        </xsl:call-template>
                        <xsl:call-template name="reformattingQuality"/>
                        <xsl:apply-templates select="." mode="physDesc"/>
                    </physicalDescription>
                </xsl:for-each>
                <!-- Cover any physical -->
                <xsl:if test="
                        datafield[@tag = '130'][not(subfield[@code = '6'])][child::*[@code = 'h']] or
                        datafield[@tag = '240'][not(subfield[@code = '6'])][child::*[@code = 'h']] or
                        datafield[@tag = '242'][not(subfield[@code = '6'])][child::*[@code = 'h']] or
                        datafield[@tag = '245'][not(subfield[@code = '6'])][child::*[@code = 'h']] or
                        datafield[@tag = '246'][not(subfield[@code = '6'])][child::*[@code = 'h']] or
                        datafield[@tag = '730'][not(subfield[@code = '6'])][child::*[@code = 'h']] or
                        datafield[@tag = '256'][not(subfield[@code = '6'])][child::*[@code = 'a']] or
                        datafield[@tag = '337'][not(subfield[@code = '6'])][child::*[@code = 'a']] or
                        datafield[@tag = '338'][not(subfield[@code = '6'])][child::*[@code = 'a']] or
                        datafield[@tag = '300'][not(subfield[@code = '6'])] or
                        datafield[@tag = '856'][not(subfield[@code = '6'])][child::*[@code = 'q']]">
                    <physicalDescription>
                        <!--  880 field -->
                        <xsl:call-template name="digitalOrigin">
                            <xsl:with-param name="typeOf008" select="$typeOf008"/>
                        </xsl:call-template>
                        <xsl:call-template name="form">
                            <xsl:with-param name="controlField008" select="$controlField008"/>
                            <xsl:with-param name="typeOf008" select="$typeOf008"/>
                            <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
                        </xsl:call-template>
                        <xsl:call-template name="reformattingQuality"/>
                        <xsl:apply-templates select="
                                datafield[@tag = '130'][not(subfield[@code = '6'])][child::*[@code = 'h']] |
                                datafield[@tag = '240'][not(subfield[@code = '6'])][child::*[@code = 'h']] |
                                datafield[@tag = '242'][not(subfield[@code = '6'])][child::*[@code = 'h']] |
                                datafield[@tag = '245'][not(subfield[@code = '6'])][child::*[@code = 'h']] |
                                datafield[@tag = '246'][not(subfield[@code = '6'])][child::*[@code = 'h']] |
                                datafield[@tag = '730'][not(subfield[@code = '6'])][child::*[@code = 'h']] |
                                datafield[@tag = '256'][not(subfield[@code = '6'])][child::*[@code = 'a']] |
                                datafield[@tag = '337'][not(subfield[@code = '6'])][child::*[@code = 'a']] |
                                datafield[@tag = '338'][not(subfield[@code = '6'])][child::*[@code = 'a']] |
                                datafield[@tag = '300'][not(subfield[@code = '6'])] |
                                datafield[@tag = '856'][not(subfield[@code = '6'])][child::*[@code = 'q']]"
                            mode="physDesc"/>
                    </physicalDescription>
                </xsl:if>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($physicalDescription))">
                <physicalDescription>
                    <!--  880 field -->
                    <xsl:call-template name="z3xx880"/>
                    <xsl:copy-of select="$physicalDescription"/>
                </physicalDescription>
            </xsl:when>
        </xsl:choose>
        <!-- 130, 240, 242, 245, 246, 730 $h, 256, 337, 338, 300, 856 -->
        <xsl:for-each select="
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '130')]/child::*[@code = 'h'] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '240')]/child::*[@code = 'h'] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '242')]/child::*[@code = 'h'] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '245')]/child::*[@code = 'h'] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '246')]/child::*[@code = 'h'] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '730')]/child::*[@code = 'h'] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '256')]/child::*[@code = 'a'] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '337')]/child::*[@code = 'a'] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '338')]/child::*[@code = 'a'] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '300')] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '856')]/child::*[code = 'q']">
            <physicalDescription>
                <xsl:choose>
                    <xsl:when test="self::subfield">
                        <xsl:call-template name="xxs880"/>
                    </xsl:when>
                    <xsl:when test="self::datafield">
                        <xsl:call-template name="xxx880"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:apply-templates select="." mode="physDesc"/>
            </physicalDescription>
        </xsl:for-each>

        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '520'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '520')]">
            <xsl:call-template name="createAbstractFrom520"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '505'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '505')]">
            <xsl:call-template name="createTOCFrom505"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '521'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '521')]">
            <xsl:call-template name="createTargetAudienceFrom521"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '506'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '506')]">
            <xsl:call-template name="createAccessConditionFrom506"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '540'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '540')]">
            <xsl:call-template name="createAccessConditionFrom540"/>
        </xsl:for-each>

        <xsl:if
            test="$typeOf008 = 'BK' or $typeOf008 = 'CF' or $typeOf008 = 'MU' or $typeOf008 = 'VM'">
            <xsl:variable name="controlField008-22" select="substring($controlField008, 23, 1)"/>
            <xsl:choose>
                <!-- 01/04 fix -->
                <xsl:when test="$controlField008-22 = 'd'">
                    <targetAudience authority="marctarget">adolescent</targetAudience>
                </xsl:when>
                <xsl:when test="$controlField008-22 = 'e'">
                    <targetAudience authority="marctarget">adult</targetAudience>
                </xsl:when>
                <xsl:when test="$controlField008-22 = 'g'">
                    <targetAudience authority="marctarget">general</targetAudience>
                </xsl:when>
                <xsl:when
                    test="$controlField008-22 = 'b' or $controlField008-22 = 'c' or $controlField008-22 = 'j'">
                    <targetAudience authority="marctarget">juvenile</targetAudience>
                </xsl:when>
                <xsl:when test="$controlField008-22 = 'a'">
                    <targetAudience authority="marctarget">preschool</targetAudience>
                </xsl:when>
                <xsl:when test="$controlField008-22 = 'f'">
                    <targetAudience authority="marctarget">specialized</targetAudience>
                </xsl:when>
            </xsl:choose>
        </xsl:if>

        <!-- 1.32 tmee Drop note mapping for 510 and map only to <relatedItem>
		<xsl:for-each select="datafield[@tag=510]">
			<note type="citation/reference">
				<xsl:call-template name="uri"/>
				<xsl:variable name="str">
					<xsl:for-each select="subfield[@code!='6' or @code!='8']">
						<xsl:value-of select="."/>
						<xsl:text>&#160;</xsl:text>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="substring($str,1,string-length($str)-1)"/>
			</note>
		</xsl:for-each>
		-->

        <!-- 245c 362az 502-585 5XX-->
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '245'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '245')]">
            <xsl:call-template name="createNoteFrom245c"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '362'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '362')]">
            <xsl:call-template name="createNoteFrom362"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '500'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '500')]">
            <xsl:call-template name="createNoteFrom500"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '502'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '502')]">
            <xsl:call-template name="createNoteFrom502"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '504'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '504')]">
            <xsl:call-template name="createNoteFrom504"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '508'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '508')]">
            <xsl:call-template name="createNoteFrom508"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '511'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '511')]">
            <xsl:call-template name="createNoteFrom511"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '515'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '515')]">
            <xsl:call-template name="createNoteFrom515"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '518'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '518')]">
            <xsl:call-template name="createNoteFrom518"/>

        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '524'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '524')]">
            <xsl:call-template name="createNoteFrom524"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '530'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '530')]">
            <xsl:call-template name="createNoteFrom530"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '533'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '533')]">
            <xsl:call-template name="createNoteFrom533"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '535'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '535')]">
            <xsl:call-template name="createNoteFrom535"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '536'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '536')]">
            <xsl:call-template name="createNoteFrom536"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '538'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '538')]">
            <xsl:call-template name="createNoteFrom538"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '541'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '541')]">
            <xsl:call-template name="createNoteFrom541"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '545'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '545')]">
            <xsl:call-template name="createNoteFrom545"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '546'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '546')]">
            <xsl:call-template name="createNoteFrom546"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '561'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '561')]">
            <xsl:call-template name="createNoteFrom561"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '562'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '562')]">
            <xsl:call-template name="createNoteFrom562"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '581'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '581')]">
            <xsl:call-template name="createNoteFrom581"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '583'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '583')]">
            <xsl:call-template name="createNoteFrom583"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '585'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '585')]">
            <xsl:call-template name="createNoteFrom585"/>
        </xsl:for-each>
        <!-- 1.121, 1.135 -->
        <xsl:for-each select="
                datafield[@tag = '501' or @tag = '507' or @tag = '513' or @tag = '514' or @tag = '516'
                or @tag = '522' or @tag = '525' or @tag = '526' or @tag = '544' or @tag = '547'
                or @tag = '550' or @tag = '552' or @tag = '555' or @tag = '556'
                or @tag = '565' or @tag = '567' or @tag = '580' or @tag = '584' or @tag = '586' or @tag = '588']
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '501')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '507')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '513')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '514')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '516')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '522')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '525')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '526')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '544')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '547')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '550')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '552')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '555')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '556')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '565')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '567')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '580')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '585')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '584')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '586')]">
            <xsl:call-template name="createNoteFrom5XX"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '034'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '034')]">
            <xsl:call-template name="createSubGeoFrom034"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '043'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '043')]">
            <xsl:call-template name="createSubGeoFrom043"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '045'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '045')]">
            <xsl:call-template name="createSubTemFrom045"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '255'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '255')]">
            <xsl:call-template name="createSubGeoFrom255"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '600'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '600')]">
            <xsl:call-template name="createSubNameFrom600"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '610'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '610')]">
            <xsl:call-template name="createSubNameFrom610"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '611'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '611')]">
            <xsl:call-template name="createSubNameFrom611"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '630'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '630')]">
            <xsl:call-template name="createSubTitleFrom630"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '648'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '648')]">
            <xsl:call-template name="createSubChronFrom648"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '650'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '650')]">
            <xsl:call-template name="createSubTopFrom650"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '651'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '651')]">
            <xsl:call-template name="createSubGeoFrom651"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '653'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '653')]">
            <xsl:call-template name="createSubFrom653"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '656'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '656')]">
            <xsl:call-template name="createSubFrom656"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '662'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '662')]">
            <xsl:call-template name="createSubGeoFrom662752"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '752'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '752')]">
            <xsl:call-template name="createSubGeoFrom662752"/>
        </xsl:for-each>

        <!-- 1.155 -->
        <xsl:for-each select="datafield[@tag = '072'][@ind2 = '0']">
            <xsl:if test="matches(., '[A-Z]\d{3}')">
                <subject authority="agricola">
                    <topic>
                        <xsl:value-of select="f:subjCatCode(normalize-space(subfield[@code = 'a']))"
                        />
                    </topic>
                </subject>
            </xsl:if>
        </xsl:for-each>


        <!-- createClassificationFrom 0XX-->
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '050'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '050')]">
            <xsl:call-template name="createClassificationFrom050"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '060'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '060')]">
            <xsl:call-template name="createClassificationFrom060"/>
        </xsl:for-each>
        <!-- 1.160 -->
        <xsl:for-each
            select="datafield[@tag = '070'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '070')]">
            <xsl:call-template name="createClassificationFrom070"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '080'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '080')]">
            <xsl:call-template name="createClassificationFrom080"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '082'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '082')]">
            <xsl:call-template name="createClassificationFrom082"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '084'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '084')]">
            <xsl:call-template name="createClassificationFrom084"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '086'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '086')]">
            <xsl:call-template name="createClassificationFrom086"/>
        </xsl:for-each>

        <!--	location	-->
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '852'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '852')]">
            <xsl:call-template name="createLocationFrom852"/>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '856'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '856')]">
            <xsl:call-template name="createLocationFrom856"/>
        </xsl:for-each>

        <!-- 1.120 - @490$ind1 -->
        <xsl:for-each
            select="datafield[@tag = '490'][@ind1 = '0' or @ind1 = ' '] | datafield[@tag = '880'][@ind1 = '0' or @ind1 = ' '][starts-with(subfield[@code = '6'], '490')]">
            <xsl:call-template name="createRelatedItemFrom490"/>
        </xsl:for-each>

        <!-- 1.120 - @440$ind1 -->
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '440'][@ind1 = '0' or @ind1 = ' '] | datafield[@tag = '880'][@ind1 = '0' or @ind1 = ' '][starts-with(subfield[@code = '6'], '440')]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '440' or (@tag = '880' and not(../datafield[@tag = '440'][@ind1 = '0' or @ind1 = ' '][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem type="series">
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][@ind1 = '0' or @ind1 = ' '][starts-with(subfield[@code = '6'], '440')][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <titleInfo>
                            <xsl:call-template name="xxx880"/>
                            <!-- 1.120 - @440$a$v -->
                            <xsl:variable name="this">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="subfieldSelect">
                                            <xsl:with-param name="codes">a</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>

                            <title>
                                <xsl:value-of select="normalize-space($this)"/>
                            </title>
                            <xsl:if test="subfield[@code = 'v']">
                                <partNumber>
                                    <xsl:call-template name="chopPunctuation">
                                        <xsl:with-param name="chopString">
                                            <xsl:call-template name="subfieldSelect">
                                                <xsl:with-param name="codes">v</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </partNumber>
                            </xsl:if>
                        </titleInfo>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>

        <!-- tmee 1.40 1.74 1.88 fixed 510c mapping 20130829-->
        <!-- 1.120 - @510$ind1 -->
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '510'][@ind1 = '0' or @ind1 = ' '] | datafield[@tag = '880'][@ind1 = '0' or @ind1 = ' '][starts-with(subfield[@code = '6'], '510')]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '510' or (@tag = '880' and not(../datafield[@tag = '510'][@ind1 = '0' or @ind1 = ' '][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem type="isReferencedBy">
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][@ind1 = '0' or @ind1 = ' '][starts-with(subfield[@code = '6'], '510')][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <xsl:for-each select="subfield[@code = 'a']">
                            <titleInfo>
                                <xsl:call-template name="xxs880"/>
                                <title>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </title>
                            </titleInfo>
                        </xsl:for-each>
                        <xsl:for-each select="subfield[@code = 'b']">
                            <originInfo>
                                <xsl:call-template name="xxs880"/>
                                <dateOther type="coverage">
                                    <xsl:value-of select="."/>
                                </dateOther>
                            </originInfo>
                        </xsl:for-each>
                        <part>
                            <xsl:call-template name="xxx880"/>
                            <detail type="part">
                                <number>
                                    <xsl:call-template name="chopPunctuation">
                                        <xsl:with-param name="chopString">
                                            <xsl:call-template name="subfieldSelect">
                                                <xsl:with-param name="codes">c</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </number>
                            </detail>
                        </part>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>

        <!-- 1.120 - @534$ind1 -->
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '534'][@ind1 = '0' or @ind1 = ' '] | datafield[@tag = '880'][@ind1 = '0' or @ind1 = ' '][starts-with(subfield[@code = '6'], '534')]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '534' or (@tag = '880' and not(../datafield[@tag = '534'][@ind1 = '0' or @ind1 = ' '][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem type="original">
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][@ind1 = '0' or @ind1 = ' '][starts-with(subfield[@code = '6'], '534')][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <xsl:call-template name="relatedTitle"/>
                        <xsl:call-template name="relatedName"/>
                        <xsl:if test="subfield[@code = 'b' or @code = 'c']">
                            <originInfo>
                                <xsl:call-template name="xxx880"/>
                                <xsl:for-each select="subfield[@code = 'c']">
                                    <publisher>
                                        <xsl:value-of select="."/>
                                    </publisher>
                                </xsl:for-each>
                                <xsl:for-each select="subfield[@code = 'b']">
                                    <edition>
                                        <xsl:value-of select="."/>
                                    </edition>
                                </xsl:for-each>
                            </originInfo>
                        </xsl:if>
                        <!-- related item id -->
                        <xsl:apply-templates select="subfield[@code = 'x']" mode="relatedItem"/>
                        <xsl:apply-templates select="subfield[@code = 'z']" mode="relatedItem"/>
                        <xsl:call-template name="relatedNote"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '700'][subfield[@code = 't']] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '700')][subfield[@code = 't']]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '700' or (@tag = '880' and not(../datafield[@tag = '700'][subfield[@code = 't']][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem>
                    <!-- 1.115 -->
                    <xsl:if test="subfield[@code = 'i']">
                        <xsl:attribute name="otherType">
                            <xsl:value-of select="subfield[@code = 'i']"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="constituentOrRelatedType"/>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '700')][subfield[@code = 't']][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <titleInfo>
                            <xsl:call-template name="xxx880"/>
                            <xsl:variable name="this">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="specialSubfieldSelect">
                                            <xsl:with-param name="anyCodes"
                                                >tfklmorsv</xsl:with-param>
                                            <xsl:with-param name="axis">t</xsl:with-param>
                                            <xsl:with-param name="afterCodes">g</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <title>
                                <xsl:value-of select="normalize-space($this)"/>
                            </title>
                            <xsl:call-template name="part"/>
                        </titleInfo>
                        <!-- 1.164 -->
                        <name type="personal">
                            <xsl:call-template name="xxx880"/>
                            <xsl:call-template name="personal_name"/>
                            <xsl:call-template name="termsOfAddress"/>
                            <xsl:call-template name="nameDate"/>
                            <xsl:call-template name="role"/>
                        </name>
                        <xsl:call-template name="relatedForm"/>
                        <!-- issn -->
                        <xsl:apply-templates select="subfield[@code = 'x']" mode="relatedItem"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '710'][subfield[@code = 't']] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '710')][subfield[@code = 't']]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '710' or (@tag = '880' and not(../datafield[@tag = '710'][subfield[@code = 't']][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem>
                    <!-- 1.115 -->
                    <xsl:if test="subfield[@code = 'i']">
                        <xsl:attribute name="otherType">
                            <xsl:value-of select="subfield[@code = 'i']"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="constituentOrRelatedType"/>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '710')][subfield[@code = 't']][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <titleInfo>
                            <xsl:call-template name="xxx880"/>
                            <xsl:variable name="this">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="specialSubfieldSelect">
                                            <!-- 1.120 @711$v -->
                                            <xsl:with-param name="anyCodes"
                                                >tfklmors</xsl:with-param>
                                            <xsl:with-param name="axis">t</xsl:with-param>
                                            <xsl:with-param name="afterCodes">dg</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>

                            <title>
                                <xsl:value-of select="normalize-space($this)"/>
                            </title>
                            <!-- 1.125 -->
                            <xsl:variable name="partNumber">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="specialSubfieldSelect">
                                            <xsl:with-param name="anyCodes">n</xsl:with-param>
                                            <xsl:with-param name="axis">t</xsl:with-param>
                                            <xsl:with-param name="afterCodes">n</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:if test="$partNumber != ''">
                                <partNumber>
                                    <xsl:value-of select="$partNumber"/>
                                </partNumber>
                            </xsl:if>
                            <xsl:apply-templates select="subfield[@code = 'p']" mode="relatedItem"/>
                        </titleInfo>
                        <name type="corporate">
                            <xsl:call-template name="xxx880"/>
                            <xsl:for-each select="subfield[@code = 'a']">
                                <namePart>
                                    <xsl:value-of select="."/>
                                </namePart>
                            </xsl:for-each>
                            <xsl:for-each select="subfield[@code = 'b']">
                                <namePart>
                                    <xsl:value-of select="."/>
                                </namePart>
                            </xsl:for-each>
                            <xsl:variable name="tempNamePart">
                                <xsl:call-template name="specialSubfieldSelect">
                                    <xsl:with-param name="anyCodes">c</xsl:with-param>
                                    <xsl:with-param name="axis">t</xsl:with-param>
                                    <xsl:with-param name="beforeCodes">dgn</xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:if test="normalize-space($tempNamePart)">
                                <namePart>
                                    <xsl:value-of select="$tempNamePart"/>
                                </namePart>
                            </xsl:if>
                            <xsl:call-template name="role"/>
                        </name>
                        <xsl:call-template name="relatedForm"/>
                        <!-- issn -->
                        <xsl:apply-templates select="subfield[@code = 'x']" mode="relatedItem"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '711'][subfield[@code = 't']] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '711')][subfield[@code = 't']]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '711' or (@tag = '880' and not(../datafield[@tag = '711'][subfield[@code = 't']][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem>
                    <!-- 1.115 -->
                    <xsl:if test="subfield[@code = 'i']">
                        <xsl:attribute name="otherType">
                            <xsl:value-of select="subfield[@code = 'i']"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="constituentOrRelatedType"/>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '711')][subfield[@code = 't']][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <titleInfo>
                            <xsl:call-template name="xxx880"/>
                            <xsl:variable name="this">
                                <!-- 1.120 - @711$v -->
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="specialSubfieldSelect">
                                            <xsl:with-param name="anyCodes">tfkls</xsl:with-param>
                                            <xsl:with-param name="axis">t</xsl:with-param>
                                            <xsl:with-param name="afterCodes">g</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>

                            <title>
                                <xsl:value-of select="normalize-space($this)"/>
                            </title>
                            <!-- 1.125 -->
                            <xsl:variable name="partNumber">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="specialSubfieldSelect">
                                            <xsl:with-param name="anyCodes">n</xsl:with-param>
                                            <xsl:with-param name="axis">t</xsl:with-param>
                                            <xsl:with-param name="afterCodes">n</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:if test="$partNumber != ''">
                                <partNumber>
                                    <xsl:value-of select="$partNumber"/>
                                </partNumber>
                            </xsl:if>
                            <xsl:apply-templates select="subfield[@code = 'p']" mode="relatedItem"/>
                        </titleInfo>
                        <name type="conference">
                            <xsl:call-template name="xxx880"/>
                            <namePart>
                                <xsl:call-template name="specialSubfieldSelect">
                                    <xsl:with-param name="anyCodes">aqdc</xsl:with-param>
                                    <xsl:with-param name="axis">t</xsl:with-param>
                                    <xsl:with-param name="beforeCodes">gn</xsl:with-param>
                                </xsl:call-template>
                            </namePart>
                            <!-- 1.120 - @711$4 -->
                            <xsl:call-template name="role"/>
                        </name>
                        <xsl:call-template name="relatedForm"/>
                        <!-- issn -->
                        <xsl:apply-templates select="subfield[@code = 'x']" mode="relatedItem"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '730'][@ind2 = 2] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '730')][@ind2 = '2']">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '730' or (@tag = '880' and not(../datafield[@tag = '730'][@ind2 = 2][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem>
                    <!-- 1.115 -->
                    <xsl:if test="subfield[@code = 'i']">
                        <xsl:attribute name="otherType">
                            <xsl:value-of select="subfield[@code = 'i']"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="constituentOrRelatedType"/>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '730')][@ind2 = '2'][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <titleInfo>
                            <xsl:call-template name="xxx880"/>
                            <xsl:variable name="this">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <!-- 1.120 @711$v -->
                                        <xsl:call-template name="subfieldSelect">
                                            <xsl:with-param name="codes">adfgklmors</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>

                            <title>
                                <xsl:value-of select="normalize-space($this)"/>
                            </title>
                            <xsl:call-template name="part"/>
                        </titleInfo>
                        <xsl:call-template name="relatedForm"/>
                        <!-- issn -->
                        <xsl:apply-templates select="subfield[@code = 'x']" mode="relatedItem"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>

        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '740'][@ind2 = 2] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '740')][@ind2 = '2']">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '740' or (@tag = '880' and not(../datafield[@tag = '740'][@ind2 = 2][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem>
                    <!-- 1.115 -->
                    <xsl:if test="subfield[@code = 'i']">
                        <xsl:attribute name="otherType">
                            <xsl:value-of select="subfield[@code = 'i']"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="constituentOrRelatedType"/>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '740')][@ind2 = '2'][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <titleInfo>
                            <xsl:call-template name="xxx880"/>
                            <xsl:variable name="this">

                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:value-of select="subfield[@code = 'a']"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>

                            <title>
                                <xsl:value-of select="normalize-space($this)"/>
                            </title>
                            <xsl:call-template name="part"/>
                        </titleInfo>
                        <xsl:call-template name="relatedForm"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>

        <!-- 1.120 - @777 @787 , 1.121, 1.168 (added914, removed of 787)  -->
        <xsl:for-each select="
                datafield[@tag = '760'] | datafield[@tag = '762'] | datafield[@tag = '765'] |
                datafield[@tag = '767'] | datafield[@tag = '770'] | datafield[@tag = '774'] |
                datafield[@tag = '775'] | datafield[@tag = '772'] | datafield[@tag = '773'] |
                datafield[@tag = '776'] | datafield[@tag = '777'] | datafield[@tag = '787'] |
                datafield[@tag = '780'] | datafield[@tag = '785'] | datafield[@tag = '786'] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '760')] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '762')] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '765')] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '767')] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '770')] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '774')] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '775')] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '772')] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '773')] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '776')] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '777')] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '787')] |
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '780')] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '785')] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '786')]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:variable name="tag" select="@tag"/>
            <xsl:if test="
                    (@tag = 760 or @tag = 762 or @tag = 765 or @tag = 767 or @tag = 770 or @tag = 774 or
                    @tag = 775 or @tag = 772 or @tag = 773 or @tag = 776 or @tag = 777 or @tag = 787 or
                    @tag = 780 or @tag = 785 or @tag = 786) or
                    (@tag = '880' and not(../datafield[@tag = 760 or @tag = 762 or @tag = 765 or
                    @tag = 767 or @tag = 770 or @tag = 774 or @tag = 775 or @tag = 772 or @tag = 773 or
                    @tag = 776 or @tag = 777 or @tag = 787 or @tag = 780 or @tag = 785 or @tag = 786][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem>
                    <!-- selects type attribute -->
                    <xsl:choose>
                        <!-- 1.120 - @762@type -->
                        <xsl:when test="@tag = '760' or @tag = '762'">
                            <xsl:attribute name="type">series</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@tag = '770' or @tag = '774'">
                            <xsl:attribute name="type">constituent</xsl:attribute>
                        </xsl:when>
                        <!-- 1.120 - @775@type -->
                        <xsl:when
                            test="@tag = '765' or @tag = '767' or (@tag = '775' and @ind2 = ' ')">
                            <xsl:attribute name="type">otherVersion</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@tag = '772' or @tag = '773'">
                            <xsl:attribute name="type">host</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@tag = '776'">
                            <xsl:attribute name="type">otherFormat</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@tag = '780'">
                            <xsl:attribute name="type">preceding</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@tag = '785'">
                            <xsl:attribute name="type">succeeding</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@tag = '786'">
                            <xsl:attribute name="type">original</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <!-- selects displayLabel attribute -->
                    <xsl:choose>
                        <xsl:when test="subfield[@code = 'i']">
                            <xsl:attribute name="otherType">
                                <xsl:value-of select="subfield[@code = 'i']"/>
                            </xsl:attribute>
                            <!-- 1.120 - @76X-78X$i -->
                            <xsl:attribute name="displayLabel">
                                <xsl:value-of select="subfield[@code = 'i']"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="subfield[@code = '3']">
                            <xsl:attribute name="displayLabel">
                                <xsl:value-of select="subfield[@code = '3']"/>
                            </xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], $tag)][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <!-- title -->
                        <xsl:for-each select="subfield[@code = 't']">
                            <titleInfo>
                                <xsl:call-template name="xxs880"/>
                                <title>
                                    <xsl:call-template name="chopPunctuation">
                                        <xsl:with-param name="chopString">
                                            <xsl:value-of select="."/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </title>
                                <xsl:if test="parent::*[@tag != 773] and ../subfield[@code = 'g']">
                                    <xsl:apply-templates select="../subfield[@code = 'g']"
                                        mode="relatedItem"/>
                                </xsl:if>
                            </titleInfo>
                        </xsl:for-each>
                        <xsl:for-each select="subfield[@code = 'p']">
                            <titleInfo type="abbreviated">
                                <xsl:call-template name="xxs880"/>
                                <title>
                                    <xsl:call-template name="chopPunctuation">
                                        <xsl:with-param name="chopString">
                                            <xsl:value-of select="."/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </title>
                                <xsl:if test="parent::*[@tag != 773] and ../subfield[@code = 'g']">
                                    <xsl:apply-templates select="../subfield[@code = 'g']"
                                        mode="relatedItem"/>
                                </xsl:if>
                            </titleInfo>
                        </xsl:for-each>
                        <xsl:for-each select="subfield[@code = 's']">
                            <titleInfo type="uniform">
                                <!-- 1.121 -->
                                <xsl:call-template name="xxs880"/>
                                <title>
                                    <xsl:call-template name="chopPunctuation">
                                        <xsl:with-param name="chopString">
                                            <xsl:value-of select="."/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </title>
                                <!-- 1.120 - @76X-78X$g -->
                                <xsl:if test="parent::*[@tag != 773] and ../subfield[@code = 'g']">
                                    <xsl:apply-templates select="../subfield[@code = 'g']"
                                        mode="relatedItem"/>
                                </xsl:if>
                            </titleInfo>
                        </xsl:for-each>

                        <!-- originInfo -->
                        <xsl:if test="subfield[@code = 'b' or @code = 'd'] or subfield[@code = 'f']">
                            <originInfo>
                                <xsl:call-template name="xxx880"/>
                                <xsl:if test="@tag = '775'">
                                    <xsl:for-each select="subfield[@code = 'f']">
                                        <place>
                                            <placeTerm>
                                                <xsl:attribute name="type">code</xsl:attribute>
                                                <xsl:attribute name="authority"
                                                  >marcgac</xsl:attribute>
                                                <xsl:call-template name="chopPunctuation">
                                                  <xsl:with-param name="chopString">
                                                  <xsl:value-of select="."/>
                                                  </xsl:with-param>
                                                </xsl:call-template>
                                            </placeTerm>
                                        </place>
                                    </xsl:for-each>
                                </xsl:if>
                                <!--    <xsl:for-each select="subfield[@code='d']">
                                    <publisher>
                                        <xsl:call-template name="chopPunctuation">
                                            <xsl:with-param name="chopString">
                                                <xsl:value-of select="."/>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </publisher>
                                </xsl:for-each>-->
                                <xsl:for-each select="subfield[@code = 'b']">
                                    <edition>
                                        <xsl:apply-templates/>
                                    </edition>
                                </xsl:for-each>
                            </originInfo>
                        </xsl:if>
                        <!-- language -->
                        <xsl:if test="@tag = '775'">
                            <xsl:if test="subfield[@code = 'e']">
                                <language>
                                    <xsl:call-template name="xxx880"/>
                                    <languageTerm type="code" authority="iso639-2b">
                                        <xsl:value-of select="subfield[@code = 'e']"/>
                                    </languageTerm>
                                </language>
                            </xsl:if>
                        </xsl:if>
                        <!-- physical description -->
                        <xsl:apply-templates select="subfield[@code = 'h']" mode="relatedItem"/>
                        <!-- note -->
                        <xsl:apply-templates select="subfield[@code = 'n']" mode="relatedItemNote"/>
                        <!-- subjects -->
                        <xsl:apply-templates select="subfield[@code = 'j']" mode="relatedItem"/>
                        <!-- identifiers -->
                        <xsl:apply-templates select="subfield[@code = 'o']" mode="relatedItemOf"/>
                        <xsl:apply-templates select="subfield[@code = 'x']" mode="relatedItemX"/>
                        <xsl:apply-templates select="datafield[@tag = '914']/subfield[@code = 'a']"
                            mode="relatedItem914"/>
                        <!--  1.120 - @76X-78X$z -->
                        <xsl:apply-templates select="subfield[@code = 'z']" mode="relatedItem"/>
                        <xsl:apply-templates select="subfield[@code = 'w']" mode="relatedItem"/>
                        <!--1.170 -->
                        <xsl:if test="@tag = '773'">
                            <xsl:for-each select="subfield[@code = 'g']">
                                <!--NAL relatedPart-->
                                <part>
                                    <xsl:call-template name="xxs880"/>
                                    <xsl:analyze-string select="." regex="(\d{{4,6}}.\w{{0,4}})(.+)">
                                        <xsl:matching-substring>
                                            <!-- volume -->
                                            <detail type="volume">
                                                <number>
                                                  <xsl:value-of
                                                  select="replace(regex-group(2), '(.*, v\.\s)(\d+)(.*)', '$2')"
                                                  />
                                                </number>
                                                <caption>v.</caption>
                                            </detail>
                                            <!-- issue -->
                                            <xsl:if test="matches(regex-group(2), 'no. ')">
                                                <detail type="issue">
                                                  <number>
                                                  <xsl:value-of
                                                  select="replace(regex-group(2), '(.*)(no. )(\d+|pt.\d+)(.*)', '$3')"
                                                  />
                                                  </number>
                                                  <caption>no.</caption>
                                                </detail>
                                            </xsl:if>
                                            <xsl:choose>
                                                <!-- extent (pages) -->
                                                <xsl:when test="matches(regex-group(2), '\d+\-\d+')">
                                                  <extent unit="pages">
                                                  <start>
                                                  <xsl:value-of
                                                  select="replace(regex-group(2), '(.*)(p.)(\d+)(\-)(\d+)', '$3')"
                                                  />
                                                  </start>
                                                  <end>
                                                  <xsl:value-of
                                                  select="replace(regex-group(2), '(.*)(p.)(\d+)(\-)(\d+)', '$5')"
                                                  />
                                                  </end>
                                                  <xsl:variable name="firstPage" as="xs:double"
                                                  select="number(replace(regex-group(2), '(.*)(p.)(\d+)(\-)(\d+)', '$3'))"/>
                                                  <xsl:variable name="lastPage" as="xs:double"
                                                  select="number(replace(regex-group(2), '(.*)(p.)(\d+)(\-)(\d+)', '$5'))"/>
                                                  <total>
                                                  <xsl:value-of
                                                  select="translate(f:calculateTotalPgs($firstPage, $lastPage), 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-|', '')"
                                                  />
                                                  </total>
                                                  </extent>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <!-- extent (page total) -->
                                                  <xsl:if test="ends-with(regex-group(2), '-')">
                                                  <extent unit="pages">
                                                  <xsl:variable name="clean-regex-group-2"
                                                  select="substring-before(substring-after(regex-group(2), 'p.'), '-')"/>
                                                  <total>
                                                  <xsl:value-of
                                                  select="translate($clean-regex-group-2, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-| ', '')"
                                                  />
                                                  </total>
                                                  </extent>
                                                  </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <text type="year">
                                                <xsl:value-of
                                                  select="substring-before(regex-group(1), ' ')"/>
                                            </text>
                                            <text type="month">
                                                <xsl:value-of
                                                  select="substring-after(regex-group(1), ' ')"/>
                                            </text>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </part>
                            </xsl:for-each>
                            <xsl:for-each select="subfield[@code = 'q']">
                                <part>
                                    <xsl:call-template name="xxs880"/>
                                    <xsl:call-template name="parsePart"/>
                                </part>
                            </xsl:for-each>
                        </xsl:if>
                        <!--  Call names  -->
                        <xsl:apply-templates select="subfield[@code = 'a']" mode="relatedItem"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
            <!--<!-\- LC's related part -\->
            <xsl:if test="@tag='773'">
                <xsl:for-each select="subfield[@code='g']">
                    <part>
                        <xsl:call-template name="xxs880"/>
                        <text>
                            <xsl:apply-templates/>
                        </text>
                    </part>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code='q']">
                    <part>
                        <xsl:call-template name="xxs880"/>
                        <xsl:call-template name="parsePart"/>
                    </part>
                </xsl:for-each>
            </xsl:if>
            <!-\- Call names -\->
            <xsl:apply-templates select="subfield[@code='a']" mode="relatedItem"/>
        </xsl:for-each>
        </relatedItem>
        </xsl:if>-->
        </xsl:for-each>

        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '800'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '800')]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '800' or (@tag = '880' and not(../datafield[@tag = '800'][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem type="series">
                    <!-- 1.122 -->
                    <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '800')][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <titleInfo>
                            <xsl:call-template name="xxx880"/>
                            <xsl:variable name="this">

                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="specialSubfieldSelect">
                                            <xsl:with-param name="anyCodes"
                                                >tfklmors</xsl:with-param>
                                            <xsl:with-param name="axis">t</xsl:with-param>
                                            <xsl:with-param name="afterCodes">g</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <title>
                                <xsl:value-of select="normalize-space($this)"/>
                            </title>
                            <!-- 1.120 - @800$v -->
                            <xsl:apply-templates select="subfield[@code = 'n']" mode="relatedItem"/>
                            <xsl:apply-templates select="subfield[@code = 'v']" mode="relatedItem"/>
                            <xsl:apply-templates select="subfield[@code = 'p']" mode="relatedItem"/>
                        </titleInfo>
                        <name type="personal">
                            <xsl:call-template name="xxx880"/>
                            <namePart>
                                <!-- 1.126 -->
                                <xsl:call-template name="specialSubfieldSelect">
                                    <xsl:with-param name="anyCodes">aq</xsl:with-param>
                                    <xsl:with-param name="axis">t</xsl:with-param>
                                    <xsl:with-param name="beforeCodes">g</xsl:with-param>
                                </xsl:call-template>
                            </namePart>
                            <xsl:call-template name="termsOfAddress"/>
                            <xsl:call-template name="nameDate"/>
                            <xsl:call-template name="role"/>
                        </name>
                        <xsl:call-template name="relatedForm"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
        <!-- 1.121 -->

        <xsl:for-each
            select="datafield[@tag = '810'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '810')]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '810' or (@tag = '880' and not(../datafield[@tag = '810'][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem type="series">
                    <!-- 1.122 -->
                    <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '810')][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <titleInfo>
                            <xsl:call-template name="xxx880"/>
                            <xsl:variable name="this">

                                <!-- 1.120 - @800$v -->
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="specialSubfieldSelect">
                                            <xsl:with-param name="anyCodes"
                                                >tfklmors</xsl:with-param>
                                            <xsl:with-param name="axis">t</xsl:with-param>
                                            <xsl:with-param name="afterCodes">dg</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <title>
                                <xsl:value-of select="normalize-space($this)"/>
                            </title>
                            <!-- 1.125 -->
                            <xsl:variable name="partNumber">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="specialSubfieldSelect">
                                            <xsl:with-param name="anyCodes">n</xsl:with-param>
                                            <xsl:with-param name="axis">t</xsl:with-param>
                                            <xsl:with-param name="afterCodes">n</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:if test="$partNumber != ''">
                                <partNumber>
                                    <xsl:value-of select="$partNumber"/>
                                </partNumber>
                            </xsl:if>
                            <!-- 1.120 - @800$v -->
                            <xsl:apply-templates select="subfield[@code = 'v']" mode="relatedItem"/>
                            <xsl:apply-templates select="subfield[@code = 'p']" mode="relatedItem"/>
                        </titleInfo>
                        <name type="corporate">
                            <xsl:call-template name="xxx880"/>
                            <xsl:for-each select="subfield[@code = 'a']">
                                <namePart>
                                    <xsl:value-of select="."/>
                                </namePart>
                            </xsl:for-each>
                            <xsl:for-each select="subfield[@code = 'b']">
                                <namePart>
                                    <xsl:value-of select="."/>
                                </namePart>
                            </xsl:for-each>
                            <namePart>
                                <xsl:call-template name="specialSubfieldSelect">
                                    <xsl:with-param name="anyCodes">c</xsl:with-param>
                                    <xsl:with-param name="axis">t</xsl:with-param>
                                    <xsl:with-param name="beforeCodes">dgn</xsl:with-param>
                                </xsl:call-template>
                            </namePart>
                            <xsl:call-template name="role"/>
                        </name>
                        <xsl:call-template name="relatedForm"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '811'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '811')]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '811' or (@tag = '880' and not(../datafield[@tag = '811'][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem type="series">
                    <!-- 1.122 -->
                    <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '811')][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <titleInfo>
                            <xsl:call-template name="xxx880"/>
                            <xsl:variable name="this">

                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="specialSubfieldSelect">
                                            <xsl:with-param name="anyCodes">tfkls</xsl:with-param>
                                            <xsl:with-param name="axis">t</xsl:with-param>
                                            <xsl:with-param name="afterCodes">g</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <title>
                                <xsl:value-of select="normalize-space($this)"/>
                            </title>
                            <!-- 1.125 -->
                            <xsl:variable name="partNumber">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="specialSubfieldSelect">
                                            <xsl:with-param name="anyCodes">n</xsl:with-param>
                                            <xsl:with-param name="axis">t</xsl:with-param>
                                            <xsl:with-param name="afterCodes">n</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:if test="$partNumber != ''">
                                <partNumber>
                                    <xsl:value-of select="$partNumber"/>
                                </partNumber>
                            </xsl:if>
                            <!-- 1.120 - @800$v -->
                            <xsl:apply-templates select="subfield[@code = 'v']" mode="relatedItem"/>
                            <xsl:apply-templates select="subfield[@code = 'p']" mode="relatedItem"/>
                        </titleInfo>
                        <name type="conference">
                            <xsl:call-template name="xxx880"/>
                            <namePart>
                                <xsl:call-template name="specialSubfieldSelect">
                                    <xsl:with-param name="anyCodes">aqdc</xsl:with-param>
                                    <xsl:with-param name="axis">t</xsl:with-param>
                                    <xsl:with-param name="beforeCodes">gn</xsl:with-param>
                                </xsl:call-template>
                            </namePart>
                            <xsl:call-template name="role"/>
                        </name>
                        <xsl:call-template name="relatedForm"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '830'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '830')]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '830' or (@tag = '880' and not(../datafield[@tag = '830'][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem type="series">
                    <!-- 1.122 -->
                    <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '830')][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <titleInfo>
                            <xsl:call-template name="xxx880"/>
                            <xsl:variable name="this">

                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="subfieldSelect">
                                            <xsl:with-param name="codes">adfgklmors</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <title>
                                <xsl:value-of select="normalize-space($this)"/>
                            </title>
                            <!-- 1.120 - @830$v -->
                            <xsl:if test="subfield[@code = 'v']">
                                <partNumber>
                                    <xsl:call-template name="chopPunctuation">
                                        <xsl:with-param name="chopString">
                                            <xsl:call-template name="subfieldSelect">
                                                <xsl:with-param name="codes">v</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </partNumber>
                            </xsl:if>
                        </titleInfo>
                        <xsl:call-template name="relatedForm"/>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>
        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '856'][@ind2 = '2']/subfield[@code = 'q'] | datafield[@tag = '880'][@ind2 = '2'][subfield[@code = 'q']][starts-with(subfield[@code = '6'], '856')]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '856' or (@tag = '880' and not(../datafield[@tag = '856'][@ind2 = '2'][subfield[@code = 'q']][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem>
                    <xsl:for-each
                        select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '856')][@ind2 = '2'][substring(subfield[@code = '6'], 5, 2) = $s6]">
                        <!-- 1.120 - @856@ind2=2$q -->
                        <xsl:if test="subfield[@code = 'q']">
                            <physicalDescription>
                                <xsl:call-template name="xxx880"/>
                                <internetMediaType>
                                    <xsl:value-of select="subfield[@code = 'q']"/>
                                </internetMediaType>
                            </physicalDescription>
                        </xsl:if>
                        <xsl:if test="subfield[@code = 'u']">
                            <location>
                                <xsl:call-template name="xxx880"/>
                                <url>
                                    <xsl:if test="subfield[@code = 'y' or @code = '3']">
                                        <xsl:attribute name="displayLabel">
                                            <xsl:call-template name="subfieldSelect">
                                                <xsl:with-param name="codes">y3</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:if test="subfield[@code = 'z']">
                                        <xsl:attribute name="note">
                                            <xsl:call-template name="subfieldSelect">
                                                <xsl:with-param name="codes">z</xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <xsl:value-of select="subfield[@code = 'u']"/>
                                </url>
                            </location>
                        </xsl:if>
                    </xsl:for-each>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>


        <!-- @depreciated see 1.121 
		<xsl:for-each select="datafield[@tag='880']">
			<xsl:apply-templates select="self::*" mode="trans880"/>
		</xsl:for-each>
		-->


        <!-- 856, 020, 024, 022, 028, 010, 035, 037 -->

        <xsl:for-each select="datafield[@tag = '020']">
            <xsl:if test="subfield[@code = 'a']">
                <identifier type="isbn">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '020']">
            <xsl:if test="subfield[@code = 'z']">
                <identifier type="isbn" invalid="yes">
                    <xsl:value-of select="subfield[@code = 'z']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '024'][@ind1 = '0']">
            <xsl:if test="subfield[@code = 'a']">
                <identifier type="isrc">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '024'][@ind1 = '2']">
            <xsl:if test="subfield[@code = 'a']">
                <identifier type="ismn">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '024'][@ind1 = '4']">
            <identifier type="sici">
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">ab</xsl:with-param>
                </xsl:call-template>
            </identifier>
        </xsl:for-each>

        <!-- 1.107 WS -->
        <xsl:for-each select="datafield[@tag = '024'][@ind1 = '7']">
            <identifier>
                <xsl:if test="subfield[@code = '2']">
                    <xsl:attribute name="type">
                        <xsl:value-of select="subfield[@code = '2']"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="subfield[@code = 'a']"/>
            </identifier>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '024'][@ind1 = '8']">
            <identifier>
                <xsl:value-of select="subfield[@code = 'a']"/>
            </identifier>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '022'][subfield[@code = 'a']]">
            <xsl:if test="subfield[@code = 'a']">
                <identifier type="issn">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '022'][subfield[@code = 'z']]">
            <xsl:if test="subfield[@code = 'z']">
                <identifier type="issn" invalid="yes">
                    <xsl:value-of select="subfield[@code = 'z']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '022'][subfield[@code = 'y']]">
            <xsl:if test="subfield[@code = 'y']">
                <identifier type="issn" invalid="yes">
                    <xsl:value-of select="subfield[@code = 'y']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '022'][subfield[@code = 'l']]">
            <xsl:if test="subfield[@code = 'l']">
                <identifier type="issn-l">
                    <xsl:value-of select="subfield[@code = 'l']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '022'][subfield[@code = 'm']]">
            <xsl:if test="subfield[@code = 'm']">
                <identifier type="issn-l" invalid="yes">
                    <xsl:value-of select="subfield[@code = 'm']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>

        <!-- 1.162 NAL identifier from 001 -->
        <xsl:if test="controlfield[@tag = '001']">
            <identifier type="control">
                <xsl:value-of select="controlfield[@tag = '001']"/>
            </identifier>
        </xsl:if>

        <xsl:for-each select="datafield[@tag = '010'][subfield[@code = 'a']]">
            <identifier type="lccn">
                <xsl:value-of select="normalize-space(subfield[@code = 'a'])"/>
            </identifier>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '010'][subfield[@code = 'z']]">
            <identifier type="lccn" invalid="yes">
                <xsl:value-of select="normalize-space(subfield[@code = 'z'])"/>
            </identifier>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '028']">
            <identifier>
                <xsl:attribute name="type">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '1'">matrix number</xsl:when>
                        <xsl:when test="@ind1 = '2'">music plate</xsl:when>
                        <xsl:when test="@ind1 = '3'">music publisher</xsl:when>
                        <xsl:when test="@ind1 = '4'">videorecording identifier</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">
                        <xsl:choose>
                            <xsl:when test="@ind1 = '0'">ba</xsl:when>
                            <xsl:otherwise>ab</xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </identifier>
        </xsl:for-each>

        <!-- OCLC control number (035$a)-->
        <xsl:for-each
            select="datafield[@tag = '035'][subfield[@code = 'a'][contains(text(), '(OCoLC)')]]">
            <identifier type="oclc">
                <xsl:value-of
                    select="normalize-space(substring-after(subfield[@code = 'a'], '(OCoLC)'))"/>
            </identifier>
        </xsl:for-each>


        <!-- 3.5 1.95 20140421 -->
        <xsl:for-each
            select="datafield[@tag = '035'][subfield[@code = 'a'][contains(text(), '(WlCaITV)')]]">
            <identifier type="WlCaITV">
                <xsl:value-of
                    select="normalize-space(substring-after(subfield[@code = 'a'], '(WlCaITV)'))"/>
            </identifier>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '037']">
            <identifier type="stock number">
                <xsl:if test="subfield[@code = 'c']">
                    <xsl:attribute name="displayLabel">
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">c</xsl:with-param>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">ab</xsl:with-param>
                </xsl:call-template>
            </identifier>
        </xsl:for-each>


        <!-- 1.51 tmee 20100129-->
        <xsl:for-each select="datafield[@tag = '856'][subfield[@code = 'u']]">
            <xsl:if
                test="starts-with(subfield[@code = 'u'], 'urn:hdl') or starts-with(subfield[@code = 'u'], 'hdl') or starts-with(subfield[@code = 'u'], 'http://hdl.loc.gov')">
                <identifier>
                    <xsl:attribute name="type">
                        <xsl:if
                            test="starts-with(subfield[@code = 'u'], 'urn:doi') or starts-with(subfield[@code = 'u'], 'doi')"
                            >doi</xsl:if>
                        <xsl:if
                            test="starts-with(subfield[@code = 'u'], 'urn:hdl') or starts-with(subfield[@code = 'u'], 'hdl') or starts-with(subfield[@code = 'u'], 'http://hdl.loc.gov')"
                            >hdl</xsl:if>
                    </xsl:attribute>
                    <xsl:value-of
                        select="concat('hdl:', substring-after(subfield[@code = 'u'], 'http://hdl.loc.gov/'))"
                    />
                </identifier>
            </xsl:if>
            <xsl:if
                test="starts-with(subfield[@code = 'u'], 'urn:hdl') or starts-with(subfield[@code = 'u'], 'hdl')">
                <identifier type="hdl">
                    <xsl:if test="subfield[@code = 'y' or @code = '3' or @code = 'z']">
                        <xsl:attribute name="displayLabel">
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">y3z</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of
                        select="concat('hdl:', substring-after(subfield[@code = 'u'], 'http://hdl.loc.gov/'))"
                    />
                </identifier>
            </xsl:if>
        </xsl:for-each>

        <!-- 1.161 AGRICOLA accesssion ID -->
        <xsl:for-each select="datafield[@tag = '016'][subfield[@code = 'a']]">
            <identifier type="agricola">
                <xsl:value-of select="normalize-space(subfield[@code = 'a'])"/>
            </identifier>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '024'][@ind1 = 1]">
            <identifier type="upc">
                <xsl:value-of select="subfield[@code = 'a']"/>
            </identifier>
        </xsl:for-each>

        <!--1.163 agid # -->
        <xsl:for-each select="datafield[@tag = '974']">
            <identifier type="local">
                <!-- $a agid: -->
                <xsl:value-of select="subfield[@code = 'a']"/>
            </identifier>
        </xsl:for-each>


        <!-- 1.121 -->
        <xsl:for-each
            select="datafield[@tag = '856'][@ind2 = 2][subfield[@code = 'u']] | datafield[@tag = '880'][@ind2 = 2][subfield[@code = 'u']][starts-with(subfield[@code = '6'], '856')]">
            <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
            <xsl:if
                test="@tag = '856' or (@tag = '880' and not(../datafield[@tag = '856'][@ind2 = 2][subfield[@code = 'u']][substring(subfield[@code = '6'], 5, 2) = $s6]))">
                <relatedItem>
                    <location>
                        <url>
                            <xsl:if test="subfield[@code = 'y' or @code = '3']">
                                <xsl:attribute name="displayLabel">
                                    <xsl:call-template name="subfieldSelect">
                                        <xsl:with-param name="codes">y3</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:if test="subfield[@code = 'z']">
                                <xsl:attribute name="note">
                                    <xsl:call-template name="subfieldSelect">
                                        <xsl:with-param name="codes">z</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="subfield[@code = 'u']"/>
                        </url>
                    </location>
                </relatedItem>
            </xsl:if>
        </xsl:for-each>

        <!--NAL notes 910, 930, 945, 946, 
          '974': removed from extension and placed under 016 Agricola accession numbmer  -->
        <extension>
            <xsl:call-template name="createNoteFrom910"/>
            <xsl:call-template name="createNoteFrom930"/>
            <xsl:call-template name="createNoteFrom945"/>
            <xsl:call-template name="createNoteFrom946"/>
        </extension>

        <recordInfo>
            <xsl:for-each select="leader[substring($marcLeader, 19, 1) = 'a']">
                <descriptionStandard>aacr</descriptionStandard>
            </xsl:for-each>

            <xsl:for-each select="datafield[@tag = '040']">
                <xsl:if test="subfield[@code = 'e']">
                    <descriptionStandard>
                        <xsl:value-of select="subfield[@code = 'e']"/>
                    </descriptionStandard>
                </xsl:if>
                <recordContentSource authority="marcorg">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </recordContentSource>
            </xsl:for-each>
            <xsl:for-each select="controlfield[@tag = '008']">
                <recordCreationDate encoding="marc">
                    <xsl:value-of select="substring(., 1, 6)"/>
                </recordCreationDate>
            </xsl:for-each>

            <xsl:for-each select="controlfield[@tag = '005']">
                <recordChangeDate encoding="iso8601">
                    <xsl:value-of select="."/>
                </recordChangeDate>
            </xsl:for-each>
            <xsl:for-each select="controlfield[@tag = '001']">
                <recordIdentifier>
                    <xsl:if test="../controlfield[@tag = '003']">
                        <xsl:attribute name="source">
                            <xsl:value-of select="../controlfield[@tag = '003']"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </recordIdentifier>
            </xsl:for-each>

            <!-- 1.150 -->
            <recordOrigin>
                <xsl:variable name="transform"
                    select="string(tokenize(base-uri(document('')), '/')[last()])" as="xs:string"/>
                <xsl:variable name="date"
                    select="replace(string(current-date()), '(\d{4}\-\d{2}\-\d{2})(.*)', '$1')"/>
                <xsl:value-of
                    select="normalize-space(concat('Converted from MARCXML to MODS version 3.7 using', ' ', $transform, ' ', '(NAL-MARC21slim2MODS3-7.xsl (Revision 1.167) 20230106 cm3),'))"/>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="normalize-space(concat('Transformed on: ', $date))"/>
            </recordOrigin>

            <xsl:for-each select="datafield[@tag = '040']/subfield[@code = 'b']">
                <languageOfCataloging>
                    <languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="."/>
                    </languageTerm>
                </languageOfCataloging>
            </xsl:for-each>

        </recordInfo>
    </xsl:template>

    <!--1.165 -->
    <xd:doc id="personal_name" scope="component">
        <xd:desc>formerly named displayForm template</xd:desc>
    </xd:doc>
    <xsl:template name="personal_name">     
        <xsl:variable name="name">
            <xsl:call-template name="specialSubfieldSelect">
                <xsl:with-param name="anyCodes">aq</xsl:with-param>
                <xsl:with-param name="axis">t</xsl:with-param>
                <xsl:with-param name="beforeCodes">g</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:for-each select="$name">
            <namePart type="given">
                <xsl:choose>
                    <!-- initials only -->
                    <xsl:when
                        test="matches(substring-after($name, ','), '([A-Z]\.$|[A-Z]\.[A-Z]\.$)')">
                        <xsl:value-of
                            select="f:proper-case(normalize-space(substring-after($name, ',')))"/>
                    </xsl:when>
                    <!-- first name-->
                    <xsl:otherwise>
                        <xsl:value-of
                            select="f:proper-case(normalize-space(replace(substring-after($name, ','), '(\s)(.*)(,|\.)', '$2')))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </namePart>

            <namePart type="family">
                <xsl:value-of select="f:proper-case(substring-before(normalize-space($name), ','))"
                />
            </namePart>
            <displayForm>
                <xsl:choose>
                    <!--last_name, initals only-->
                    <xsl:when test="matches(substring-after(., ','), '([A-Z]\.$|[A-Z]\.[A-Z]\.$)')">
                        <xsl:value-of select="f:proper-case($name)"/>
                    </xsl:when>
                    <!-- last_name, first_name -->
                    <xsl:otherwise>
                        <xsl:value-of select="replace(f:proper-case($name), '(.*,.*)(,|\.)', '$1')"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </displayForm>
            <!--orcID, viaf, lcnaf, etc. -->
        </xsl:for-each>
        <xsl:for-each select="../datafield[@tag='100' or @tag='700']/subfield[@code='1']">
            <nameIdentifier>
                <xsl:choose>
                    <xsl:when test="matches(../subfield[@code='1'],'orcid|viaf|isni|[a-z0-9]+') = true()">
                        <xsl:attribute name="type" select="replace(string(../subfield[@code = '1']),'(^https?)://(www)?(\w+)((\.\w+)(\.\w+)?(\.\w+)?)/?(\S+)/?(\?uri=)?(.*)','$3')"/>
                    </xsl:when>
                    <xsl:when test="matches(../subfield[@code='1'],'id.loc.gov|id.nlm.nih.gov|lod.nal.usda.gov|agclass.nal.usda.gov|[a-z]+')=true()">
                        <xsl:attribute name="type" select="replace(string(../subfield[@code = '1']),'(^https?)://(www)?(\w+)((\.\w+)(\.\w+)?(\.\w+)?)/?(\S+)/?(\?uri=)?(.*)','$3$4')"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="../subfield[@code = '1']"/>
            </nameIdentifier>
        </xsl:for-each>                
    </xsl:template>
   
    <!--<xd:doc>
        <xd:desc/>
        <xd:param name="selectType"/>
    </xd:doc>
    <xsl:template name="nameIdAttr">
        <xsl:param name="selectType" select="../subfield[@code='1']" tunnel="yes"/>
        <xsl:attribute name="type">
        <xsl:if test="$selectType">
                 <xsl:analyze-string select="$selectType"
                    regex="(^https?)://(www)?(\w+)((\.\w+)(\.\w+)?(\.\w+)?)/?(\S+)/?(\?uri=)?(.*)">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(3)"/>
                    </xsl:matching-substring>
                 </xsl:analyze-string>
              </xsl:if>
        </xsl:attribute>
    </xsl:template>-->
    <!-- Abstract -->
    <!-- <xd:doc>
        <xd:desc><xd:p><xd:b>nameIdentifier @type="$typeValue"</xd:b></xd:p></xd:desc>
        <xd:param name="nameIdUri"/>
    </xd:doc>
    <xsl:template match="//datafield[@tag='100' or @tag='700']/subfield[@code='1']" mode="name_authority">
        <xsl:param name="nameIdUri" as="xs:string"/>
            <xsl:variable name="typeValue" as="xs:string" select="replace($nameIdUri,'(^https?:\/\/)(www.)?(\w+)(\.)(\w+)(\.\w+)?', '$3$4')"/>
                <xsl:choose>
                   <xsl:when test="starts-with($typeValue,'orcid')">
                       <xsl:attribute name="type">     
                       <xsl:text>orcid</xsl:text>
                       </xsl:attribute>
                   </xsl:when>
                   <xsl:when test="starts-with($typeValue,'viaf')">
                       <xsl:attribute name="type">     
                              <xsl:text>viaf</xsl:text>
                           </xsl:attribute>
                   </xsl:when>
                   <xsl:when test="starts-with($typeValue,'id.loc.gov')">
                       <xsl:attribute name="type">
                           <xsl:text>lcnaf</xsl:text>
                       </xsl:attribute>
                   </xsl:when>
                   <xsl:when test="starts-with($typeValue,'lod.nal.usda.gov|agclass.nal.usda.gov')">
                       <xsl:attribute name="type">    
                       <xsl:text>nalt</xsl:text>
                       </xsl:attribute>
                   </xsl:when>
                   <xsl:when test="starts-with($typeValue,'id.nlm.nih.gov')">
                       <xsl:text>mesh</xsl:text>
                   </xsl:when>
                   <xsl:otherwise>                
                    <xsl:analyze-string select="concat(regex-group(3), regex-group(4))" regex="(\w+)(.*)">
                        <xsl:matching-substring>
                            <xsl:attribute name="typeURI">
                            <xsl:choose>
                                <xsl:when test="starts-with(regex-group(3), 'id')">
                                        <xsl:value-of select="concat(regex-group(3),regex-group(4))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <value-of select="regex-group(3)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            </xsl:attribute>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                    </xsl:otherwise>
                </xsl:choose>
    </xsl:template>-->

    <xd:doc id="affiliation" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="affiliation">
        <xsl:for-each select="subfield[@code = 'u']">
            <affiliation>
                <xsl:value-of select="normalize-space(.)"/>
            </affiliation>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="uri" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="uri">
        <xsl:for-each select="subfield[@code = 'u'] | subfield[@code = '0']">
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="role" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="role">
        <xsl:for-each select="subfield[@code = 'e']">
            <role>
                <roleTerm type="text">
                    <!-- 1.126 -->
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="."/>
                        </xsl:with-param>
                    </xsl:call-template>
                </roleTerm>
            </role>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = '4']">
            <role>
                <roleTerm authority="marcrelator" type="code">
                    <xsl:value-of select="."/>
                </roleTerm>
            </role>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="part" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="part">
        <xsl:variable name="partNumber">
            <xsl:call-template name="specialSubfieldSelect">
                <xsl:with-param name="axis">n</xsl:with-param>
                <xsl:with-param name="anyCodes">n</xsl:with-param>
                <xsl:with-param name="afterCodes">fgkdlmor</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="partName">
            <xsl:choose>
                <!-- 1.120 -->
                <xsl:when
                    test="@tag = '700' or @tag = '800' or @tag = '710' or @tag = '810' or @tag = '711' or @tag = '811' or @tag = '730' or @tag = '830' or @tag = '740' or @tag = '440'">
                    <xsl:value-of select="subfield[@code = 'p']"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="specialSubfieldSelect">
                        <xsl:with-param name="axis">p</xsl:with-param>
                        <xsl:with-param name="anyCodes">p</xsl:with-param>
                        <xsl:with-param name="afterCodes">fgkdlmor</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="string-length(normalize-space($partNumber))">
            <partNumber>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="$partNumber"/>
                </xsl:call-template>
            </partNumber>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($partName))">
            <partName>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="$partName"/>
                </xsl:call-template>
            </partName>
        </xsl:if>
    </xsl:template>
    <xd:doc id="relatedPart" scope="component">
        <xd:desc> @depreciated see 1.121 </xd:desc>
    </xd:doc>
    <xsl:template name="relatedPart">
        <xsl:if test="@tag = '773'">
            <xsl:for-each select="subfield[@code = 'g']">
                <part>
                    <xsl:call-template name="xxs880"/>
                    <text>
                        <xsl:value-of select="."/>
                    </text>
                </part>
            </xsl:for-each>
            <xsl:for-each select="subfield[@code = 'q']">
                <part>
                    <xsl:call-template name="xxs880"/>
                    <xsl:call-template name="parsePart"/>
                </part>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xd:doc id="relatedPartNumName" scope="component">
        <xd:desc>relatedPartNumName</xd:desc>
    </xd:doc>
    <xsl:template name="relatedPartNumName">
        <xsl:variable name="partNumber">
            <xsl:call-template name="specialSubfieldSelect">
                <xsl:with-param name="axis">g</xsl:with-param>
                <xsl:with-param name="anyCodes">g</xsl:with-param>
                <xsl:with-param name="afterCodes">pst</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="partName">
            <xsl:call-template name="specialSubfieldSelect">
                <xsl:with-param name="axis">p</xsl:with-param>
                <xsl:with-param name="anyCodes">p</xsl:with-param>
                <xsl:with-param name="afterCodes">fgkdlmor</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length(normalize-space($partNumber))">
            <partNumber>
                <xsl:value-of select="$partNumber"/>
            </partNumber>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($partName))">
            <partName>
                <xsl:value-of select="$partName"/>
            </partName>
        </xsl:if>
    </xsl:template>

    <xd:doc id="relatedItem" scope="component">
        <xd:desc>subfield[@code = 'g']: 1.120 - @76X-78X$g </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = 'g']" mode="relatedItem">
        <partNumber>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                    <xsl:value-of select="."/>
                </xsl:with-param>
            </xsl:call-template>
        </partNumber>
    </xsl:template>

    <xd:doc id="relatedItem" scope="component">
        <xd:desc>subfield[@code = 'n'] | subfield[@code = 'v']: 1.120 - @800$v </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = 'n'] | subfield[@code = 'v']" mode="relatedItem">
        <partNumber>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                    <xsl:value-of select="."/>
                </xsl:with-param>
            </xsl:call-template>
        </partNumber>
    </xsl:template>
    <!-- @800$p NOTE: does not output for 800, check mapping-->

    <xd:doc id="relatedItem" scope="component">
        <xd:desc>subfield[@code = 'p']: Create related item title part name </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = 'p']" mode="relatedItem">
        <!-- NOTE: old stylesheet outputs code p for 740, mapping does not indicate this -->
        <!-- @700$t$p partnumber -->
        <partName>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString">
                    <xsl:value-of select="."/>
                </xsl:with-param>
            </xsl:call-template>
        </partName>
    </xsl:template>

    <xd:doc id="xlink" scope="component">
        <xd:desc>subfield[@code = '0']: 1.122 </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = '0']" mode="xlink">
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xd:doc id="relatedName" scope="component">
        <xd:desc>relatedName</xd:desc>
    </xd:doc>
    <xsl:template name="relatedName">
        <xsl:for-each select="subfield[@code = 'a']">
            <name>
                <!-- 1.121 -->
                <xsl:call-template name="xxs880"/>
                <namePart>
                    <xsl:value-of select="."/>
                </namePart>
            </name>
        </xsl:for-each>
    </xsl:template>

    <xd:doc id="valueURI" scope="component">
        <xd:desc> 1.139 </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = '0']" mode="valueURI">
        <xsl:attribute name="valueURI">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xd:doc id="relatedForm" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="relatedForm">
        <xsl:for-each select="subfield[@code = 'h']">
            <physicalDescription>
                <!-- 1.121 -->
                <xsl:call-template name="xxs880"/>
                <form>
                    <xsl:value-of select="."/>
                </form>
            </physicalDescription>
        </xsl:for-each>
    </xsl:template>

    <xd:doc id="relatedExtent" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="relatedExtent">
        <xsl:for-each select="subfield[@code = 'h']">
            <physicalDescription>
                <!-- 1.121 -->
                <xsl:call-template name="xxs880"/>
                <extent>
                    <xsl:value-of select="."/>
                </extent>
            </physicalDescription>
        </xsl:for-each>
    </xsl:template>

    <xd:doc id="relatedNote" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="relatedNote">
        <xsl:for-each select="subfield[@code = 'n']">
            <!-- 1.121 -->
            <xsl:call-template name="xxs880"/>
            <note>
                <xsl:value-of select="."/>
            </note>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="relatedSubject">
        <xsl:for-each select="subfield[@code = 'j']">
            <subject>
                <!-- 1.121 -->
                <xsl:call-template name="xxs880"/>
                <temporal encoding="iso8601">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                </temporal>
            </subject>
        </xsl:for-each>
    </xsl:template>

    <xd:doc id="relatedIdentifierISSN" scope="component">
        <xd:desc> 1.120 - @76X-78X$z </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = 'x']" mode="relatedItem">
        <identifier type="issn">
            <!-- 1.121 -->
            <xsl:call-template name="xxs880"/>
            <xsl:apply-templates/>
        </identifier>
    </xsl:template>

    <xd:doc id="relatedItemX" scope="component">
        <xd:desc> 1.168 </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = 'x']" mode="relatedItemX">
        <identifier type="issn">
            <!-- 1.168 -->
            <xsl:call-template name="xxs880"/>
            <xsl:apply-templates/>
        </identifier>
    </xsl:template>

    <xd:doc id="relatedIdentifierISSN" scope="component">
        <xd:desc> 1.120 - @76X-78X$z </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = 'w']" mode="relatedItem">
        <identifier type="issn">
            <!-- 1.121 -->
            <xsl:call-template name="xxs880"/>
            <xsl:apply-templates/>
        </identifier>
    </xsl:template>

    <xd:doc>
        <xd:desc> "Journal-ID number (e.g.,"Journal:jnl54321")/(i.e.,MARC914$a) is mapped into
            [identifier @type]="local"</xd:desc>
    </xd:doc>
    <xsl:template match="datafield[@tag = '914']/subfield[@code = 'a']" mode="relatedItem914">
        <identifier type="local">
            <!-- 1.168 -->
            <xsl:value-of select="../subfield[@code = 'a']"/>
        </identifier>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="subfield[@code = 'o']" mode="relatedItemOf"/>

    <!--  <xd:doc>
        <xd:desc/>
    </xd:doc>
        <xsl:template match="subfield[@code = 'o']" mode="relatedItem">
        <identifier>
            <!-\- 1.121 -\->
            <xsl:call-template name="xxs880"/>
            <xsl:apply-templates/>
        </identifier>
    </xsl:template>
-->
    <!-- 1.121 -->
    <xd:doc>
        <xd:desc> Creates related item notes </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = 'n']" mode="relatedItemNote">
        <note>
            <xsl:call-template name="xxs880"/>
            <xsl:value-of select="."/>
        </note>
    </xsl:template>
    <!-- 1.121 -->
    <xd:doc>
        <xd:desc> Creates related item form </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = 'h']" mode="relatedItem">
        <physicalDescription>
            <xsl:call-template name="xxs880"/>
            <form>
                <xsl:apply-templates/>
            </form>
        </physicalDescription>
    </xsl:template>
    <!-- 1.121 -->
    <xd:doc>
        <xd:desc> Creates related item subjects </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = 'j']" mode="relatedItem">
        <subject>
            <xsl:call-template name="xxs880"/>
            <temporal encoding="iso8601">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
            </temporal>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc> 1.121 Creates related item names </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = 'a']" mode="relatedItem">
        <name>
            <xsl:call-template name="xxs880"/>
            <namePart>
                <!-- 1.126 -->
                <xsl:value-of select="."/>
            </namePart>
        </name>
    </xsl:template>

    <!--tmee 1.40 510 isReferencedBy -->

    <xd:doc>
        <xd:desc> @depreciated - no longer used </xd:desc>
    </xd:doc>
    <!-- <xsl:template name="relatedItem510">
        <xsl:call-template name="displayLabel"/>
        <xsl:call-template name="relatedTitle76X-78X"/>
        <xsl:call-template name="relatedName"/>
        <xsl:call-template name="relatedOriginInfo510"/>
        <xsl:call-template name="relatedLanguage"/>
        <xsl:call-template name="relatedExtent"/>
        <xsl:call-template name="relatedNote"/>
        <xsl:call-template name="relatedSubject"/>
        <xsl:call-template name="relatedIdentifier"/>
        <xsl:call-template name="relatedIdentifierISSN"/>
        <xsl:call-template name="relatedIdentifierLocal"/>
    </xsl:template>-->


    <xd:doc>
        <xd:desc> @depreciated - no longer used see 1.121</xd:desc>
    </xd:doc>
    <!--		<xsl:template name="relatedItem76X-78X">
        <xsl:call-template name="displayLabel"/>
        <xsl:call-template name="relatedTitle76X-78X"/>
        <xsl:call-template name="relatedName"/>
        <xsl:call-template name="relatedOriginInfo"/>
        <xsl:call-template name="relatedLanguage"/>
        <xsl:call-template name="relatedExtent"/>
        <xsl:call-template name="relatedNote"/>
        <xsl:call-template name="relatedSubject"/>
        <xsl:call-template name="relatedIdentifier"/>
        <xsl:call-template name="relatedIdentifierISSN"/>
        <xsl:call-template name="relatedIdentifierLocal"/>
    </xsl:template>-->

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="subjectGeographicZ">
        <geographic>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
        </geographic>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="subjectTemporalY">
        <temporal>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
        </temporal>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="subjectTopic">
        <topic>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
        </topic>
    </xsl:template>
    <xd:doc id="subjectGenre" scope="component">
        <xd:desc> 3.2 change tmee 6xx $v genre </xd:desc>
    </xd:doc>
    <xsl:template name="subjectGenre">
        <genre>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
        </genre>
    </xsl:template>

    <xd:doc id="nameABCDN" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="nameABCDN">
        <xsl:for-each select="subfield[@code = 'a']">
            <namePart>
                <!-- 1.126 -->
                <xsl:value-of select="."/>
            </namePart>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'b']">
            <namePart>
                <xsl:value-of select="."/>
            </namePart>
        </xsl:for-each>
        <xsl:if test="subfield[@code = 'c'] or subfield[@code = 'd'] or subfield[@code = 'n']">
            <namePart>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">cdn</xsl:with-param>
                </xsl:call-template>
            </namePart>
        </xsl:if>
    </xsl:template>

    <xd:doc id="nameABCDQ" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="nameABCDQ">
        <namePart>
            <!-- 1.126 -->
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">aq</xsl:with-param>
            </xsl:call-template>
        </namePart>
        <xsl:call-template name="termsOfAddress"/>
        <xsl:call-template name="nameDate"/>
    </xsl:template>
    <xd:doc id="nameACDEQ" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="nameACDEQ">
        <namePart>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">acdeq</xsl:with-param>
            </xsl:call-template>
        </namePart>
    </xsl:template>
    <xd:doc id="nameACDENQ" scope="component">
        <xd:desc>1.104 20141104</xd:desc>
    </xd:doc>
    <xsl:template name="nameACDENQ">
        <namePart>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">acdenq</xsl:with-param>
            </xsl:call-template>
        </namePart>
    </xsl:template>
    <xd:doc id="nameIdentifier" scope="component">
        <xd:desc> 1.116 </xd:desc>
    </xd:doc>
    <xsl:template name="nameIdentifier">
        <xsl:if test="subfield[@code = '0']">
            <nameIdentifier>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">0</xsl:with-param>
                </xsl:call-template>
            </nameIdentifier>
        </xsl:if>
    </xsl:template>


    <xd:doc id="constituentOrRelatedType" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="constituentOrRelatedType">
        <xsl:if test="@ind2 = '2'">
            <xsl:attribute name="type">constituent</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xd:doc id="relatedTitle" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="relatedTitle">
        <xsl:for-each select="subfield[@code = 't']">
            <titleInfo>
                <!-- 1.121 -->
                <xsl:call-template name="xxs880"/>
                <xsl:variable name="this">

                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="."/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <title>
                    <xsl:value-of select="normalize-space($this)"/>
                </title>
            </titleInfo>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="relatedTitle76X-78X">
        <xsl:for-each select="subfield[@code = 't']">
            <titleInfo>
                <!-- 1.121 -->
                <xsl:call-template name="xxs880"/>
                <xsl:variable name="this">

                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="."/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <title>
                    <xsl:value-of select="normalize-space($this)"/>
                </title>
                <!-- 1.120 - @76X-78X$g -->
                <xsl:if test="parent::*[@tag != 773] and ../subfield[@code = 'g']">
                    <xsl:apply-templates select="../subfield[@code = 'g']" mode="relatedItem"/>
                </xsl:if>
            </titleInfo>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'p']">
            <titleInfo type="abbreviated">
                <!-- 1.121 -->
                <xsl:call-template name="xxs880"/>
                <xsl:variable name="this">

                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="."/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <title>
                    <xsl:value-of select="normalize-space($this)"/>
                </title>
                <!-- 1.120 - @76X-78X$g -->
                <xsl:if test="parent::*[@tag != 773] and ../subfield[@code = 'g']">
                    <xsl:apply-templates select="../subfield[@code = 'g']" mode="relatedItem"/>
                </xsl:if>
            </titleInfo>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 's']">
            <titleInfo type="uniform">
                <xsl:call-template name="xxs880"/>
                <xsl:variable name="this">

                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="."/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <title>
                    <xsl:value-of select="normalize-space($this)"/>
                </title>
                <!-- 1.120 - @76X-78X$g -->
                <xsl:if test="parent::*[@tag != 773] and ../subfield[@code = 'g']">
                    <xsl:apply-templates select="../subfield[@code = 'g']" mode="relatedItem"/>
                </xsl:if>
            </titleInfo>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="relatedOriginInfo">
        <xsl:if test="subfield[@code = 'b' or @code = 'd'] or subfield[@code = 'f']">
            <originInfo>
                <xsl:if test="@tag = '775'">
                    <xsl:for-each select="subfield[@code = 'f']">
                        <place>
                            <placeTerm>
                                <xsl:attribute name="type">code</xsl:attribute>
                                <xsl:attribute name="authority">marcgac</xsl:attribute>
                                <xsl:value-of select="."/>
                            </placeTerm>
                        </place>
                    </xsl:for-each>
                </xsl:if>
                <xsl:for-each select="subfield[@code = 'd']">
                    <publisher>
                        <xsl:value-of select="."/>
                    </publisher>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'b']">
                    <edition>
                        <xsl:value-of select="."/>
                    </edition>
                </xsl:for-each>
            </originInfo>
        </xsl:if>
    </xsl:template>
    <xd:doc id="relatedOriginInfo510" scope="component">
        <xd:desc> tmee 1.40 </xd:desc>
    </xd:doc>
    <xsl:template name="relatedOriginInfo510">
        <xsl:for-each select="subfield[@code = 'b']">
            <originInfo>
                <dateOther type="coverage">
                    <xsl:value-of select="."/>
                </dateOther>
            </originInfo>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="relatedLanguage">
        <xsl:for-each select="subfield[@code = 'e']">
            <xsl:call-template name="getLanguage">
                <xsl:with-param name="langString">
                    <xsl:value-of select="."/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="nameDate">
        <xsl:for-each select="subfield[@code = 'd']">
            <namePart type="date">
                <!-- 1.126 -->
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </namePart>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="subjectAuthority">
        <xsl:if test="@ind2 != 4">
            <xsl:if test="@ind2 != ' '">
                <xsl:if test="@ind2 != 8">
                    <xsl:if test="@ind2 != 9">
                        <xsl:attribute name="authority">
                            <xsl:choose>
                                <xsl:when test="@ind2 = 0">lcsh</xsl:when>
                                <xsl:when test="@ind2 = 1">lcshac</xsl:when>
                                <xsl:when test="@ind2 = 2">mesh</xsl:when>
                                <!-- 1/04 fix -->
                                <xsl:when test="@ind2 = 3">atg</xsl:when>
                                <xsl:when test="@ind2 = 5">csh</xsl:when>
                                <xsl:when test="@ind2 = 6">rvm</xsl:when>
                                <xsl:when test="@ind2 = 7">
                                    <xsl:value-of select="subfield[@code = '2']"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xd:doc id="subject653Type" scope="component">
        <xd:desc> 1.75 fix </xd:desc>
    </xd:doc>
    <xsl:template name="subject653Type">
        <xsl:if test="@ind2 != ' '">
            <xsl:if test="@ind2 != '0'">
                <xsl:if test="@ind2 != '4'">
                    <xsl:if test="@ind2 != '5'">
                        <xsl:if test="@ind2 != '6'">
                            <xsl:if test="@ind2 != '7'">
                                <xsl:if test="@ind2 != '8'">
                                    <xsl:if test="@ind2 != '9'">
                                        <xsl:attribute name="type">
                                            <xsl:choose>
                                                <xsl:when test="@ind2 = 1">personal</xsl:when>
                                                <xsl:when test="@ind2 = 2">corporate</xsl:when>
                                                <xsl:when test="@ind2 = 3">conference</xsl:when>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:if>


    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="subjectAnyOrder">
        <xsl:for-each select="subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z']">
            <xsl:choose>
                <xsl:when test="@code = 'v'">
                    <xsl:call-template name="subjectGenre"/>
                </xsl:when>
                <xsl:when test="@code = 'x'">
                    <xsl:call-template name="subjectTopic"/>
                </xsl:when>
                <xsl:when test="@code = 'y'">
                    <xsl:call-template name="subjectTemporalY"/>
                </xsl:when>
                <xsl:when test="@code = 'z'">
                    <xsl:call-template name="subjectGeographicZ"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="anyCodes"/>
        <xd:param name="axis"/>
        <xd:param name="beforeCodes"/>
        <xd:param name="afterCodes"/>
    </xd:doc>
    <xsl:template name="specialSubfieldSelect">
        <xsl:param name="anyCodes"/>
        <xsl:param name="axis"/>
        <xsl:param name="beforeCodes"/>
        <xsl:param name="afterCodes"/>
        <xsl:variable name="str">
            <xsl:for-each select="subfield">
                <xsl:if
                    test="contains($anyCodes, @code) or (contains($beforeCodes, @code) and following-sibling::subfield[@code = $axis]) or (contains($afterCodes, @code) and preceding-sibling::subfield[@code = $axis])">
                    <xsl:value-of select="text()"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
    </xsl:template>


    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="datafield[@tag = '656']">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:if test="subfield[@code = 2]">
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = 2]"/>
                </xsl:attribute>
            </xsl:if>
            <occupation>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="subfield[@code = 'a']"/>
                    </xsl:with-param>
                </xsl:call-template>
            </occupation>
        </subject>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="termsOfAddress">
        <xsl:if test="subfield[@code = 'b' or @code = 'c']">
            <namePart type="termsOfAddress">
                <!-- 1.126 -->
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">bc</xsl:with-param>
                </xsl:call-template>
            </namePart>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="displayLabel">
        <xsl:if test="subfield[@code = 'i']">
            <xsl:attribute name="displayLabel">
                <xsl:value-of select="subfield[@code = 'i']"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="subfield[@code = '3']">
            <xsl:attribute name="displayLabel">
                <xsl:value-of select="subfield[@code = '3']"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc> isInvalid</xd:desc>
        <xd:param name="type"/>
    </xd:doc>
    <xsl:template name="isInvalid">
        <xsl:param name="type"/>
        <xsl:if test="subfield[@code = 'z'] or subfield[@code = 'y'] or subfield[@code = 'm']">
            <identifier>
                <xsl:attribute name="type">
                    <xsl:value-of select="$type"/>
                </xsl:attribute>
                <xsl:attribute name="invalid">
                    <xsl:text>yes</xsl:text>
                </xsl:attribute>
                <xsl:if test="subfield[@code = 'z']">
                    <xsl:value-of select="subfield[@code = 'z']"/>
                </xsl:if>
                <xsl:if test="subfield[@code = 'y']">
                    <xsl:value-of select="subfield[@code = 'y']"/>
                </xsl:if>
                <xsl:if test="subfield[@code = 'm']">
                    <xsl:value-of select="subfield[@code = 'm']"/>
                </xsl:if>
            </identifier>
        </xsl:if>
    </xsl:template>
    <xd:doc id="subtitle" scope="component">
        <xd:desc>subtitle</xd:desc>
    </xd:doc>
    <xsl:template name="subtitle">
        <xsl:if test="subfield[@code = 'b']">
            <subTitle>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="subfield[@code = 'b']"/>
                    </xsl:with-param>
                </xsl:call-template>
            </subTitle>
        </xsl:if>
    </xsl:template>
    <xd:doc id="script" scope="component">
        <xd:desc>script</xd:desc>
        <xd:param name="scriptCode"/>
    </xd:doc>
    <xsl:template name="script">

        <xsl:param name="scriptCode"/>
        <xsl:attribute name="script">
            <xsl:choose>
                <!-- ISO 15924	and CJK is a local code	20101123-->
                <xsl:when test="$scriptCode = '(3'">Arab</xsl:when>
                <xsl:when test="$scriptCode = '(4'">Arab</xsl:when>
                <xsl:when test="$scriptCode = '(B'">Latn</xsl:when>
                <xsl:when test="$scriptCode = '!E'">Latn</xsl:when>
                <xsl:when test="$scriptCode = '$1'">CJK</xsl:when>
                <xsl:when test="$scriptCode = '(N'">Cyrl</xsl:when>
                <xsl:when test="$scriptCode = '(Q'">Cyrl</xsl:when>
                <xsl:when test="$scriptCode = '(2'">Hebr</xsl:when>
                <xsl:when test="$scriptCode = '(S'">Grek</xsl:when>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="parsePart">
        <!-- assumes 773$q= 1:2:3<4
		     with up to 3 levels and one optional start page
		-->
        <xsl:variable name="level1">
            <xsl:choose>
                <xsl:when test="contains(text(), ':')">
                    <!-- 1:2 -->
                    <xsl:value-of select="substring-before(text(), ':')"/>
                </xsl:when>
                <xsl:when test="not(contains(text(), ':'))">
                    <!-- 1 or 1<3 -->
                    <xsl:if test="contains(text(), '&lt;')">
                        <!-- 1<3 -->
                        <xsl:value-of select="substring-before(text(), '&lt;')"/>
                    </xsl:if>
                    <xsl:if test="not(contains(text(), '&lt;'))">
                        <!-- 1 -->
                        <xsl:value-of select="text()"/>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sici2">
            <xsl:choose>
                <xsl:when test="starts-with(substring-after(text(), $level1), ':')">
                    <xsl:value-of select="substring(substring-after(text(), $level1), 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(text(), $level1)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="level2">
            <xsl:choose>
                <xsl:when test="contains($sici2, ':')">
                    <!--  2:3<4  -->
                    <xsl:value-of select="substring-before($sici2, ':')"/>
                </xsl:when>
                <xsl:when test="contains($sici2, '&lt;')">
                    <!-- 1: 2<4 -->
                    <xsl:value-of select="substring-before($sici2, '&lt;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$sici2"/>
                    <!-- 1:2 -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sici3">
            <xsl:choose>
                <xsl:when test="starts-with(substring-after($sici2, $level2), ':')">
                    <xsl:value-of select="substring(substring-after($sici2, $level2), 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after($sici2, $level2)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="level3">
            <xsl:choose>
                <xsl:when test="contains($sici3, '&lt;')">
                    <!-- 2<4 -->
                    <xsl:value-of select="substring-before($sici3, '&lt;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$sici3"/>
                    <!-- 3 -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="page">
            <xsl:if test="contains(text(), '&lt;')">
                <xsl:value-of select="substring-after(text(), '&lt;')"/>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="$level1">
            <detail level="1">
                <number>
                    <xsl:value-of select="$level1"/>
                </number>
            </detail>
        </xsl:if>
        <xsl:if test="$level2">
            <detail level="2">
                <number>
                    <xsl:value-of select="$level2"/>
                </number>
            </detail>
        </xsl:if>
        <xsl:if test="$level3">
            <detail level="3">
                <number>
                    <xsl:value-of select="$level3"/>
                </number>
            </detail>
        </xsl:if>
        <xsl:if test="$page">
            <extent unit="page">
                <start>
                    <xsl:value-of select="$page"/>
                </start>
            </extent>
        </xsl:if>
    </xsl:template>

    <!-- 008 language -->

    <xd:doc>
        <xd:desc>Revision 2.05 controlField008-35-37replace, uses replace function and regex to
            pinpoint 3 letter string</xd:desc>
        <xd:param name="controlField008-35-37p"/>
    </xd:doc>
    <xsl:template name="filteredForLanguage">
        <xsl:param name="controlField008-35-37p"/>
        <xsl:variable name="length"
            select="normalize-space(translate(replace($controlField008-35-37p, '(\d+[a-z]\d+\D+\|{4,}o\|{4,})([a-z]{3})(\|\|$)', '$2'), '|', ''))"/>
        <xsl:variable name="controlField008" select="controlfield[@tag = '008']"/>
        <xsl:variable name="controlField008-36-38v"
            select="normalize-space(translate(substring($controlField008, 36, 3), '|', ''))"/>
        <xsl:variable name="controlField008-35-37v"
            select="normalize-space(translate(substring($controlField008, 35, 3), '|', ''))"/>
        <xsl:choose>

            <xsl:when
                test="contains($controlField008-35-37p, $controlField008-35-37v) and matches($controlField008-35-37p, '[a-z]{3}')">
                <language>
                    <languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="$controlField008-35-37p"/>
                    </languageTerm>
                    <languageTerm type="text">
                        <xsl:value-of select="f:isoTwo2Lang($controlField008-35-37p)"/>
                    </languageTerm>
                </language>
            </xsl:when>
            <xsl:when test="matches($controlField008-35-37p, '[a-z]{3}')">
                <language>
                    <languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="$controlField008-35-37p"/>
                    </languageTerm>
                    <languageTerm type="text">
                        <xsl:value-of select="f:isoTwo2Lang($controlField008-35-37p)"/>
                    </languageTerm>
                </language>
            </xsl:when>
            <xsl:otherwise>

                <xsl:analyze-string select="substring($controlField008, 34, last())"
                    regex="([a-z]{{3}})(\|\|)$">
                    <xsl:matching-substring>
                        <language>
                            <languageTerm authority="iso639-2b" type="code">
                                <xsl:value-of select="regex-group(1)"/>
                            </languageTerm>
                            <xsl:if test="matches(regex-group(1), '[a-z]{2,3}')">
                                <languageTerm type="text">
                                    <xsl:value-of select="f:isoTwo2Lang(regex-group(1))"/>
                                </languageTerm>
                            </xsl:if>
                        </language>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring/>
                </xsl:analyze-string>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc> language 041 </xd:desc>
        <xd:param name="subField"/>
        <xd:param name="langString"/>
        <xd:param name="controlField008-35-37"/>
    </xd:doc>
    <xsl:template match="*[@tag = '041']/*[descendant::node()[@code]]">
        <xsl:param name="subField" as="node()"/>
        <xsl:param name="langString"/>
        <xsl:param name="controlField008-35-37"/>
        <xsl:variable name="length" select="string-length($langString)"/>
        <xsl:for-each
            select="subfield[@code = 'a' or @code = 'b' or @code = 'd' or @code = 'e' or @code = 'f' or @code = 'g' or @code = 'h']">
            <xsl:variable name="langCodes" select="."/>
            <xsl:choose>
                <xsl:when test="../subfield[@code = '2'] = 'rfc3066'">
                    <!-- not stacked but could be repeated -->
                    <xsl:call-template name="rfcLanguages">
                        <xsl:with-param name="nodeNum">
                            <xsl:value-of select="1"/>
                        </xsl:with-param>
                        <xsl:with-param name="usedLanguages">
                            <xsl:text/>
                        </xsl:with-param>
                        <xsl:with-param name="controlField008-35-37">
                            <xsl:value-of select="$controlField008-35-37"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$controlField008-35-37">
                    <xsl:call-template name="filteredForLanguage">
                        <xsl:with-param name="controlField008-35-37p">
                            <xsl:value-of select="$controlField008-35-37"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <!-- iso -->
                    <xsl:variable name="allLanguages">
                        <xsl:copy-of select="$langCodes"/>
                    </xsl:variable>
                    <xsl:variable name="currentLanguage">
                        <xsl:value-of select="substring($allLanguages, 1, 3)"/>
                    </xsl:variable>
                    <xsl:call-template name="isoLanguage">
                        <xsl:with-param name="currentLanguage">
                            <xsl:value-of select="substring($allLanguages, 1, 3)"/>
                        </xsl:with-param>
                        <xsl:with-param name="remainingLanguages">
                            <xsl:value-of
                                select="substring($allLanguages, 4, string-length($allLanguages) - 3)"
                            />
                        </xsl:with-param>
                        <xsl:with-param name="usedLanguages">
                            <xsl:if test="$controlField008-35-37">
                                <xsl:value-of select="$controlField008-35-37"/>
                            </xsl:if>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="langString"/>
        <xd:param name="controlField008-35-37"/>
    </xd:doc>
    <xsl:template name="getLanguage">
        <xsl:param name="langString"/>
        <xsl:param name="controlField008-35-37"/>
        <xsl:variable name="length" select="string-length($langString)"/>
        <xsl:choose>
            <xsl:when test="$length = 0"/>
            <xsl:when test="$controlField008-35-37 = substring($langString, 1, 3)">
                <xsl:call-template name="getLanguage">
                    <xsl:with-param name="langString" select="substring($langString, 4, $length)"/>
                    <xsl:with-param name="controlField008-35-37" select="$controlField008-35-37"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <language>
                    <languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="substring($langString, 1, 3)"/>
                    </languageTerm>
                </language>
                <xsl:call-template name="getLanguage">
                    <xsl:with-param name="langString" select="substring($langString, 4, $length)"/>
                    <xsl:with-param name="controlField008-35-37" select="$controlField008-35-37"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="currentLanguage"/>
        <xd:param name="usedLanguages"/>
        <xd:param name="remainingLanguages"/>
    </xd:doc>
    <xsl:template name="isoLanguage">
        <xsl:param name="currentLanguage"/>
        <xsl:param name="usedLanguages"/>
        <xsl:param name="remainingLanguages"/>
        <xsl:choose>
            <xsl:when test="string-length($currentLanguage) = 0"/>
            <xsl:when test="not(contains($usedLanguages, $currentLanguage))">
                <language>
                    <xsl:if test="@code != 'a'">
                        <xsl:attribute name="objectPart">
                            <xsl:choose>
                                <!-- 1.136 -->
                                <xsl:when test="@code = 'b'">summary</xsl:when>
                                <xsl:when test="@code = 'd'">sung or spoken text</xsl:when>
                                <xsl:when test="@code = 'e'">libretto</xsl:when>
                                <xsl:when test="@code = 'f'">table of contents</xsl:when>
                                <xsl:when test="@code = 'g'">accompanying material</xsl:when>
                                <xsl:when test="@code = 'h'">translation</xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="$currentLanguage"/>
                    </languageTerm>
                </language>
                <xsl:call-template name="isoLanguage">
                    <xsl:with-param name="currentLanguage">
                        <xsl:value-of select="substring($remainingLanguages, 1, 3)"/>
                    </xsl:with-param>
                    <xsl:with-param name="usedLanguages">
                        <xsl:value-of select="concat($usedLanguages, $currentLanguage)"/>
                    </xsl:with-param>
                    <xsl:with-param name="remainingLanguages">
                        <xsl:value-of
                            select="substring($remainingLanguages, 4, string-length($remainingLanguages))"
                        />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="isoLanguage">
                    <xsl:with-param name="currentLanguage">
                        <xsl:value-of select="substring($remainingLanguages, 1, 3)"/>
                    </xsl:with-param>
                    <xsl:with-param name="usedLanguages">
                        <xsl:value-of select="concat($usedLanguages, $currentLanguage)"/>
                    </xsl:with-param>
                    <xsl:with-param name="remainingLanguages">
                        <xsl:value-of
                            select="substring($remainingLanguages, 4, string-length($remainingLanguages))"
                        />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc id="chopBrackets" scope="component">
        <xd:desc>chopBrackets</xd:desc>
        <xd:param name="chopString"/>
    </xd:doc>
    <xsl:template name="chopBrackets">

        <xsl:param name="chopString"/>
        <xsl:variable name="string">
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="$chopString"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="substring($string, 1, 1) = '['">
            <xsl:value-of select="substring($string, 2, string-length($string) - 2)"/>
        </xsl:if>
        <xsl:if test="substring($string, 1, 1) != '['">
            <xsl:value-of select="$string"/>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="nodeNum"/>
        <xd:param name="usedLanguages"/>
        <xd:param name="controlField008-35-37"/>
    </xd:doc>
    <xsl:template name="rfcLanguages">
        <xsl:param name="nodeNum"/>
        <xsl:param name="usedLanguages"/>
        <xsl:param name="controlField008-35-37"/>
        <xsl:variable name="currentLanguage" select="."/>
        <xsl:choose>
            <xsl:when test="not($currentLanguage)"/>
            <xsl:when
                test="$currentLanguage != $controlField008-35-37 and $currentLanguage != 'rfc3066'">
                <xsl:if test="not(contains($usedLanguages, $currentLanguage))">
                    <language>
                        <xsl:if test="@code != 'a'">
                            <xsl:attribute name="objectPart">
                                <xsl:choose>
                                    <xsl:when test="@code = 'b'">summary or subtitle</xsl:when>
                                    <xsl:when test="@code = 'd'">sung or spoken text</xsl:when>
                                    <xsl:when test="@code = 'e'">libretto</xsl:when>
                                    <xsl:when test="@code = 'f'">table of contents</xsl:when>
                                    <xsl:when test="@code = 'g'">accompanying material</xsl:when>
                                    <xsl:when test="@code = 'h'">translation</xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:if>
                        <languageTerm authority="rfc3066" type="code">
                            <xsl:value-of select="$currentLanguage"/>
                        </languageTerm>
                    </language>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc> tmee added 20100106 for 045$b BC and CE date range info </xd:desc>
        <xd:param name="str"/>
    </xd:doc>
    <xsl:template name="dates045b">
        <xsl:param name="str"/>
        <xsl:variable name="first-char" select="substring($str, 1, 1)"/>
        <xsl:choose>
            <xsl:when test="$first-char = 'c'">
                <xsl:value-of select="concat('-', substring($str, 2))"/>
            </xsl:when>
            <xsl:when test="$first-char = 'd'">
                <xsl:value-of select="substring($str, 2)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="scriptCode">
        <xsl:variable name="sf06" select="normalize-space(child::subfield[@code = '6'])"/>
        <xsl:variable name="sf06a" select="substring($sf06, 1, 3)"/>
        <xsl:variable name="sf06b" select="substring($sf06, 5, 2)"/>
        <xsl:variable name="sf06c" select="substring($sf06, 7)"/>
        <xsl:variable name="scriptCode" select="substring($sf06, 8, 2)"/>
        <xsl:if test="//datafield/subfield[@code = '6']">
            <xsl:attribute name="script">
                <xsl:choose>
                    <xsl:when test="$scriptCode = ''">Latn</xsl:when>
                    <xsl:when test="$scriptCode = '(3'">Arab</xsl:when>
                    <xsl:when test="$scriptCode = '(4'">Arab</xsl:when>
                    <xsl:when test="$scriptCode = '(B'">Latn</xsl:when>
                    <xsl:when test="$scriptCode = '!E'">Latn</xsl:when>
                    <xsl:when test="$scriptCode = '$1'">CJK</xsl:when>
                    <xsl:when test="$scriptCode = '(N'">Cyrl</xsl:when>
                    <xsl:when test="$scriptCode = '(Q'">Cyrl</xsl:when>
                    <xsl:when test="$scriptCode = '(2'">Hebr</xsl:when>
                    <xsl:when test="$scriptCode = '(S'">Grek</xsl:when>
                </xsl:choose>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!-- tmee 20100927 for 880s & corresponding fields  20101123 scriptCode -->
    <!-- 1.121 -->
    <xd:doc id="xxx880" scope="component">
        <xd:desc> 880 processing </xd:desc>
    </xd:doc>
    <xsl:template name="xxx880">
        <!-- Checks for subfield $6 ands linking data -->
        <xsl:if test="child::subfield[@code = '6']">
            <xsl:variable name="sf06" select="normalize-space(child::subfield[@code = '6'])"/>
            <xsl:variable name="sf06b" select="substring($sf06, 5, 2)"/>
            <xsl:variable name="scriptCode" select="substring($sf06, 8, 2)"/>
            <!-- 1.121 -->
            <xsl:if test="$sf06b != '00'">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$sf06b"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="scriptCode"/>
        </xsl:if>
    </xsl:template>
    <!--1.121 -->
    <xd:doc id="xxs880" scope="component">
        <xd:desc> 880 processing when called from subfield </xd:desc>
    </xd:doc>
    <xsl:template name="xxs880">
        <!-- Checks for subfield $6 ands linking data -->
        <xsl:if test="preceding-sibling::*[@code = '6']">
            <xsl:variable name="sf06" select="normalize-space(preceding-sibling::*[@code = '6'])"/>
            <xsl:variable name="sf06b" select="substring($sf06, 5, 2)"/>
            <xsl:variable name="scriptCode" select="substring($sf06, 8, 2)"/>
            <!-- 1.121 -->
            <xsl:if test="$sf06b != '00'">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$sf06b"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="script">
                <xsl:choose>
                    <xsl:when test="$scriptCode = ''">Latn</xsl:when>
                    <xsl:when test="$scriptCode = '(3'">Arab</xsl:when>
                    <xsl:when test="$scriptCode = '(4'">Arab</xsl:when>
                    <xsl:when test="$scriptCode = '(B'">Latn</xsl:when>
                    <xsl:when test="$scriptCode = '!E'">Latn</xsl:when>
                    <xsl:when test="$scriptCode = '$1'">CJK</xsl:when>
                    <xsl:when test="$scriptCode = '(N'">Cyrl</xsl:when>
                    <xsl:when test="$scriptCode = '(Q'">Cyrl</xsl:when>
                    <xsl:when test="$scriptCode = '(2'">Hebr</xsl:when>
                    <xsl:when test="$scriptCode = '(S'">Grek</xsl:when>
                </xsl:choose>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xd:doc id="yyy880" scope="component">
        <xd:desc> @depreciated $880$6 </xd:desc>
    </xd:doc>
    <xsl:template name="yyy880">
        <xsl:if test="preceding-sibling::subfield[@code = '6']">
            <xsl:variable name="sf06"
                select="normalize-space(preceding-sibling::subfield[@code = '6'])"/>
            <xsl:variable name="sf06a" select="substring($sf06, 1, 3)"/>
            <xsl:variable name="sf06b" select="substring($sf06, 5, 2)"/>
            <xsl:variable name="sf06c" select="substring($sf06, 7)"/>
            <xsl:if test="//datafield/subfield[@code = '6']">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$sf06b"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="z2xx880">
        <!-- Evaluating the 260 field -->
        <xsl:variable name="x260">
            <xsl:choose>
                <xsl:when test="@tag = '260' and subfield[@code = '6']">
                    <xsl:variable name="sf06260"
                        select="normalize-space(child::subfield[@code = '6'])"/>
                    <xsl:variable name="sf06260a" select="substring($sf06260, 1, 3)"/>
                    <xsl:variable name="sf06260b" select="substring($sf06260, 5, 2)"/>
                    <xsl:variable name="sf06260c" select="substring($sf06260, 7)"/>
                    <xsl:value-of select="$sf06260b"/>
                </xsl:when>
                <xsl:when test="@tag = '250' and ../datafield[@tag = '260']/subfield[@code = '6']">
                    <xsl:variable name="sf06260"
                        select="normalize-space(../datafield[@tag = '260']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06260a" select="substring($sf06260, 1, 3)"/>
                    <xsl:variable name="sf06260b" select="substring($sf06260, 5, 2)"/>
                    <xsl:variable name="sf06260c" select="substring($sf06260, 7)"/>
                    <xsl:value-of select="$sf06260b"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="x250">
            <xsl:choose>
                <xsl:when test="@tag = '250' and subfield[@code = '6']">
                    <xsl:variable name="sf06250"
                        select="normalize-space(../datafield[@tag = '250']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06250a" select="substring($sf06250, 1, 3)"/>
                    <xsl:variable name="sf06250b" select="substring($sf06250, 5, 2)"/>
                    <xsl:variable name="sf06250c" select="substring($sf06250, 7)"/>
                    <xsl:value-of select="$sf06250b"/>
                </xsl:when>
                <xsl:when test="@tag = '260' and ../datafield[@tag = '250']/subfield[@code = '6']">
                    <xsl:variable name="sf06250"
                        select="normalize-space(../datafield[@tag = '250']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06250a" select="substring($sf06250, 1, 3)"/>
                    <xsl:variable name="sf06250b" select="substring($sf06250, 5, 2)"/>
                    <xsl:variable name="sf06250c" select="substring($sf06250, 7)"/>
                    <xsl:value-of select="$sf06250b"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$x250 != '' and $x260 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="concat($x250, $x260)"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x250 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x250"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x260 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x260"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="//datafield/subfield[@code = '6']"> </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="z3xx880">
        <!-- Evaluating the 300 field -->
        <xsl:variable name="x300">
            <xsl:choose>
                <xsl:when test="@tag = '300' and subfield[@code = '6']">
                    <xsl:variable name="sf06300"
                        select="normalize-space(child::subfield[@code = '6'])"/>
                    <xsl:variable name="sf06300a" select="substring($sf06300, 1, 3)"/>
                    <xsl:variable name="sf06300b" select="substring($sf06300, 5, 2)"/>
                    <xsl:variable name="sf06300c" select="substring($sf06300, 7)"/>
                    <xsl:value-of select="$sf06300b"/>
                </xsl:when>
                <xsl:when test="@tag = '351' and ../datafield[@tag = '300']/subfield[@code = '6']">
                    <xsl:variable name="sf06300"
                        select="normalize-space(../datafield[@tag = '300']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06300a" select="substring($sf06300, 1, 3)"/>
                    <xsl:variable name="sf06300b" select="substring($sf06300, 5, 2)"/>
                    <xsl:variable name="sf06300c" select="substring($sf06300, 7)"/>
                    <xsl:value-of select="$sf06300b"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="x351">
            <xsl:choose>
                <xsl:when test="@tag = '351' and subfield[@code = '6']">
                    <xsl:variable name="sf06351"
                        select="normalize-space(../datafield[@tag = '351']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06351a" select="substring($sf06351, 1, 3)"/>
                    <xsl:variable name="sf06351b" select="substring($sf06351, 5, 2)"/>
                    <xsl:variable name="sf06351c" select="substring($sf06351, 7)"/>
                    <xsl:value-of select="$sf06351b"/>
                </xsl:when>
                <xsl:when test="@tag = '300' and ../datafield[@tag = '351']/subfield[@code = '6']">
                    <xsl:variable name="sf06351"
                        select="normalize-space(../datafield[@tag = '351']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06351a" select="substring($sf06351, 1, 3)"/>
                    <xsl:variable name="sf06351b" select="substring($sf06351, 5, 2)"/>
                    <xsl:variable name="sf06351c" select="substring($sf06351, 7)"/>
                    <xsl:value-of select="$sf06351b"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="x337">
            <xsl:if test="@tag = '337' and subfield[@code = '6']">
                <xsl:variable name="sf06337" select="normalize-space(child::subfield[@code = '6'])"/>
                <xsl:variable name="sf06337a" select="substring($sf06337, 1, 3)"/>
                <xsl:variable name="sf06337b" select="substring($sf06337, 5, 2)"/>
                <xsl:variable name="sf06337c" select="substring($sf06337, 7)"/>
                <xsl:value-of select="$sf06337b"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="x338">
            <xsl:if test="@tag = '338' and subfield[@code = '6']">
                <xsl:variable name="sf06338" select="normalize-space(child::subfield[@code = '6'])"/>
                <xsl:variable name="sf06338a" select="substring($sf06338, 1, 3)"/>
                <xsl:variable name="sf06338b" select="substring($sf06338, 5, 2)"/>
                <xsl:variable name="sf06338c" select="substring($sf06338, 7)"/>
                <xsl:value-of select="$sf06338b"/>
            </xsl:if>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$x351 != '' and $x300 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="concat($x351, $x300, $x337, $x338)"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x351 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x351"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x300 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x300"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x337 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x351"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x338 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x300"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="//datafield/subfield[@code = '6']"> </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="true880">
        <xsl:variable name="sf06" select="normalize-space(subfield[@code = '6'])"/>
        <xsl:variable name="sf06a" select="substring($sf06, 1, 3)"/>
        <xsl:variable name="sf06b" select="substring($sf06, 5, 2)"/>
        <xsl:variable name="sf06c" select="substring($sf06, 7)"/>
        <xsl:if test="//datafield/subfield[@code = '6']">
            <xsl:attribute name="altRepGroup">
                <xsl:value-of select="$sf06b"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="datafield" mode="trans880">
        <xsl:variable name="dataField880" select="//datafield"/>
        <xsl:variable name="sf06" select="normalize-space(subfield[@code = '6'])"/>
        <xsl:variable name="sf06a" select="substring($sf06, 1, 3)"/>
        <xsl:variable name="sf06b" select="substring($sf06, 4)"/>
        <xsl:choose>

            <!--tranforms 880 equiv-->

            <xsl:when test="$sf06a = '047'">
                <xsl:call-template name="createGenreFrom047"/>
            </xsl:when>
            <xsl:when test="$sf06a = '336'">
                <xsl:call-template name="createGenreFrom336"/>
            </xsl:when>
            <xsl:when test="$sf06a = '655'">
                <xsl:call-template name="createGenreFrom655"/>
            </xsl:when>

            <xsl:when test="$sf06a = '050'">
                <xsl:call-template name="createClassificationFrom050"/>
            </xsl:when>
            <xsl:when test="$sf06a = '060'">
                <xsl:call-template name="createClassificationFrom060"/>
            </xsl:when>
            <!-- 1.160 -->
            <xsl:when test="$sf06a = '070'">
                <xsl:call-template name="createClassificationFrom070"/>
            </xsl:when>
            <xsl:when test="$sf06a = '080'">
                <xsl:call-template name="createClassificationFrom080"/>
            </xsl:when>
            <xsl:when test="$sf06a = '082'">
                <xsl:call-template name="createClassificationFrom082"/>
            </xsl:when>
            <xsl:when test="$sf06a = '084'">
                <xsl:call-template name="createClassificationFrom080"/>
            </xsl:when>
            <xsl:when test="$sf06a = '086'">
                <xsl:call-template name="createClassificationFrom082"/>
            </xsl:when>
            <xsl:when test="$sf06a = '100'">
                <xsl:call-template name="createNameFrom100"/>
            </xsl:when>
            <xsl:when test="$sf06a = '110'">
                <xsl:call-template name="createNameFrom110"/>
            </xsl:when>
            <xsl:when test="$sf06a = '111'">
                <xsl:call-template name="createNameFrom110"/>
            </xsl:when>
            <xsl:when test="$sf06a = '700'">
                <xsl:call-template name="createNameFrom700"/>
            </xsl:when>
            <xsl:when test="$sf06a = '710'">
                <xsl:call-template name="createNameFrom710"/>
            </xsl:when>
            <xsl:when test="$sf06a = '711'">
                <xsl:call-template name="createNameFrom710"/>
            </xsl:when>
            <xsl:when test="$sf06a = '210'">
                <xsl:call-template name="createTitleInfoFrom210"/>
            </xsl:when>
            <xsl:when test="$sf06a = '245'">
                <xsl:call-template name="createTitleInfoFrom245"/>
                <xsl:call-template name="createNoteFrom245c"/>
            </xsl:when>
            <xsl:when test="$sf06a = '246'">
                <xsl:call-template name="createTitleInfoFrom246"/>
            </xsl:when>
            <xsl:when test="$sf06a = '240'">
                <xsl:call-template name="createTitleInfoFrom240"/>
            </xsl:when>
            <xsl:when test="$sf06a = '740'">
                <xsl:call-template name="createTitleInfoFrom740"/>
            </xsl:when>

            <xsl:when test="$sf06a = '130'">
                <xsl:call-template name="createTitleInfoFrom130"/>
            </xsl:when>
            <xsl:when test="$sf06a = '730'">
                <xsl:call-template name="createTitleInfoFrom730"/>
            </xsl:when>

            <xsl:when test="$sf06a = '505'">
                <xsl:call-template name="createTOCFrom505"/>
            </xsl:when>
            <xsl:when test="$sf06a = '520'">
                <xsl:call-template name="createAbstractFrom520"/>
            </xsl:when>
            <xsl:when test="$sf06a = '521'">
                <xsl:call-template name="createTargetAudienceFrom521"/>
            </xsl:when>
            <xsl:when test="$sf06a = '506'">
                <xsl:call-template name="createAccessConditionFrom506"/>
            </xsl:when>
            <xsl:when test="$sf06a = '540'">
                <xsl:call-template name="createAccessConditionFrom540"/>
            </xsl:when>

            <!-- note 245 362 etc	-->

            <xsl:when test="$sf06a = '245'">
                <xsl:call-template name="createNoteFrom245c"/>
            </xsl:when>
            <xsl:when test="$sf06a = '362'">
                <xsl:call-template name="createNoteFrom362"/>
            </xsl:when>
            <xsl:when test="$sf06a = '502'">
                <xsl:call-template name="createNoteFrom502"/>
            </xsl:when>
            <xsl:when test="$sf06a = '504'">
                <xsl:call-template name="createNoteFrom504"/>
            </xsl:when>
            <xsl:when test="$sf06a = '508'">
                <xsl:call-template name="createNoteFrom508"/>
            </xsl:when>
            <xsl:when test="$sf06a = '511'">
                <xsl:call-template name="createNoteFrom511"/>
            </xsl:when>
            <xsl:when test="$sf06a = '515'">
                <xsl:call-template name="createNoteFrom515"/>
            </xsl:when>
            <xsl:when test="$sf06a = '518'">
                <xsl:call-template name="createNoteFrom518"/>
            </xsl:when>
            <xsl:when test="$sf06a = '524'">
                <xsl:call-template name="createNoteFrom524"/>
            </xsl:when>
            <xsl:when test="$sf06a = '530'">
                <xsl:call-template name="createNoteFrom530"/>
            </xsl:when>
            <xsl:when test="$sf06a = '533'">
                <xsl:call-template name="createNoteFrom533"/>
            </xsl:when>
            <!--
			<xsl:when test="$sf06a='534'">
				<xsl:call-template name="createNoteFrom534"/>
			</xsl:when>
-->
            <xsl:when test="$sf06a = '535'">
                <xsl:call-template name="createNoteFrom535"/>
            </xsl:when>
            <xsl:when test="$sf06a = '536'">
                <xsl:call-template name="createNoteFrom536"/>
            </xsl:when>
            <xsl:when test="$sf06a = '538'">
                <xsl:call-template name="createNoteFrom538"/>
            </xsl:when>
            <xsl:when test="$sf06a = '541'">
                <xsl:call-template name="createNoteFrom541"/>
            </xsl:when>
            <xsl:when test="$sf06a = '545'">
                <xsl:call-template name="createNoteFrom545"/>
            </xsl:when>
            <xsl:when test="$sf06a = '546'">
                <xsl:call-template name="createNoteFrom546"/>
            </xsl:when>
            <xsl:when test="$sf06a = '561'">
                <xsl:call-template name="createNoteFrom561"/>
            </xsl:when>
            <xsl:when test="$sf06a = '562'">
                <xsl:call-template name="createNoteFrom562"/>
            </xsl:when>
            <xsl:when test="$sf06a = '581'">
                <xsl:call-template name="createNoteFrom581"/>
            </xsl:when>
            <xsl:when test="$sf06a = '583'">
                <xsl:call-template name="createNoteFrom583"/>
            </xsl:when>
            <xsl:when test="$sf06a = '585'">
                <xsl:call-template name="createNoteFrom585"/>
            </xsl:when>

            <!--	note 5XX	-->

            <xsl:when test="$sf06a = '501'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '507'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '513'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '514'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '516'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '522'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '525'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '526'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '544'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '552'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '555'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '556'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '565'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '567'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '580'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '584'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '586'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>

            <!--  subject 034 043 045 255 656 662 752 	-->

            <xsl:when test="$sf06a = '034'">
                <xsl:call-template name="createSubGeoFrom034"/>
            </xsl:when>
            <xsl:when test="$sf06a = '043'">
                <xsl:call-template name="createSubGeoFrom043"/>
            </xsl:when>
            <xsl:when test="$sf06a = '045'">
                <xsl:call-template name="createSubTemFrom045"/>
            </xsl:when>
            <xsl:when test="$sf06a = '255'">
                <xsl:call-template name="createSubGeoFrom255"/>
            </xsl:when>

            <xsl:when test="$sf06a = '600'">
                <xsl:call-template name="createSubNameFrom600"/>
            </xsl:when>
            <xsl:when test="$sf06a = '610'">
                <xsl:call-template name="createSubNameFrom610"/>
            </xsl:when>
            <xsl:when test="$sf06a = '611'">
                <xsl:call-template name="createSubNameFrom611"/>
            </xsl:when>

            <xsl:when test="$sf06a = '630'">
                <xsl:call-template name="createSubTitleFrom630"/>
            </xsl:when>

            <xsl:when test="$sf06a = '648'">
                <xsl:call-template name="createSubChronFrom648"/>
            </xsl:when>
            <xsl:when test="$sf06a = '650'">
                <xsl:call-template name="createSubTopFrom650"/>
            </xsl:when>
            <xsl:when test="$sf06a = '651'">
                <xsl:call-template name="createSubGeoFrom651"/>
            </xsl:when>


            <xsl:when test="$sf06a = '653'">
                <xsl:call-template name="createSubFrom653"/>
            </xsl:when>
            <xsl:when test="$sf06a = '656'">
                <xsl:call-template name="createSubFrom656"/>
            </xsl:when>
            <xsl:when test="$sf06a = '662'">
                <xsl:call-template name="createSubGeoFrom662752"/>
            </xsl:when>
            <xsl:when test="$sf06a = '752'">
                <xsl:call-template name="createSubGeoFrom662752"/>
            </xsl:when>
            <!--  location  852 856 -->

            <xsl:when test="$sf06a = '852'">
                <xsl:call-template name="createLocationFrom852"/>
            </xsl:when>
            <xsl:when test="$sf06a = '856'">
                <xsl:call-template name="createLocationFrom856"/>
            </xsl:when>

            <xsl:when test="$sf06a = '490'">
                <xsl:call-template name="createRelatedItemFrom490"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>



    <!-- titleInfo 130 730 245 246 240 740 210 -->
    <xd:doc id="createTitleInfoFrom130" scope="component">
        <xd:desc> 130 tmee 1.101 20140806</xd:desc>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom130">
        <titleInfo type="uniform">
            <!-- 1.121 -->
            <xsl:call-template name="xxx880"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
            <xsl:variable name="this">

                <xsl:variable name="str">
                    <xsl:for-each select="subfield">
                        <xsl:if test="(contains('s', @code))">
                            <xsl:value-of select="text()"/>
                            <xsl:text>&#160;</xsl:text>
                        </xsl:if>
                        <xsl:if
                            test="(contains('adfklmors', @code) and (not(../subfield[@code = 'n' or @code = 'p']) or (following-sibling::subfield[@code = 'n' or @code = 'p'])))">
                            <xsl:value-of select="text()"/>
                            <xsl:text>&#160;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <title>
                <xsl:value-of select="normalize-space($this)"/>
            </title>
            <xsl:call-template name="part"/>
        </titleInfo>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom730">
        <titleInfo type="uniform">
            <!-- 1.121 -->
            <xsl:call-template name="xxx880"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
            <xsl:variable name="this">

                <xsl:variable name="str">
                    <xsl:for-each select="subfield">
                        <xsl:if test="(contains('s', @code))">
                            <xsl:value-of select="text()"/>
                            <xsl:text>&#160;</xsl:text>
                        </xsl:if>
                        <xsl:if
                            test="(contains('adfklmors', @code) and (not(../subfield[@code = 'n' or @code = 'p']) or (following-sibling::subfield[@code = 'n' or @code = 'p'])))">
                            <xsl:value-of select="text()"/>
                            <xsl:text>&#160;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>

            <title>
                <xsl:value-of select="normalize-space($this)"/>
            </title>
            <xsl:call-template name="part"/>
        </titleInfo>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom210">
        <titleInfo type="abbreviated">
            <xsl:if test="datafield[@tag = '210'][@ind2 = '2']">
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="xxx880"/>
            <xsl:variable name="this">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">a</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>

            <title>
                <xsl:value-of select="normalize-space($this)"/>
            </title>
            <xsl:call-template name="subtitle"/>
        </titleInfo>
    </xsl:template>
    <xd:doc id="createTitleInfoFrom245" scope="component">
        <xd:desc> 1.79 </xd:desc>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom245">
        <titleInfo>
            <xsl:call-template name="xxx880"/>
            <xsl:variable name="title">
                <xsl:choose>
                    <xsl:when test="subfield[@code = 'b']">
                        <xsl:call-template name="specialSubfieldSelect">
                            <xsl:with-param name="axis">b</xsl:with-param>
                            <xsl:with-param name="beforeCodes">afgks</xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">abfgks</xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="titleChop">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="$title"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <!-- 1.120 - @245/@880$ind2-->
                <xsl:when test="@ind2 != ' ' and @ind2 &gt; 0">
                    <!-- 1.112 -->
                    <nonSort xml:space="preserve"><xsl:value-of select="substring($titleChop, 1, @ind2)"/> </nonSort>
                    <xsl:variable name="this">

                        <xsl:value-of select="substring($titleChop, @ind2 + 1)"/>
                    </xsl:variable>
                    <title>
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="this">

                        <xsl:value-of select="$titleChop"/>
                    </xsl:variable>
                    <title>
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="subfield[@code = 'b']">
                <subTitle>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="specialSubfieldSelect">
                                <xsl:with-param name="axis">b</xsl:with-param>
                                <xsl:with-param name="anyCodes">b</xsl:with-param>
                                <xsl:with-param name="afterCodes">afgks</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </subTitle>
            </xsl:if>
            <xsl:call-template name="part"/>
        </titleInfo>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom246">
        <titleInfo>
            <!-- 1.120 - @246/ind2=1 -->
            <xsl:choose>
                <xsl:when test="@ind2 = '1'">
                    <xsl:attribute name="type">translated</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="type">alternative</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="xxx880"/>
            <xsl:for-each select="subfield[@code = 'i']">
                <xsl:attribute name="displayLabel">
                    <xsl:value-of select="text()"/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:variable name="this">

                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="subfieldSelect">
                            <!-- 1/04 removed $h, $b -->
                            <xsl:with-param name="codes">af</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <title>
                <xsl:value-of select="normalize-space($this)"/>
            </title>
            <xsl:call-template name="subtitle"/>
            <xsl:call-template name="part"/>
        </titleInfo>
    </xsl:template>

    <!-- 240 nameTitleGroup-->
    <xd:doc id="createTitleInfoFrom240" scope="component">
        <xd:desc> 1.102 </xd:desc>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom240">
        <titleInfo type="uniform">
            <!-- 1.123 Add nameTitleGroup attribute if necessary -->
            <xsl:call-template name="nameTitleGroup"/>
            <xsl:call-template name="xxx880"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
            <xsl:variable name="this">

                <xsl:variable name="str">
                    <xsl:for-each select="subfield">
                        <xsl:if
                            test="(contains('adfklmors', @code) and (not(../subfield[@code = 'n' or @code = 'p']) or (following-sibling::subfield[@code = 'n' or @code = 'p'])))">
                            <xsl:value-of select="text()"/>
                            <xsl:text>&#160;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <title>
                <xsl:value-of select="normalize-space($this)"/>
            </title>
            <xsl:call-template name="part"/>
        </titleInfo>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom740">
        <titleInfo type="alternative">
            <xsl:call-template name="xxx880"/>
            <xsl:variable name="this">

                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">ah</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <title>
                <xsl:value-of select="normalize-space($this)"/>
            </title>
            <xsl:call-template name="part"/>
        </titleInfo>
    </xsl:template>
    <xd:doc id="createNameFrom100" scope="component">
        <xd:desc> name 100 110 111 1.93</xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom100">
        <xsl:if test="@ind1 = '0' or @ind1 = '1'">
            <name type="personal">
                <xsl:attribute name="usage">
                    <xsl:text>primary</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="xxx880"/>
                <!-- 1.123 Add nameTitleGroup attribute if necessary -->
                <xsl:call-template name="nameTitleGroup"/>
                <!-- 1.122 -->
                <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
                <!--Revision 2.06 cm3 edit, commented out named template to pull <namePart> from displayForm-->
                <!--<xsl:call-template name="nameABCDQ"/>-->
                <xsl:call-template name="personal_name"/>
                <xsl:call-template name="affiliation"/>
                <xsl:call-template name="role"/>
                <!-- 1.116 -->
                <xsl:call-template name="nameIdentifier"/>
            </name>
        </xsl:if>
        <!-- 1.99 240 fix 20140804 -->
        <xsl:if test="@ind1 = '3'">
            <name type="family">
                <xsl:attribute name="usage">
                    <xsl:text>primary</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="xxx880"/>

                <!-- 1.123 Add nameTitleGroup attribute if necessary -->
                <xsl:call-template name="nameTitleGroup"/>
                <!--Revision 2.06 cm3 edit, commented out named template to pull <namePart> from displayForm-->
                <!--<xsl:call-template name="nameABCDQ"/>-->
                <xsl:call-template name="personal_name"/>
                <xsl:call-template name="affiliation"/>
                <xsl:call-template name="role"/>
                <!-- 1.116 -->
                <xsl:call-template name="nameIdentifier"/>
            </name>
        </xsl:if>
    </xsl:template>

    <xd:doc id="createNameFrom110" scope="component">
        <xd:desc>createNameFrom110</xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom110">
        <name type="corporate">
            <xsl:call-template name="xxx880"/>
            <!-- 1.123 Add nameTitleGroup attribute if necessary -->
            <xsl:call-template name="nameTitleGroup"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
            <xsl:call-template name="nameABCDN"/>
            <xsl:call-template name="role"/>
            <!-- 1.116 -->
            <xsl:call-template name="nameIdentifier"/>
        </name>
    </xsl:template>




    <xd:doc id="createNameFrom111" scope="component">
        <xd:desc> 111 1.104 20141104 </xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom111">
        <name type="conference">
            <xsl:call-template name="xxx880"/>
            <!-- 1.123 Add nameTitleGroup attribute if necessary -->
            <xsl:call-template name="nameTitleGroup"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
            <xsl:call-template name="nameACDENQ"/>
            <xsl:call-template name="role"/>
            <!-- 1.116 -->
            <xsl:call-template name="nameIdentifier"/>
        </name>
    </xsl:template>
    <xd:doc id="createNameFrom700" scope="component">
        <xd:desc> name 700 710 711 720 </xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom700">
        <xsl:if test="@ind1 = '0' or @ind1 = '1'">
            <name type="personal">
                <xsl:call-template name="xxx880"/>
                <!-- 1.123 Add nameTitleGroup attribute if necessary -->
                <xsl:call-template name="nameTitleGroup"/>
                <!-- 1.122 -->
                <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
                <!--<xsl:call-template name="nameABCDQ"/>-->
                <xsl:call-template name="personal_name"/>
                <xsl:call-template name="affiliation"/>
                <xsl:call-template name="role"/>
                <!-- 1.116 -->
                <xsl:call-template name="nameIdentifier"/>
            </name>
        </xsl:if>
        <xsl:if test="@ind1 = '3'">
            <!--cm3 edit, Revision 2.06 added usage="primary" to <name> while checking if name in 100$a is present-->
            <name type="family">
                <xsl:call-template name="xxx880"/>
                <!--<xsl:call-template name="nameABCDQ"/>-->
                <xsl:call-template name="personal_name"/>
                <xsl:call-template name="affiliation"/>
                <xsl:call-template name="role"/>
                <!-- 1.116 -->
                <xsl:call-template name="nameIdentifier"/>
            </name>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNameFrom710">
        <name type="corporate">
            <xsl:call-template name="xxx880"/>
            <!-- 1.123 Add nameTitleGroup attribute if necessary -->
            <xsl:call-template name="nameTitleGroup"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
            <xsl:call-template name="nameABCDN"/>
            <xsl:call-template name="role"/>
            <!-- 1.116 -->
            <xsl:call-template name="nameIdentifier"/>
        </name>
    </xsl:template>
    <xd:doc id="createNameFrom711" scope="component">
        <xd:desc> 111 1.104 20141104 </xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom711">
        <name type="conference">
            <xsl:call-template name="xxx880"/>
            <!-- 1.123 Add nameTitleGroup attribute if necessary -->
            <xsl:call-template name="nameTitleGroup"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0'][. != '']" mode="xlink"/>
            <xsl:call-template name="nameACDENQ"/>
            <xsl:call-template name="role"/>
            <!-- 1.116 -->
            <xsl:call-template name="nameIdentifier"/>
        </name>
    </xsl:template>


    <xd:doc id="createNameFrom720" scope="component">
        <xd:desc>createNameFrom720</xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom720">
        <!-- 1.91 FLVC correction: the original if test will fail because of xpath: the current node (from the for-each above) is already the 720 datafield -->
        <!-- <xsl:if test="datafield[@tag='720'][not(subfield[@code='t'])]"> -->
        <xsl:if test="not(subfield[@code = 't'])">
            <name>
                <xsl:if test="@ind1 = 1">
                    <xsl:attribute name="type">
                        <xsl:text>personal</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <namePart>
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </namePart>
                <xsl:call-template name="role"/>
            </name>
        </xsl:if>
    </xsl:template>



    <!-- replced by above 1.91
	<xsl:template name="createNameFrom720">
		<xsl:if test="datafield[@tag='720'][not(subfield[@code='t'])]">
			<name>
				<xsl:if test="@ind1=1">
					<xsl:attribute name="type">
						<xsl:text>personal</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<namePart>
					<xsl:value-of select="subfield[@code='a']"/>
				</namePart>
				<xsl:call-template name="role"/>
			</name>
		</xsl:if>
	</xsl:template>
	-->
    <xd:doc id="createGenreFrom047" scope="component">
        <xd:desc> genre 047 336 655 </xd:desc>
    </xd:doc>
    <xsl:template name="createGenreFrom047">
        <genre authority="marcgt">
            <!-- 1.111 -->
            <xsl:choose>
                <xsl:when test="@ind2 = ' '">
                    <xsl:attribute name="authority">
                        <xsl:text>marcmuscomp</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind2 = '7'">
                    <xsl:if test="subfield[@code = '2']">
                        <xsl:attribute name="authority">
                            <xsl:value-of select="subfield[@code = '2']"/>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
            <xsl:attribute name="type">
                <xsl:text>musical composition</xsl:text>
            </xsl:attribute>
            <!-- Template checks for altRepGroup - 880 $6 -->
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdef</xsl:with-param>
                <xsl:with-param name="delimeter">-</xsl:with-param>
            </xsl:call-template>
        </genre>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createGenreFrom336">
        <genre>
            <!-- 1.110 -->
            <xsl:if test="subfield[@code = '2']">
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
            </xsl:if>
            <!-- Template checks for altRepGroup - 880 $6 -->
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">a</xsl:with-param>
                <xsl:with-param name="delimeter">-</xsl:with-param>
            </xsl:call-template>
        </genre>

    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createGenreFrom655">
        <genre authority="marcgt">
            <!-- 1.109 -->
            <xsl:choose>
                <xsl:when test="subfield[@code = '2']">
                    <xsl:attribute name="authority">
                        <xsl:value-of select="subfield[@code = '2']"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind2 != ' '">
                    <xsl:attribute name="authority">
                        <xsl:value-of select="@ind2"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <!-- Template checks for altRepGroup - 880 $6 -->
            <xsl:call-template name="xxx880"/>
            <!-- 1.132 <xsl:apply-templates select="[. != '']" mode="xlink"/>-->
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abvxyz</xsl:with-param>
                <xsl:with-param name="delimeter">-</xsl:with-param>
            </xsl:call-template>
        </genre>
    </xsl:template>
    <xd:doc id="createTOCFrom505" scope="component">
        <xd:desc> tOC 505 </xd:desc>
    </xd:doc>
    <xsl:template name="createTOCFrom505">
        <tableOfContents>
            <!-- 1.137 -->
            <xsl:choose>
                <xsl:when test="@ind1 = '0'">
                    <xsl:attribute name="displayLabel">Contents</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '1'">
                    <xsl:attribute name="displayLabel">Incomplete contents</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '2'">
                    <xsl:attribute name="displayLabel">Partial contents</xsl:attribute>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">agrt</xsl:with-param>
            </xsl:call-template>
        </tableOfContents>
    </xsl:template>
    <xd:doc id="createAbstractFrom520" scope="component">
        <xd:desc> abstract 520 </xd:desc>
    </xd:doc>
    <xsl:template name="createAbstractFrom520">
        <abstract>
            <!-- 1.124 -->
            <xsl:choose>
                <xsl:when test="@ind1 = '0'">
                    <xsl:attribute name="displayLabel">Subject</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '1'">
                    <xsl:attribute name="displayLabel">Review</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '2'">
                    <xsl:attribute name="displayLabel">Scope and content</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '3'">
                    <xsl:attribute name="displayLabel">Abstract</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '4'">
                    <xsl:attribute name="displayLabel">Content advice</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '8'"/>
                <xsl:otherwise>
                    <xsl:attribute name="displayLabel">Summary</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name="this">
                <xsl:call-template name="xxx880"/>
                <xsl:call-template name="uri"/>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">ab</xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="normalize-space($this)"/>
        </abstract>
    </xsl:template>
    <xd:doc id="createTargetAudienceFrom521" scope="component">
        <xd:desc> targetAudience 521 </xd:desc>
    </xd:doc>
    <xsl:template name="createTargetAudienceFrom521">
        <targetAudience>
            <xsl:call-template name="xxx880"/>
            <!-- 1.127 Add displayLabel attribute -->
            <xsl:choose>
                <xsl:when test="@ind1 = '0'">
                    <xsl:attribute name="displayLabel">Reading grade level</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '1'">
                    <xsl:attribute name="displayLabel">Interest age level</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '2'">
                    <xsl:attribute name="displayLabel">Interest grade level</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '3'">
                    <xsl:attribute name="displayLabel">Special audience
                        characteristics</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '4'">
                    <xsl:attribute name="displayLabel">Motivation or interest level</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = ' '">
                    <xsl:attribute name="displayLabel">Audience</xsl:attribute>
                </xsl:when>
                <xsl:when test="@ind1 = '8'"/>
            </xsl:choose>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </targetAudience>
    </xsl:template>

    <!-- note 245c thru 585 -->
    <xd:doc id="createNoteFrom245c" scope="component">
        <xd:desc> 1.100 245c 20140804 </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom245c">
        <xsl:if test="subfield[@code = 'c']">
            <note type="statement of responsibility">
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">c</xsl:with-param>
                </xsl:call-template>
            </note>
        </xsl:if>

    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom362">
        <note type="date/sequential designation">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom500">
        <note>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <!-- 1.138 -->
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="f:sentence-case(substring($str, 1, string-length($str) - 1))"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom502">
        <note type="thesis">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom504">
        <note type="bibliography">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom508">
        <note type="creation/production credits">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each
                    select="subfield[@code != 'u' and @code != '3' and @code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom511">
        <note type="performers">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom515">
        <note type="numbering">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom518">
        <note type="venue">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '3' and @code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom524">
        <note type="preferred citation">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom530">
        <note type="additional physical form">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each
                    select="subfield[@code != 'u' and @code != '3' and @code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom533">
        <note type="reproduction">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>


    <!--tmee &lt;xsl:template name="createNoteFrom534"&gt; &lt;note type="original
version"&gt; &lt;xsl:call-template name="xxx880"/&gt; &lt;xsl:call-template
name="uri"/&gt; &lt;xsl:variable name="str"&gt; &lt;xsl:for-each
select="subfield[@code!='6' and @code!='8']"&gt; &lt;xsl:value-of select="."/&gt;
&lt;xsl:text&gt; &lt;/xsl:text&gt; &lt;/xsl:for-each&gt; &lt;/xsl:variable&gt;
&lt;xsl:value-of select="substring($str,1,string-length($str)-1)"/&gt; &lt;/note&gt;
&lt;/xsl:template&gt;-->
    <xd:doc id="createNoteFrom535" scope="component">
        <xd:desc>createNoteFrom535</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom535">

        <note type="original location">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom536">
        <note type="funding">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom538">
        <note type="system details">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom541">
        <note type="acquisition">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom545">
        <note type="biographical/historical">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom546">
        <note type="language">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom561">
        <note type="ownership">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom562">
        <note type="version identification">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom581">
        <note type="publications">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom583">
        <note type="action">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createNoteFrom585">
        <note type="exhibitions">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>


    <xd:doc id="createNoteFrom5XX" scope="component">
        <xd:desc>createNoteFrom5XX</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom5XX">
        <note>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="f:proper-case(.)"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createSubGeoFrom034" scope="component">
        <xd:desc> subject Geo 034 043 045 255 656 662 752 </xd:desc>
    </xd:doc>
    <xsl:template name="createSubGeoFrom034">
        <xsl:if
            test="datafield[@tag = '034'][subfield[@code = 'd' or @code = 'e' or @code = 'f' or @code = 'g']]">
            <subject>
                <xsl:call-template name="xxx880"/>
                <cartographics>
                    <coordinates>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">defg</xsl:with-param>
                        </xsl:call-template>
                    </coordinates>
                </cartographics>
            </subject>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubGeoFrom043">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:for-each select="subfield[@code = 'a' or @code = 'b' or @code = 'c']">
                <geographicCode>
                    <xsl:attribute name="authority">
                        <xsl:if test="@code = 'a'">
                            <xsl:text>marcgac</xsl:text>
                        </xsl:if>
                        <xsl:if test="@code = 'b'">
                            <xsl:value-of select="following-sibling::subfield[@code = 2]"/>
                        </xsl:if>
                        <xsl:if test="@code = 'c'">
                            <xsl:text>iso3166</xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:value-of select="self::subfield"/>
                </geographicCode>
            </xsl:for-each>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubGeoFrom255">
        <subject>
            <xsl:call-template name="xxx880"/>
            <cartographics>
                <xsl:for-each select="subfield[@code = 'a' or @code = 'b' or @code = 'c']">
                    <xsl:if test="@code = 'a'">
                        <scale>
                            <xsl:value-of select="."/>
                        </scale>
                    </xsl:if>
                    <xsl:if test="@code = 'b'">
                        <projection>
                            <xsl:value-of select="."/>
                        </projection>
                    </xsl:if>
                    <xsl:if test="@code = 'c'">
                        <coordinates>
                            <xsl:value-of select="."/>
                        </coordinates>
                    </xsl:if>
                </xsl:for-each>
            </cartographics>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubNameFrom600">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0']" mode="xlink"/>
            <name type="personal">
                <namePart>
                    <!-- 1.126 -->
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">aq</xsl:with-param>
                    </xsl:call-template>
                </namePart>
                <xsl:call-template name="termsOfAddress"/>
                <xsl:call-template name="nameDate"/>
                <xsl:call-template name="affiliation"/>
                <xsl:call-template name="role"/>
            </name>
            <xsl:if test="subfield[@code = 't']">
                <titleInfo>
                    <xsl:variable name="this">
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="subfieldSelect">
                                    <xsl:with-param name="codes">t</xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <title>
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
            </xsl:if>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubNameFrom610">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0']" mode="xlink"/>
            <name type="corporate">
                <xsl:for-each select="subfield[@code = 'a']">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'b']">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </xsl:for-each>
                <xsl:if test="subfield[@code = 'c' or @code = 'd' or @code = 'n' or @code = 'p']">
                    <namePart>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">cdnp</xsl:with-param>
                        </xsl:call-template>
                    </namePart>
                </xsl:if>
                <xsl:call-template name="role"/>
            </name>
            <xsl:if test="subfield[@code = 't']">
                <titleInfo>
                    <xsl:variable name="this">
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="subfieldSelect">
                                    <xsl:with-param name="codes">t</xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <title>
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
            </xsl:if>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubNameFrom611">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0']" mode="xlink"/>
            <name type="conference">
                <namePart>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abcdeqnp</xsl:with-param>
                    </xsl:call-template>
                </namePart>
                <xsl:for-each select="subfield[@code = '4']">
                    <role>
                        <roleTerm authority="marcrelator" type="code">
                            <xsl:value-of select="."/>
                        </roleTerm>
                    </role>
                </xsl:for-each>
            </name>
            <xsl:if test="subfield[@code = 't']">
                <titleInfo>
                    <xsl:variable name="this">
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="subfieldSelect">
                                    <xsl:with-param name="codes">tpn</xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>

                    <title>
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
            </xsl:if>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubTitleFrom630">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0']" mode="xlink"/>
            <titleInfo>
                <xsl:variable name="this">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">adfhklor</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>

                <title>
                    <xsl:value-of select="normalize-space($this)"/>
                </title>
                <xsl:call-template name="part"/>
            </titleInfo>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubChronFrom648">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:if test="subfield[@code = '2']">
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="uri"/>
            <xsl:call-template name="subjectAuthority"/>
            <temporal>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">abcd</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </temporal>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubTopFrom650">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0']" mode="xlink"/>
            <topic>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">abcd</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </topic>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubGeoFrom651">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0']" mode="xlink"/>
            <xsl:for-each select="subfield[@code = 'a']">
                <geographic>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                </geographic>
            </xsl:for-each>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubFrom653">

        <xsl:if test="@ind2 = ' '">
            <subject>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <topic>
                    <xsl:value-of select="."/>
                </topic>
            </subject>
        </xsl:if>
        <xsl:if test="@ind2 = '0'">
            <subject>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <topic>
                    <xsl:value-of select="."/>
                </topic>
            </subject>
        </xsl:if>
        <!-- tmee 1.93 20140130 -->
        <xsl:if test="@ind = ' ' or @ind1 = '0' or @ind1 = '1'">
            <subject>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <name type="personal">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </name>
            </subject>
        </xsl:if>
        <xsl:if test="@ind1 = '3'">
            <subject>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <name type="family">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </name>
            </subject>
        </xsl:if>
        <xsl:if test="@ind2 = '2'">
            <subject>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <name type="corporate">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </name>
            </subject>
        </xsl:if>
        <xsl:if test="@ind2 = '3'">
            <subject>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <name type="conference">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </name>
            </subject>
        </xsl:if>
        <xsl:if test="@ind2 = '4'">
            <subject>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <temporal>
                    <xsl:value-of select="."/>
                </temporal>
            </subject>
        </xsl:if>
        <xsl:if test="@ind2 = '5'">
            <subject>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <geographic>
                    <xsl:value-of select="."/>
                </geographic>
            </subject>
        </xsl:if>

        <xsl:if test="@ind2 = '6'">
            <subject>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <genre>
                    <xsl:value-of select="."/>
                </genre>
            </subject>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubFrom656">
        <subject>
            <xsl:call-template name="xxx880"/>
            <!-- 1.122 -->
            <xsl:apply-templates select="subfield[@code = '0']" mode="xlink"/>
            <xsl:if test="subfield[@code = 2]">
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = 2]"/>
                </xsl:attribute>
            </xsl:if>
            <occupation>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="subfield[@code = 'a']"/>
                    </xsl:with-param>
                </xsl:call-template>
            </occupation>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubGeoFrom662752">
        <subject>
            <xsl:call-template name="xxx880"/>
            <!-- 1.139 -->
            <xsl:apply-templates select="subfield[@code = '0']" mode="valueURI"/>
            <hierarchicalGeographic>
                <!-- 1.113 -->
                <xsl:if test="subfield[@code = '0']">
                    <xsl:attribute name="valueURI">
                        <xsl:value-of select="subfield[@code = '0']"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:for-each select="subfield[@code = 'a']">
                    <country>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </country>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'b']">
                    <state>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </state>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'c']">
                    <county>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </county>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'd']">
                    <city>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </city>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'e']">
                    <citySection>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </citySection>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'g']">
                    <area>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </area>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'h']">
                    <extraterrestrialArea>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </extraterrestrialArea>
                </xsl:for-each>
            </hierarchicalGeographic>
        </subject>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createSubTemFrom045">
        <xsl:if
            test="//datafield[@tag = '045' and @ind1 = '2'][subfield[@code = 'b' or @code = 'c']]">
            <subject>
                <xsl:call-template name="xxx880"/>
                <temporal encoding="iso8601" point="start">
                    <xsl:call-template name="dates045b">
                        <xsl:with-param name="str" select="subfield[@code = 'b' or @code = 'c'][1]"
                        />
                    </xsl:call-template>
                </temporal>
                <temporal encoding="iso8601" point="end">
                    <xsl:call-template name="dates045b">
                        <xsl:with-param name="str" select="subfield[@code = 'b' or @code = 'c'][2]"
                        />
                    </xsl:call-template>
                </temporal>
            </subject>
        </xsl:if>
    </xsl:template>

    <!--NAL note templates (900s) -->

    <!-- 910 912 914 917 918 930 935 945 946 949 951 953 962 974 -->

    <!--NAL note from 910-->

    <xd:doc>
        <xd:desc> JG changed note element to submissionSource element </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom910"
        match="datafield[@tag = '910']/subfield[@code = 'a' or @code = 'b']">
        <xsl:if test="datafield[@tag = '910']">
            <submissionSource>
                <xsl:value-of select="datafield[@tag = '910']/subfield[@code = 'a']"/>
                <xsl:if test="datafield[@tag = '910']/subfield[@code = 'b']">
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="datafield[@tag = '910']/subfield[@code = 'b']"/>
                </xsl:if>
            </submissionSource>
        </xsl:if>
    </xsl:template>


    <!-- NAL note from 930: <note type="salesTape"> -->
    <xd:doc>
        <xd:desc>
            <xd:p>
                <xd:b>AGRICOLA Sale File:</xd:b>
            </xd:p>
            <xd:p>Contains 3 date instances of a record:</xd:p>
            <xd:ul>
                <xd:li>(930$a) Selection,</xd:li>
                <xd:li>(930$b) Insertion and,</xd:li>
                <xd:li>(930$c) Deletion, </xd:li>
            </xd:ul>
            <xd:p>for AGRICOLA Sale file</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom930"
        match="datafield[@tag = '930']/subfield[@code = 'a' or @code = 'b' or @code = 'c']">
        <xsl:if test="datafield[@tag = '930']">
            <note type="saleTape">
                <xsl:value-of select="datafield[@tag = '930']/subfield[@code = 'a']"/>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="datafield[@tag = '930']/subfield[@code = 'b']"/>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="datafield[@tag = '930']/subfield[@code = 'c']"/>
            </note>
        </xsl:if>
    </xsl:template>


    <xd:doc id="createNoteFrom945" scope="component">
        <xd:desc>NAL note from 945 </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom945"
        match="datafield[@tag = '945']/subfield[@code = 'a' or @code = 'd' or @code = 'e']">
        <!-- 2.14 added conditionals to prevent extra whitespace -->
        <xsl:if test="datafield[@tag = '945']">
            <note type="indexer">
                <xsl:value-of select="datafield[@tag = '945']/subfield[@code = 'a']"/>
                <xsl:if test="count(datafield[@tag = '945']/subfield[@code = 'd']) != 0">
                    <xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="datafield[@tag = '945']/subfield[@code = 'd']"/>
                </xsl:if>
                <xsl:if test="count(datafield[@tag = '945']/subfield[@code = 'd']) != 0">
                    <xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="datafield[@tag = '945']/subfield[@code = 'e']"/>
                </xsl:if>
            </note>
        </xsl:if>
    </xsl:template>
    <xd:doc id="createNoteFrom946" scope="component">
        <xd:desc>NAL note from 946 </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom946" match="datafield[@tag = '946']/subfield[@code = 'a']">
        <xsl:if test="datafield[@tag = '946']">
            <note type="publicationSource">
                <xsl:value-of select="datafield[@tag = '946']/subfield[@code = 'a']"/>
            </note>
        </xsl:if>
    </xsl:template>
    <xd:doc id="createNoteFrom974" match="//datafield[@tag = '974']" scope="component">
        <xd:desc>974 to local identifier agid# </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom974" match="//datafield[@tag = '974']">
        <!-- Revision 1.159 added if test to prevent extra whitespace -->
        <identifier type="local">
            <!-- $a agid: -->
            <xsl:value-of select="normalize-space(datafield[@tag = '974']/subfield[@code = 'a'])"/>
        </identifier>
    </xsl:template>

    <!-- Classification Series: 050 060 070 080 082 084 086 -->
    <xd:doc id="createClassificationFrom050" scope="component">
        <xd:desc>LC Classificaiton Number</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom050">
        <xsl:for-each select="subfield[@code = 'b']">
            <classification authority="lcc">
                <xsl:call-template name="xxx880"/>
                <xsl:if test="../subfield[@code = '3']">
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of select="../subfield[@code = '3']"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="preceding-sibling::subfield[@code = 'a'][1]"/>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="text()"/>
            </classification>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'a'][not(following-sibling::subfield[@code = 'b'])]">
            <classification authority="lcc">
                <xsl:call-template name="xxx880"/>
                <xsl:if test="../subfield[@code = '3']">
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of select="../subfield[@code = '3']"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="text()"/>
            </classification>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="createClassificationFrom060" scope="component">
        <xd:desc>NLM Classification Number</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom060">
        <classification authority="nlm">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </classification>
    </xsl:template>

    <!-- 1.160 -->
    <xd:doc id="createClassificationFrom070" scope="component">
        <xd:desc>NAL Classification Number</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom070">
        <classification authority="nal">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </classification>
    </xsl:template>
    <xd:doc id="createClassificationFrom080" scope="component">
        <xd:desc>Universal Decimal Classification Number</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom080">
        <classification authority="udc">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abx</xsl:with-param>
            </xsl:call-template>
        </classification>
    </xsl:template>
    <xd:doc id="createClassificationFrom082" scope="component">
        <xd:desc>Dewey Decimal Classification Number</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom082">
        <classification authority="ddc">
            <xsl:call-template name="xxx880"/>
            <xsl:if test="subfield[@code = '2']">
                <xsl:attribute name="edition">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </classification>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createClassificationFrom084">
        <classification>
            <xsl:attribute name="authority">
                <xsl:value-of select="subfield[@code = '2']"/>
            </xsl:attribute>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </classification>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createClassificationFrom086">
        <xsl:for-each select="datafield[@tag = '086'][@ind1 = 0]">
            <classification authority="sudocs">
                <xsl:call-template name="xxx880"/>
                <xsl:value-of select="subfield[@code = 'a']"/>
            </classification>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '086'][@ind1 = 1]">
            <classification authority="candoc">
                <xsl:call-template name="xxx880"/>
                <xsl:value-of select="subfield[@code = 'a']"/>
            </classification>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '086'][@ind1 != 1 and @ind1 != 0]">
            <classification>
                <xsl:call-template name="xxx880"/>
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
                <xsl:value-of select="subfield[@code = 'a']"/>
            </classification>
        </xsl:for-each>
    </xsl:template>

    <!-- identifier 020 024 022 028 010 037 UNDO Nov 23 2010 RG SM -->
    <xd:doc id="createRelatedItemFrom490" scope="component">
        <xd:desc> createRelatedItemFrom490</xd:desc>
    </xd:doc>
    <xsl:template name="createRelatedItemFrom490">
        <xsl:variable name="s6" select="substring(normalize-space(subfield[@code = '6']), 5, 2)"/>
        <!-- 1.121 -->
        <xsl:if
            test="@tag = '490' or (@tag = '880' and not(../datafield[@tag = '490'][@ind1 = '0' or @ind1 = ' '][substring(subfield[@code = '6'], 5, 2) = $s6]))">
            <relatedItem type="series">
                <xsl:for-each
                    select=". | ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '490')][substring(subfield[@code = '6'], 5, 2) = $s6]">
                    <titleInfo>
                        <xsl:call-template name="xxx880"/>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="subfieldSelect">
                                        <xsl:with-param name="codes">a</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <title>
                            <xsl:value-of select="normalize-space($this)"/>
                        </title>
                        <!-- 1.120 - @490$v -->
                        <xsl:if test="subfield[@code = 'v']">
                            <partNumber>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString">
                                        <xsl:call-template name="subfieldSelect">
                                            <xsl:with-param name="codes">v</xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </partNumber>
                        </xsl:if>
                        <xsl:call-template name="part"/>
                    </titleInfo>
                </xsl:for-each>
            </relatedItem>
        </xsl:if>
    </xsl:template>
    <xd:doc id="createLocationFrom852" scope="component">
        <xd:desc> location 852 856 </xd:desc>
    </xd:doc>
    <xsl:template name="createLocationFrom852">
        <location>
            <!-- 1.121 -->
            <xsl:call-template name="xxx880"/>
            <xsl:if test="subfield[@code = 'a' or @code = 'b' or @code = 'e']">
                <physicalLocation>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abe</xsl:with-param>
                    </xsl:call-template>
                </physicalLocation>
            </xsl:if>
            <xsl:if test="subfield[@code = 'u']">
                <physicalLocation>
                    <xsl:call-template name="uri"/>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">u</xsl:with-param>
                    </xsl:call-template>
                </physicalLocation>
            </xsl:if>
            <!-- 1.78 -->
            <xsl:if
                test="subfield[@code = 'h' or @code = 'i' or @code = 'j' or @code = 'k' or @code = 'l' or @code = 'm' or @code = 't']">
                <shelfLocator>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">hijklmt</xsl:with-param>
                    </xsl:call-template>
                </shelfLocator>
            </xsl:if>
            <!-- 1.114 -->
            <xsl:if test="subfield[@code = 'p' or @code = 't']">
                <holdingSimple>
                    <copyInformation>
                        <xsl:for-each select="subfield[@code = 'p'] | subfield[@code = 't']">
                            <itemIdentifier>
                                <xsl:if test="@code = 't'">
                                    <xsl:attribute name="type">
                                        <xsl:text>copy number</xsl:text>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:apply-templates select="."/>
                            </itemIdentifier>
                        </xsl:for-each>
                    </copyInformation>
                </holdingSimple>
            </xsl:if>
        </location>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createLocationFrom856">
        <xsl:if test="//datafield[@tag = '856'][@ind2 != 2][subfield[@code = 'u']]">
            <location>
                <!-- 1.121 -->
                <xsl:call-template name="xxx880"/>
                <url displayLabel="electronic resource">
                    <!-- 1.41 tmee AQ1.9 added choice protocol for @usage="primary display" -->
                    <xsl:variable name="primary">
                        <xsl:choose>
                            <xsl:when
                                test="@ind2 = 0 and count(preceding-sibling::datafield[@tag = '856'][@ind2 = 0]) = 0"
                                >true</xsl:when>

                            <xsl:when
                                test="@ind2 = 1 and count(ancestor::record//datafield[@tag = '856'][@ind2 = 0]) = 0 and count(preceding-sibling::datafield[@tag = '856'][@ind2 = 1]) = 0"
                                >true</xsl:when>

                            <xsl:when
                                test="@ind2 != 1 and @ind2 != 0 and @ind2 != 2 and count(ancestor::record//datafield[@tag = '856' and @ind2 = 0]) = 0 and count(ancestor::record//datafield[@tag = '856' and @ind2 = 1]) = 0 and count(preceding-sibling::datafield[@tag = '856'][@ind2]) = 0"
                                >true</xsl:when>
                            <xsl:otherwise>false</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$primary = 'true'">
                        <xsl:attribute name="usage">primary display</xsl:attribute>
                    </xsl:if>

                    <xsl:if test="subfield[@code = 'y' or @code = '3']">
                        <xsl:attribute name="displayLabel">
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">y3</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="subfield[@code = 'z']">
                        <xsl:attribute name="note">
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">z</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="subfield[@code = 'u']"/>
                </url>
            </location>
        </xsl:if>
    </xsl:template>
    <xd:doc id="createAccessConditionFrom506" scope="component">
        <xd:desc> accessCondition 506 540 1.87 20130829</xd:desc>
    </xd:doc>
    <xsl:template name="createAccessConditionFrom506">
        <accessCondition type="restriction on access">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcd35</xsl:with-param>
            </xsl:call-template>
        </accessCondition>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="createAccessConditionFrom540">
        <accessCondition type="use and reproduction">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcde35</xsl:with-param>
            </xsl:call-template>
        </accessCondition>
    </xsl:template>

    <!-- recordInfo 040 005 001 003 -->


    <xd:doc>
        <xd:desc> 880 global copy template </xd:desc>
    </xd:doc>
    <xsl:template match="* | @*" mode="global_copy">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | text()" mode="global_copy"/>
        </xsl:copy>
    </xsl:template>
    <xd:doc id="nameTitleGroup" scope="component">
        <xd:desc> 1.24 rules for applying nameTitleGroup attribute </xd:desc>
    </xd:doc>
    <xsl:template name="nameTitleGroup">
        <xsl:choose>
            <xsl:when test="self::datafield[@tag = '240']">
                <xsl:choose>
                    <xsl:when test="../datafield[@tag = '100' or @tag = '110' or @tag = '111']">
                        <xsl:attribute name="nameTitleGroup">1</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when
                test="self::datafield[@tag = '880'][starts-with(subfield[@code = '6'], '240')]">
                <xsl:choose>
                    <xsl:when test="
                            ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '100')] or
                            ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '110')] or
                            ../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '111')]">
                        <xsl:attribute name="nameTitleGroup">
                            <xsl:value-of
                                select="count(preceding-sibling::datafield[@tag = '700' or @tag = '710' or @tag = '711' or @tag = '880']) + 2"
                            />
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="self::datafield[@tag = '100' or @tag = '110' or @tag = '111']">
                <xsl:choose>
                    <xsl:when test="../datafield[@tag = '240']">
                        <xsl:attribute name="nameTitleGroup">1</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="
                    (self::datafield[@tag = '880'][starts-with(subfield[@code = '6'], '100')]
                    or self::datafield[@tag = '880'][starts-with(subfield[@code = '6'], '110')]
                    or self::datafield[@tag = '880'][starts-with(subfield[@code = '6'], '111')])">
                <xsl:choose>
                    <xsl:when
                        test="../datafield[@tag = '880'][starts-with(subfield[@code = '6'], '240')]">
                        <xsl:attribute name="nameTitleGroup">
                            <xsl:value-of
                                select="count(preceding-sibling::datafield[@tag = '700' or @tag = '710' or @tag = '711' or @tag = '880']) + 2"
                            />
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="self::datafield[@tag = '700' or @tag = '710' or @tag = '711']">
                <xsl:choose>
                    <xsl:when test="child::subfield[@code = 't']">
                        <xsl:attribute name="nameTitleGroup">
                            <xsl:value-of
                                select="count(preceding-sibling::datafield[@tag = '700' or @tag = '710' or @tag = '711' or @tag = '880']) + 2"
                            />
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="
                    self::datafield[@tag = '880'][starts-with(subfield[@code = '6'], '100')]
                    | self::datafield[@tag = '880'][starts-with(subfield[@code = '6'], '110')]
                    | self::datafield[@tag = '880'][starts-with(subfield[@code = '6'], '111')]"/>
            <xsl:when
                test="self::datafield[@tag = '880'][starts-with(subfield[@code = '6'], '700')][not(subfield[@code = 't'])]"/>
            <xsl:when
                test="self::datafield[@tag = '880'][starts-with(subfield[@code = '6'], '710')][not(subfield[@code = 't'])]"/>
            <xsl:when
                test="self::datafield[@tag = '880'][starts-with(subfield[@code = '6'], '711')][not(subfield[@code = 't'])]"/>
            <xsl:otherwise>
                <xsl:attribute name="nameTitleGroup">
                    <xsl:value-of
                        select="count(preceding-sibling::datafield[@tag = '700' or @tag = '710' or @tag = '711' or @tag = '880']) + 2"
                    />
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 1.129 add physicalDescription templates-->
    <!-- Templates used to build physicalDescription element -->


    <xd:doc>
        <xd:desc> 300 extent </xd:desc>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '300'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '300')]"
        mode="physDesc">
        <extent>
            <!--  3.5 2.18 20142011  -->
            <xsl:if test="subfield[@code = 'f']">
                <xsl:attribute name="unit">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">f</xsl:with-param>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abce3g</xsl:with-param>
            </xsl:call-template>
        </extent>
    </xsl:template>


    <xd:doc>
        <xd:desc> 351 note</xd:desc>
    </xd:doc>
    <xsl:template match="datafield[@tag = '351']" mode="physDesc">
        <note type="arrangement">
            <xsl:for-each select="subfield[@code = '3']">
                <xsl:apply-templates/>
                <xsl:text>: </xsl:text>
            </xsl:for-each>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abc</xsl:with-param>
            </xsl:call-template>
        </note>
    </xsl:template>


    <xd:doc>
        <xd:desc> 856 internetMediaType </xd:desc>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '856']/subfield[@code = 'q'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '856')]/child::*[code = 'q']"
        mode="physDesc">
        <xsl:if test="string-length(.) &gt; 1">
            <internetMediaType>
                <xsl:apply-templates/>
            </internetMediaType>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="reformattingQuality">
        <xsl:for-each select="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c']">
            <xsl:choose>
                <xsl:when test="substring(text(), 14, 1) = 'a'">
                    <reformattingQuality>access</reformattingQuality>
                </xsl:when>
                <xsl:when test="substring(text(), 14, 1) = 'p'">
                    <reformattingQuality>preservation</reformattingQuality>
                </xsl:when>
                <xsl:when test="substring(text(), 14, 1) = 'r'">
                    <reformattingQuality>replacement</reformattingQuality>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="digitalOrigin" scope="component">
        <xd:desc>digitalOrigin</xd:desc>
        <xd:param name="typeOf008"/>
    </xd:doc>
    <xsl:template name="digitalOrigin">

        <xsl:param name="typeOf008"/>
        <xsl:if test="$typeOf008 = 'CF' and controlfield[@tag = '007'][substring(., 12, 1) = 'a']">
            <digitalOrigin>reformatted digital</digitalOrigin>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'CF' and controlfield[@tag = '007'][substring(., 12, 1) = 'b']">
            <digitalOrigin>digitized microfilm</digitalOrigin>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'CF' and controlfield[@tag = '007'][substring(., 12, 1) = 'd']">
            <digitalOrigin>digitized other analog</digitalOrigin>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="controlField008"/>
        <xd:param name="typeOf008"/>
        <xd:param name="marcLeader6"/>
    </xd:doc>
    <xsl:template name="form">
        <xsl:param name="controlField008"/>
        <xsl:param name="typeOf008"/>
        <xsl:param name="marcLeader6"/>
        <!-- Variables used for caculating form element from controlfields -->
        <xsl:variable name="controlField008-23" select="substring($controlField008, 24, 1)"/>
        <xsl:variable name="controlField008-29" select="substring($controlField008, 30, 1)"/>
        <xsl:variable name="check008-23">
            <xsl:if
                test="$typeOf008 = 'BK' or $typeOf008 = 'MU' or $typeOf008 = 'SE' or $typeOf008 = 'MM'">
                <xsl:value-of select="true()"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="check008-29">
            <xsl:if test="$typeOf008 = 'MP' or $typeOf008 = 'VM'">
                <xsl:value-of select="true()"/>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when
                test="($check008-23 and $controlField008-23 = 'f') or ($check008-29 and $controlField008-29 = 'f')">
                <form authority="marcform">braille</form>
            </xsl:when>
            <xsl:when
                test="($controlField008-23 = ' ' and ($marcLeader6 = 'c' or $marcLeader6 = 'd')) or (($typeOf008 = 'BK' or $typeOf008 = 'SE') and ($controlField008-23 = ' ' or $controlField008 = 'r'))">
                <form authority="marcform">print</form>
            </xsl:when>
            <xsl:when
                test="$marcLeader6 = 'm' or ($check008-23 and $controlField008-23 = 's') or ($check008-29 and $controlField008-29 = 's')">
                <form authority="marcform">electronic</form>
            </xsl:when>
            <xsl:when test="$marcLeader6 = 'o'">
                <form authority="marcform">kit</form>
            </xsl:when>
            <xsl:when
                test="($check008-23 and $controlField008-23 = 'b') or ($check008-29 and $controlField008-29 = 'b')">
                <form authority="marcform">microfiche</form>
            </xsl:when>
            <xsl:when
                test="($check008-23 and $controlField008-23 = 'a') or ($check008-29 and $controlField008-29 = 'a')">
                <form authority="marcform">microfilm</form>
            </xsl:when>
        </xsl:choose>

        <!-- Form element generated from controlfield 007 -->
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c']">
            <form authority="marccategory">electronic resource</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'b']">
            <form authority="marcsmd">chip cartridge</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'c']">
            <form authority="marcsmd">computer optical disc cartridge</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'j']">
            <form authority="marcsmd">magnetic disc</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'm']">
            <form authority="marcsmd">magneto-optical disc</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'o']">
            <form authority="marcsmd">optical disc</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'r']">
            <form authority="marcsmd">remote</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'a']">
            <form authority="marcsmd">tape cartridge</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'f']">
            <form authority="marcsmd">tape cassette</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'h']">
            <form authority="marcsmd">tape reel</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'd']">
            <form authority="marccategory">globe</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'd'][substring(text(), 2, 1) = 'a']">
            <form authority="marcsmd">celestial globe</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'd'][substring(text(), 2, 1) = 'e']">
            <form authority="marcsmd">earth moon globe</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'd'][substring(text(), 2, 1) = 'b']">
            <form authority="marcsmd">planetary or lunar globe</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'd'][substring(text(), 2, 1) = 'c']">
            <form authority="marcsmd">terrestrial globe</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'o']">
            <form authority="marccategory">kit</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'o'][substring(text(), 2, 1) = 'o']">
            <form authority="marcsmd">kit</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a']">
            <form authority="marccategory">map</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'd']">
            <form authority="marcsmd">atlas</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'g']">
            <form authority="marcsmd">diagram</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'j']">
            <form authority="marcsmd">map</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'q']">
            <form authority="marcsmd">model</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'k']">
            <form authority="marcsmd">profile</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'r']">
            <form authority="marcsmd">remote-sensing image</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 's']">
            <form authority="marcsmd">section</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'y']">
            <form authority="marcsmd">view</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'h']">
            <form authority="marccategory">microform</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'a']">
            <form authority="marcsmd">aperture card</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'e']">
            <form authority="marcsmd">microfiche</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'f']">
            <form authority="marcsmd">microfiche cassette</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'b']">
            <form authority="marcsmd">microfilm cartridge</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'c']">
            <form authority="marcsmd">microfilm cassette</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'd']">
            <form authority="marcsmd">microfilm reel</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'g']">
            <form authority="marcsmd">microopaque</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'm']">
            <form authority="marccategory">motion picture</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'm'][substring(text(), 2, 1) = 'c']">
            <form authority="marcsmd">film cartridge</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'm'][substring(text(), 2, 1) = 'f']">
            <form authority="marcsmd">film cassette</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'm'][substring(text(), 2, 1) = 'r']">
            <form authority="marcsmd">film reel</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k']">
            <form authority="marccategory">nonprojected graphic</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'n']">
            <form authority="marcsmd">chart</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'c']">
            <form authority="marcsmd">collage</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'd']">
            <form authority="marcsmd">drawing</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'o']">
            <form authority="marcsmd">flash card</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'e']">
            <form authority="marcsmd">painting</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'f']">
            <form authority="marcsmd">photomechanical print</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'g']">
            <form authority="marcsmd">photonegative</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'h']">
            <form authority="marcsmd">photoprint</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'i']">
            <form authority="marcsmd">picture</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'j']">
            <form authority="marcsmd">print</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'l']">
            <form authority="marcsmd">technical drawing</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'q']">
            <form authority="marccategory">notated music</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'q'][substring(text(), 2, 1) = 'q']">
            <form authority="marcsmd">notated music</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'g']">
            <form authority="marccategory">projected graphic</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 'd']">
            <form authority="marcsmd">filmslip</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 'c']">
            <form authority="marcsmd">filmstrip cartridge</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 'o']">
            <form authority="marcsmd">filmstrip roll</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 'f']">
            <form authority="marcsmd">other filmstrip type</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 's']">
            <form authority="marcsmd">slide</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 't']">
            <form authority="marcsmd">transparency</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'r']">
            <form authority="marccategory">remote-sensing image</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'r'][substring(text(), 2, 1) = 'r']">
            <form authority="marcsmd">remote-sensing image</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 's']">
            <form authority="marccategory">sound recording</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'e']">
            <form authority="marcsmd">cylinder</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'q']">
            <form authority="marcsmd">roll</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'g']">
            <form authority="marcsmd">sound cartridge</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 's']">
            <form authority="marcsmd">sound cassette</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'd']">
            <form authority="marcsmd">sound disc</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 't']">
            <form authority="marcsmd">sound-tape reel</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'i']">
            <form authority="marcsmd">sound-track film</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'w']">
            <form authority="marcsmd">wire recording</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'f']">
            <form authority="marccategory">tactile material</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'f'][substring(text(), 2, 1) = 'c']">
            <form authority="marcsmd">braille</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'f'][substring(text(), 2, 1) = 'b']">
            <form authority="marcsmd">combination</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'f'][substring(text(), 2, 1) = 'a']">
            <form authority="marcsmd">moon</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'f'][substring(text(), 2, 1) = 'd']">
            <form authority="marcsmd">tactile, with no writing system</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 't']">
            <form authority="marccategory">text</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 't'][substring(text(), 2, 1) = 'c']">
            <form authority="marcsmd">braille</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 't'][substring(text(), 2, 1) = 'b']">
            <form authority="marcsmd">large print</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 't'][substring(text(), 2, 1) = 'a']">
            <form authority="marcsmd">regular print</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 't'][substring(text(), 2, 1) = 'd']">
            <form authority="marcsmd">text in looseleaf binder</form>
        </xsl:if>
        <xsl:if test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'v']">
            <form authority="marccategory">videorecording</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'v'][substring(text(), 2, 1) = 'c']">
            <form authority="marcsmd">videocartridge</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'v'][substring(text(), 2, 1) = 'f']">
            <form authority="marcsmd">videocassette</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'v'][substring(text(), 2, 1) = 'd']">
            <form authority="marcsmd">videodisc</form>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'v'][substring(text(), 2, 1) = 'r']">
            <form authority="marcsmd">videoreel</form>
        </xsl:if>
    </xsl:template>
    <!-- 130, 240, 242, 245, 246, 256 246, 730 form elements for physical description -->

    <xd:doc>
        <xd:desc> Form element generated from 130, 240, 242, 245, 246,730 and 256 datafields
        </xd:desc>
    </xd:doc>
    <xsl:template match="
            datafield[@tag = '130']/subfield[@code = 'h']
            | datafield[@tag = '240']/subfield[@code = 'h'] | datafield[@tag = '242']/subfield[@code = 'h']
            | datafield[@tag = '245']/subfield[@code = 'h'] | datafield[@tag = '246']/subfield[@code = 'h']
            | datafield[@tag = '730']/subfield[@code = 'h'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '130')]/subfield[@code = 'h']
            | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '240')]/subfield[@code = 'h']
            | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '242')]/subfield[@code = 'h']
            | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '245')]/subfield[@code = 'h']
            | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '246')]/subfield[@code = 'h']
            | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '730')]/subfield[@code = 'h']"
        mode="physDesc">
        <form authority="gmd">
            <xsl:variable name="str">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="chopBrackets">
                <xsl:with-param name="chopString">
                    <xsl:value-of select="$str"/>
                </xsl:with-param>
            </xsl:call-template>
        </form>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '337']/subfield[@code = 'a'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '337')]/subfield[@code = 'a']"
        mode="physDesc">
        <form>
            <xsl:attribute name="type">
                <xsl:text>media</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="authority">
                <xsl:value-of select="../subfield[@code = '2']"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </form>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '338']/subfield[@code = 'a'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '338')]/subfield[@code = 'a']"
        mode="physDesc">
        <form>
            <xsl:attribute name="type">
                <xsl:text>carrier</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="authority">
                <xsl:value-of select="../subfield[@code = '2']"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </form>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '256']/subfield[@code = 'a'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '256')]/subfield[@code = 'a']"
        mode="physDesc">
        <form>
            <xsl:apply-templates/>
        </form>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="marcLeader6"/>
        <xd:param name="marcLeader7"/>
        <xd:param name="marcLeader19"/>
        <xd:param name="controlField008"/>
        <xd:param name="typeOf008"/>
    </xd:doc>
    <xsl:template name="originInfo">
        <!-- Leader and control field parameters passed from record template -->
        <xsl:param name="marcLeader6"/>
        <xsl:param name="marcLeader7"/>
        <xsl:param name="marcLeader19"/>
        <xsl:param name="controlField008"/>
        <xsl:param name="typeOf008"/>
        <xsl:variable name="dataField260c">
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString"
                    select="datafield[@tag = '260']/subfield[@code = 'c']"/>
            </xsl:call-template>
        </xsl:variable>
        <!--1.166 -->
        <!-- variable name originInfoShared-->
        <xsl:variable name="originInfoShared">
            <!-- MARC Country Codes -->
            <xsl:variable name="marcCountryCode">
                <xsl:analyze-string select="$controlField008"
                    regex="(\d+[a-z]\d{{0,8}})(x{{2}}|[a-z]{{3}}|\D+)">
                    <xsl:matching-substring>
                        <xsl:value-of
                            select="normalize-space(substring(translate(regex-group(2), '0123456789|# ', ''), 1, 3))"
                        />
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:variable name="marcPublicationCode"
                            select="normalize-space(substring(translate(replace($controlField008, '(\d+[a-z]\d+)(\D{2,4})', '$2'), '0123456789|', ' '), 1, 3))"/>
                        <xsl:if test="matches($marcPublicationCode, '\D{3,4}')">
                            <place>
                                <!--<xsl:comment>test 2</xsl:comment>-->
                                <!-- marccountry code -->
                                <placeTerm>
                                    <xsl:attribute name="type">code</xsl:attribute>
                                    <xsl:attribute name="authority">marccountry</xsl:attribute>
                                    <xsl:value-of select="$marcPublicationCode"/>
                                </placeTerm>
                                <!--1.167 -->
                                <placeTerm>
                                    <xsl:attribute name="type">text</xsl:attribute>
                                    <xsl:value-of select="f:decodeMARCCountry($marcPublicationCode)"
                                    />
                                </placeTerm>
                            </place>
                        </xsl:if>
                    </xsl:non-matching-substring>
                    <xsl:fallback>
                        <xsl:variable name="MARCpublicationCode"
                            select="normalize-space(substring($controlField008, 16, 3))"/>
                        <xsl:if test="translate($MARCpublicationCode, '|', '')">
                            <place>
                                <!-- <xsl:comment>test 3</xsl:comment>-->
                                <placeTerm>
                                    <xsl:attribute name="type">code</xsl:attribute>
                                    <xsl:attribute name="authority">marccountry</xsl:attribute>
                                    <xsl:value-of select="$MARCpublicationCode"/>
                                </placeTerm>
                            </place>
                        </xsl:if>
                    </xsl:fallback>
                </xsl:analyze-string>
            </xsl:variable>
            <!-- marccountry code -->
            <xsl:if test="translate($marcCountryCode, '|', '')">
                <xsl:choose>
                    <xsl:when test="contains($marcCountryCode, 'xx')"/>
                    <xsl:when test="matches($marcCountryCode, '[a-z]{2,3}')">
                        <place>
                            <placeTerm>
                                <xsl:attribute name="type">code</xsl:attribute>
                                <xsl:attribute name="authority">marccountry</xsl:attribute>
                                <xsl:value-of select="$marcCountryCode"/>
                            </placeTerm>
                            <!-- decodes MARC Country Codes -->
                            <placeTerm>
                                <xsl:attribute name="type">text</xsl:attribute>
                                <xsl:value-of select="f:decodeMARCCountry($marcCountryCode)"/>
                            </placeTerm>
                        </place>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:if>

            <!--dateCreated/dateIssued-->
            <xsl:variable name="controlField008-7-10"
                select="normalize-space(substring($controlField008, 8, 4))"/>
            <xsl:variable name="controlField008-11-14"
                select="normalize-space(substring($controlField008, 12, 4))"/>
            <xsl:variable name="controlField008-6"
                select="normalize-space(substring($controlField008, 7, 1))"/>
            <!-- w3cdtf dates 2022-12-05 CM3 -->
            <xsl:variable name="controlfield008-7-12">
                <xsl:analyze-string select="replace($controlField008, '(\d+[a-z])(\d+.*)', '$2')"
                    regex="(\d+)(.*)">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="$controlField008-7-10"/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:variable>

            <!-- tmee 1.35 and 1.36 and 1.84-->
            <!--
	Example: <controlfield tag="008">221003s2022 flu 001 0 eng </controlfield> 
	Fixed field 008: Character Positions	
			All materials
			00-05 - Date entered on file
			06 - Type of date/Publication status
			07-10 - Date 1
			11-14 - Date 2
			15-17 - Place of publication, production, or execution
			18-34 - [See one of the seven separate 008/18-34 configuration sections for these elements.]
			35-37 - Language
			38 - Modified record
			39 - Cataloging source
		
    Question: Where was this item published?
    Answer: Reading lines 15-17 you can determine it was in "flu" which decode is Florida. 
    -->

            <xsl:if
                test="($controlField008-6 = 'e' or $controlField008-6 = 'p' or $controlField008-6 = 'r' or $controlField008-6 = 's' or $controlField008-6 = 't') and ($marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't')">
                <xsl:if test="$controlField008-7-10 and ($controlField008-7-10 != $dataField260c)">
                    <dateCreated encoding="marc">
                        <xsl:value-of select="$controlField008-7-10"/>
                    </dateCreated>
                </xsl:if>
            </xsl:if>
            <!-- 2022-11-23 CM3, added NALControlField008 variable -->
            <xsl:choose>
                <!--YYYYMMDD -->
                <xsl:when
                    test="($controlField008-6 = 'e' or $controlField008-6 = 'p' or $controlField008-6 = 'r' or $controlField008-6 = 's' or $controlField008-6 = 't') and not($marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't')">
                    <!-- use substring to limit for dates-->
                    <xsl:variable name="NALcontrolField008"
                        select="substring(controlfield[@tag = '008'], 1, 15)"/>
                    <xsl:choose>
                        <xsl:when test="matches($NALcontrolField008, '(\d+)(\w)(.*)')">
                            <xsl:analyze-string select="substring($NALcontrolField008, 1, 15)"
                                regex="(\d+)(\w)(\d+)">
                                <xsl:matching-substring>
                                    <dateIssued encoding="w3cdtf" keyDate="yes">
                                        <xsl:choose>
                                            <xsl:when test="matches(regex-group(3), '\d{8}')">
                                                <!--YYYY-->
                                                <xsl:number value="substring(regex-group(3), 1, 4)"
                                                  format="0001"/>
                                                <xsl:text>-</xsl:text>
                                                <!--MM-->
                                                <xsl:number value="substring(regex-group(3), 5, 2)"
                                                  format="01"/>
                                                <xsl:text>-</xsl:text>
                                                <!--DD-->
                                                <xsl:number value="substring(regex-group(3), 7, 2)"
                                                  format="01"/>
                                            </xsl:when>
                                            <xsl:when test="matches(regex-group(3), '\d{6}')">
                                                <!--YYYY-->
                                                <xsl:number value="substring(regex-group(3), 1, 4)"
                                                  format="0001"/>
                                                <xsl:text>-</xsl:text>
                                                <!--MM-->
                                                <xsl:number value="substring(regex-group(3), 5, 2)"
                                                  format="01"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!--YYYY-->
                                                <xsl:number value="substring(regex-group(3), 1, 4)"
                                                  format="0001"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </dateIssued>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                        <xsl:when test="contains(., $controlfield008-7-12)">
                            <dateIssued encoding="marc">
                                <xsl:value-of select="$controlfield008-7-12"/>
                            </dateIssued>
                        </xsl:when>
                        <xsl:when test="contains(., $controlField008-11-14)">
                            <dateIssued encoding="marc">
                                <xsl:value-of
                                    select="concat($controlField008-7-10, $controlField008-11-14)"/>
                            </dateIssued>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>

            <!-- 2014-08-17 JG -->
            <xsl:if
                test="($controlField008-6 = 'e' or $controlField008-6 = 'p' or $controlField008-6 = 'r' or $controlField008-6 = 's' or $controlField008-6 = 't') and ($marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't')">
                <xsl:if test="$controlField008-7-10 and ($controlField008-7-10 != $dataField260c)">
                    <dateCreated encoding="marc">
                        <xsl:value-of select="$controlField008-7-10"/>
                    </dateCreated>
                </xsl:if>
            </xsl:if>

            <!--dateIssued-->
            <xsl:if
                test="($controlField008-6 = 'e' or $controlField008-6 = 'p' or $controlField008-6 = 'r' or $controlField008-6 = 's' or $controlField008-6 = 't') and not($marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't')">
                <xsl:if test="$controlField008-7-10 and ($controlField008-7-10 != $dataField260c)">
                    <dateIssued encoding="marc">
                        <xsl:value-of select="$controlField008-7-10"/>
                    </dateIssued>
                </xsl:if>
            </xsl:if>
            <xsl:if
                test="$controlField008-6 = 'c' or $controlField008-6 = 'd' or $controlField008-6 = 'i' or $controlField008-6 = 'k' or $controlField008-6 = 'm' or $controlField008-6 = 'u'">
                <xsl:if test="$controlField008-7-10">
                    <dateIssued encoding="marc" point="start">
                        <xsl:value-of select="$controlField008-7-10"/>
                    </dateIssued>
                </xsl:if>
            </xsl:if>
            <xsl:if
                test="$controlField008-6 = 'c' or $controlField008-6 = 'd' or $controlField008-6 = 'i' or $controlField008-6 = 'k' or $controlField008-6 = 'm' or $controlField008-6 = 'u'">
                <xsl:if test="$controlField008-11-14">
                    <dateIssued encoding="marc" point="end">
                        <xsl:value-of select="$controlField008-11-14"/>
                    </dateIssued>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$controlField008-6 = 'q'">
                <xsl:if test="$controlField008-7-10">
                    <dateIssued encoding="marc" point="start" qualifier="questionable">
                        <xsl:value-of select="$controlField008-7-10"/>
                    </dateIssued>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$controlField008-6 = 'q'">
                <xsl:if test="$controlField008-11-14">
                    <dateIssued encoding="marc" point="end" qualifier="questionable">
                        <xsl:value-of select="$controlField008-11-14"/>
                    </dateIssued>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$controlField008-6 = 't'">
                <xsl:if test="$controlField008-11-14">
                    <copyrightDate encoding="marc">
                        <xsl:value-of select="$controlField008-11-14"/>
                    </copyrightDate>
                </xsl:if>
            </xsl:if>
            <!-- issuance -->
            <xsl:for-each select="leader">
                <!-- 1.120 - @260$ -->
                <!-- 1.158 -->
                <xsl:if test="
                        $marcLeader7 = 'a' or $marcLeader7 = 'c' or $marcLeader7 = 'd' or $marcLeader7 = 'm' or $marcLeader7 = 'b'
                        or ($marcLeader7 = 'm' and ($marcLeader19 = 'a' or $marcLeader19 = 'b' or $marcLeader19 = 'c'))
                        or ($marcLeader7 = 'm' and ($marcLeader19 = ' ')) or $marcLeader7 = 'm' and ($marcLeader19 = '#') or $marcLeader7 = 'i' or $marcLeader7 = 's'">
                    <issuance>
                        <xsl:choose>
                            <xsl:when
                                test="$marcLeader7 = 'a' or $marcLeader7 = 'c' or $marcLeader7 = 'd' or $marcLeader7 = 'm'"
                                >monographic</xsl:when>
                            <xsl:when
                                test="$marcLeader7 = 'm' and ($marcLeader19 = 'a' or $marcLeader19 = 'b' or $marcLeader19 = 'c')"
                                >multipart monograph</xsl:when>
                            <!-- 1.106 20141218 -->
                            <xsl:when test="$marcLeader7 = 'm' and ($marcLeader19 = ' ')">single
                                unit</xsl:when>
                            <xsl:when test="$marcLeader7 = 'm' and ($marcLeader19 = '#')">single
                                unit</xsl:when>
                            <!--1.152-->
                            <!--<xsl:when test="$marcLeader7 = 'i'">integrating resource</xsl:when>
							<xsl:when test="$marcLeader7 = 'b' or $marcLeader7 = 's'"
								>serial</xsl:when>-->
                        </xsl:choose>
                    </issuance>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="$typeOf008 = 'SE'">
                <xsl:for-each select="controlfield[@tag = '008']">
                    <xsl:variable name="controlField008-18"
                        select="substring($controlField008, 19, 1)"/>
                    <xsl:variable name="frequency">
                        <frequency>
                            <xsl:choose>
                                <xsl:when test="$controlField008-18 = 'a'">Annual</xsl:when>
                                <xsl:when test="$controlField008-18 = 'b'">Bimonthly</xsl:when>
                                <xsl:when test="$controlField008-18 = 'c'">Semiweekly</xsl:when>
                                <xsl:when test="$controlField008-18 = 'd'">Daily</xsl:when>
                                <xsl:when test="$controlField008-18 = 'e'">Biweekly</xsl:when>
                                <xsl:when test="$controlField008-18 = 'f'">Semiannual</xsl:when>
                                <xsl:when test="$controlField008-18 = 'g'">Biennial</xsl:when>
                                <xsl:when test="$controlField008-18 = 'h'">Triennial</xsl:when>
                                <xsl:when test="$controlField008-18 = 'i'">Three times a
                                    week</xsl:when>
                                <xsl:when test="$controlField008-18 = 'j'">Three times a
                                    month</xsl:when>
                                <xsl:when test="$controlField008-18 = 'k'">Continuously
                                    updated</xsl:when>
                                <xsl:when test="$controlField008-18 = 'm'">Monthly</xsl:when>
                                <xsl:when test="$controlField008-18 = 'q'">Quarterly</xsl:when>
                                <xsl:when test="$controlField008-18 = 's'">Semimonthly</xsl:when>
                                <xsl:when test="$controlField008-18 = 't'">Three times a
                                    year</xsl:when>
                                <xsl:when test="$controlField008-18 = 'u'">Unknown</xsl:when>
                                <xsl:when test="$controlField008-18 = 'w'">Weekly</xsl:when>
                                <!-- 1.106 20141218 -->
                                <xsl:when test="$controlField008-18 = ' '">Completely
                                    irregular</xsl:when>
                                <xsl:when test="$controlField008-18 = '#'">Completely
                                    irregular</xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </frequency>
                    </xsl:variable>
                    <xsl:if test="$frequency != ''">
                        <frequency authority="marcfrequency">
                            <xsl:value-of select="$frequency"/>
                        </frequency>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:variable>
        <!-- Build main originInfo element -->
        <xsl:choose>
            <xsl:when
                test="datafield[@tag = '044' or @tag = '260' or @tag = '046' or @tag = '033' or @tag = '250' or @tag = '310' or @tag = '321'][subfield[@code = '6']]">
                <xsl:for-each
                    select="datafield[@tag = '044' or @tag = '260' or @tag = '046' or @tag = '033' or @tag = '250' or @tag = '310' or @tag = '321'][subfield[@code = '6']]">
                    <originInfo>
                        <xsl:choose>
                            <xsl:when test="self::subfield">
                                <xsl:call-template name="xxs880"/>
                            </xsl:when>
                            <xsl:when test="self::datafield">
                                <xsl:call-template name="xxx880"/>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:copy-of select="$originInfoShared"/>
                        <xsl:choose>
                            <xsl:when test="@tag = '260'">
                                <xsl:apply-templates select="." mode="originInfo">
                                    <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:when test="@tag = '033'">
                                <xsl:apply-templates select="." mode="originInfo">
                                    <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="." mode="originInfo"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </originInfo>
                </xsl:for-each>
                <xsl:if
                    test="datafield[@tag = '044' or @tag = '260' or @tag = '046' or @tag = '033' or @tag = '250' or @tag = '310' or @tag = '321'][not(subfield[@code = '6'])]">
                    <originInfo>
                        <xsl:copy-of select="$originInfoShared"/>
                        <xsl:for-each
                            select="datafield[@tag = '044' or @tag = '260' or @tag = '046' or @tag = '033' or @tag = '250' or @tag = '310' or @tag = '321'][not(subfield[@code = '6'])]">
                            <xsl:choose>
                                <xsl:when test="@tag = '260'">
                                    <xsl:apply-templates select="." mode="originInfo">
                                        <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
                                    </xsl:apply-templates>
                                </xsl:when>
                                <xsl:when test="@tag = '033'">
                                    <xsl:apply-templates select="." mode="originInfo">
                                        <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
                                    </xsl:apply-templates>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="." mode="originInfo"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </originInfo>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if
                    test="datafield[@tag = '044' or @tag = '260' or @tag = '046' or @tag = '033' or @tag = '250' or @tag = '310' or @tag = '321'] or controlfield[@tag = '008']">
                    <originInfo>
                        <xsl:call-template name="z2xx880"/>
                        <xsl:copy-of select="$originInfoShared"/>
                        <xsl:apply-templates select="datafield[@tag = '044']/subfield[@code = 'c']"
                            mode="originInfo"/>
                        <xsl:apply-templates select="datafield[@tag = '260']" mode="originInfo">
                            <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
                        </xsl:apply-templates>
                        <!-- Build date elements -->
                        <xsl:apply-templates select="datafield[@tag = '046']" mode="originInfo"/>
                        <xsl:apply-templates select="datafield[@tag = '033']" mode="originInfo">
                            <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
                        </xsl:apply-templates>
                        <!-- Build edition element -->
                        <xsl:apply-templates select="datafield[@tag = '250']" mode="originInfo"/>
                        <!-- Build frequency element -->
                        <xsl:apply-templates
                            select="datafield[@tag = '310'] | datafield[@tag = '321']"
                            mode="originInfo"/>
                    </originInfo>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <!-- if linking fields add an additional originInfo field -->
        <xsl:for-each select="
                datafield[@tag = '880'][starts-with(subfield[@code = '6'], '260')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '250')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '044')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '046')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '033')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '310')]
                | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '321')]">
            <originInfo>
                <xsl:choose>
                    <xsl:when test="self::subfield">
                        <xsl:call-template name="xxs880"/>
                    </xsl:when>
                    <xsl:when test="self::datafield">
                        <xsl:call-template name="xxx880"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:copy-of select="$originInfoShared"/>
                <xsl:choose>
                    <xsl:when test="@tag = '260'">
                        <xsl:apply-templates select="." mode="originInfo">
                            <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:when test="@tag = '033'">
                        <xsl:apply-templates select="." mode="originInfo">
                            <xsl:with-param name="marcLeader6" select="$marcLeader6"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." mode="originInfo"/>
                    </xsl:otherwise>
                </xsl:choose>
            </originInfo>
        </xsl:for-each>
    </xsl:template>
    <!-- 1.130 originInfo subfields-->

    <xd:doc>
        <xd:desc> @880$6 </xd:desc>
    </xd:doc>
    <xsl:template match="subfield[@code = '6']" mode="originInfo"/>

    <xd:doc>
        <xd:desc> originInfo place 044 </xd:desc>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '044'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '044')]"
        mode="originInfo">
        <xsl:for-each select="subfield[@code = 'c']">
            <place>
                <placeTerm>
                    <xsl:attribute name="type">code</xsl:attribute>
                    <xsl:attribute name="authority">iso3166</xsl:attribute>
                    <xsl:call-template name="chopPunctuationFront">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </placeTerm>
            </place>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc> originInfo place and date 260 </xd:desc>
        <xd:param name="marcLeader6"/>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '260'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '260')]"
        mode="originInfo">
        <xsl:param name="marcLeader6"/>
        <xsl:for-each select="subfield[@code = 'a']">
            <place>
                <placeTerm>
                    <xsl:attribute name="type">text</xsl:attribute>
                    <xsl:call-template name="chopPunctuationFront">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </placeTerm>
            </place>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'b']">
            <publisher>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="."/>
                    <xsl:with-param name="punctuation">
                        <xsl:text>:,;/ </xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </publisher>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'c']">
            <xsl:if
                test="$marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't'">
                <dateCreated>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                </dateCreated>
            </xsl:if>
            <xsl:if
                test="not($marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't')">
                <dateIssued>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                </dateIssued>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'g']">
            <xsl:if
                test="$marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't'">
                <dateCreated>
                    <xsl:value-of select="."/>
                </dateCreated>
            </xsl:if>
            <xsl:if
                test="not($marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't')">
                <dateCreated>
                    <xsl:value-of select="."/>
                </dateCreated>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '046'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '046')]"
        mode="originInfo">
        <xsl:for-each select="subfield[@code = 'm']">
            <dateValid point="start">
                <xsl:value-of select="."/>
            </dateValid>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'n']">
            <dateValid point="end">
                <xsl:value-of select="."/>
            </dateValid>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'j']">
            <dateModified>
                <xsl:value-of select="."/>
            </dateModified>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'c']">
            <dateIssued encoding="marc" point="start">
                <xsl:value-of select="."/>
            </dateIssued>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'e']">
            <dateIssued encoding="marc" point="end">
                <xsl:value-of select="."/>
            </dateIssued>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'k']">
            <dateCreated encoding="marc" point="start">
                <xsl:value-of select="."/>
            </dateCreated>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'l']">
            <dateCreated encoding="marc" point="end">
                <xsl:value-of select="."/>
            </dateCreated>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '033'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '033')]"
        mode="originInfo">
        <xsl:for-each select="self::*[@ind1 = 0 or @ind1 = 1]/subfield[@code = 'a']">
            <dateCaptured encoding="iso8601">
                <xsl:value-of select="."/>
            </dateCaptured>
        </xsl:for-each>
        <xsl:for-each select="self::*[@ind1 = 2]/subfield[@code = 'a'][1]">
            <dateCaptured encoding="iso8601" point="start">
                <xsl:value-of select="."/>
            </dateCaptured>
        </xsl:for-each>
        <xsl:for-each select="self::*[@ind1 = 2]/subfield[@code = 'a'][2]">
            <dateCaptured encoding="iso8601" point="end">
                <xsl:value-of select="."/>
            </dateCaptured>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc> originInfo edition </xd:desc>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '250'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '250')]"
        mode="originInfo">
        <xsl:for-each select="subfield[@code = 'a']">
            <edition>
                <xsl:apply-templates/>
            </edition>
        </xsl:for-each>
    </xsl:template>

    <xd:doc>
        <xd:desc> originInfo frequency </xd:desc>
    </xd:doc>
    <xsl:template
        match="datafield[@tag = '310'] | datafield[@tag = '321'] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '310')] | datafield[@tag = '880'][starts-with(subfield[@code = '6'], '321')]"
        mode="originInfo">
        <frequency>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </frequency>
    </xsl:template>

    <!-- recordInfo 040 005 001 003 -->
    <xd:doc>
        <xd:desc> 880 global copy template </xd:desc>
    </xd:doc>
    <xsl:template match="* | @*" mode="global_copy">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | text()" mode="global_copy"/>
        </xsl:copy>
    </xsl:template>

    <xd:doc id="createNameFrom910" scope="component">
        <xd:desc> name affiliation 910 </xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom910">
        <affiliation>
            <xsl:if test="subfield[@code = 'a']">
                <affiliationPart type="department">
                    <xsl:value-of select="normalize-space(subfield[@code = 'a'])"/>
                </affiliationPart>
            </xsl:if>
            <xsl:if test="subfield[@code = 'b']">
                <affiliationPart type="agency">
                    <xsl:value-of select="normalize-space(subfield[@code = 'b'])"/>
                </affiliationPart>
            </xsl:if>
        </affiliation>
    </xsl:template>


</xsl:stylesheet>
