<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
  >


  <!-- The template below names the template that will output a separate HTML page for the table of contents. 
            -->

  <xsl:output method="xhtml" indent="yes" name="toc-format"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />

             <!-- The template below names the template that will output a separate HTML page for the front page. 
            -->
          
<xsl:output name="front-format" method="xhtml" indent="yes"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />
            
            <!-- The template below names the template that will output a separate HTML page for each topic. 
            -->
  <xsl:output name="topic-format" method="xhtml" indent="no" media-type="text/xml"
   doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />
         
           <!-- The template below names the template that will output a separate HTML page for the glossary. 
            -->   
 <xsl:output name="glossary-format" method="xhtml" indent="yes"
         doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />
            
            <!-- The template below names the template that will output a separate HTML page for the index. 
            -->
	<xsl:output name="index-format" method="xhtml" indent="no"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" />
            
              <!-- Root template sets up the different HTML pages that will be created using xsl:result-document -->
                <xsl:template match="/">
                
    <!-- The HTML pages are created inside the Output directory inside the project. Note that the paths to the files are relative to the XSLT file and not the XML file. -->    
 <!-- Create the TOC page. -->
  <xsl:result-document href="../Output/helpmanual/toc.html" format="toc-format" >
   <xsl:call-template name="toc"/>
  </xsl:result-document>
  
  <!-- Create the home page. -->
   <xsl:result-document href="../Output/helpmanual/index.html" format="front-format">
  <xsl:call-template name="front"/>
  </xsl:result-document>
  
  <!-- Create the Index page. This page is created only if there are indexterm elements present in the XML file. -->
  <xsl:if test="//indexterm">
 <xsl:result-document href="../Output/helpmanual/indexpage.html" format="index-format" >
  <xsl:call-template name="index"/>
  </xsl:result-document>
  </xsl:if>
  
  <!-- Create the Glossary page. This page is created only if the glossary element is present in the XML file. -->
   <xsl:if test="//glossary">
  <xsl:result-document href="../Output/helpmanual/glossary.html" format="glossary-format" >
  <xsl:call-template name="glossary"/>
  </xsl:result-document>
  </xsl:if>
  
  <!-- Create the Marker's Comments page. This page is created only if there are imcomment elements present in the XML file. -->
   <xsl:if test="//mcomment">
    <xsl:result-document href="../Output/helpmanual/mcomment.html" format="glossary-format" >
  <xsl:call-template name="mcommentpage"/>
  </xsl:result-document>
    </xsl:if>
  
  <!-- Create the Bibliography page. This page is created only if the biblio element is present in the XML file. -->
   <xsl:if test="//biblio">
    <xsl:result-document href="../Output/helpmanual/biblio.html" format="glossary-format">
  <xsl:call-template name="bibliopage"/>
  </xsl:result-document>
    </xsl:if>
  
  <!-- We need to create an HTML page for each topic, so we include the xsl:for-each here. -->
  <xsl:for-each select="helpmanual//topic">

 <!-- Variable used to insert numbering into topic titles. -->
  <xsl:variable name="count-title">
   <xsl:number count="//topic"  from="helpmanual" level="multiple" format="1.1"/>
 </xsl:variable>
 
 <!-- Create variable to count the topics. Then create variable to name each topic using the count-temp variable. -->
 <xsl:variable name="count-temp">
   <xsl:number count="//topic"  from="helpmanual" level="any" format="1"/>
 </xsl:variable>
 
  <xsl:variable name="newtopicpage">
<xsl:text>topic</xsl:text><xsl:value-of  select="$count-temp"/><xsl:text>.html</xsl:text>
 </xsl:variable>

<!-- Create an HTML page for each topic element. Use the newtopicpage variable to name each HTML topic page. -->
 <xsl:result-document href="../Output/helpmanual/{$newtopicpage}" format="topic-format"> 
 
 <html xmlns="http://www.w3.org/1999/xhtml">
      <head><title><xsl:value-of select="helpmanual/front/title"/> </title>
      <link rel="stylesheet"  type="text/css" href="stylesheets/styles.css"/>
      <meta http-equiv="content-type" content="text/html; charset=utf-8" />
       <script type="text/javascript" src="stylesheets/dropdowns.js"></script>
      </head>
      <body>
      <!-- Call templates for headers. -->
     <xsl:call-template name="header"/>
       <xsl:call-template name="subheaderarrows"/>
     <div class="main">
          <xsl:call-template name="subheader"/>
          <!-- Add numbering beside the titles only if the topicnumbers attribute of the helpmanual element has a value of 'yes'. -->
        <h2><xsl:if test="/helpmanual[@topicnumbers='yes']"><xsl:value-of select="$count-title"/>. </xsl:if><xsl:apply-templates select="title"/></h2>
 <xsl:apply-templates select="body"/> 
 <!-- Call the topiclinklist template to insert links to nested topics. -->
  <xsl:call-template  name="topiclinklist"/> 
 <xsl:apply-templates select="related-links"/> 
 </div>
         </body>
    </html>
      </xsl:result-document>
      
  </xsl:for-each>
  
</xsl:template>

<!-- END root template. -->

<!-- Generated links to nested topics -->
<xsl:template name="topiclinklist">

 <xsl:if test="child::topic ">
   <xsl:if test="@class='nestedtopiclinks'">
<p>This section contains the following topics:</p>
<ul>
<xsl:for-each select="child::topic">
<!-- Variable to locate the position number of the nested elements. -->
<xsl:variable name="PageNum"><xsl:value-of select="count(preceding::topic | ancestor-or-self::topic) "/></xsl:variable> 
	<li> <a><xsl:attribute name="href">topic<xsl:value-of select="$PageNum"/>.html</xsl:attribute><xsl:value-of select="title"/></a></li>
</xsl:for-each>
</ul></xsl:if>
</xsl:if>
 </xsl:template>

<!-- Template for header. -->
<xsl:template name="header">
 
<div class="header">
        <span class="moduletitle"> <xsl:value-of select="//helpmanual/front/title"/></span>
<div id="rightheader"><ul>
	<li>
<a href="index.html"> <span>About</span> </a>
</li>
<li><a href="toc.html"> <span>Table of Contents </span></a>
 </li>
 <xsl:if test="//back/glossary">
 <li><a href="glossary.html"> <span>Glossary</span> </a></li>
 </xsl:if>
<xsl:if test="//indexterm">
<li>
<a href="indexpage.html">  <span>Index </span></a> </li>
</xsl:if>
<xsl:if test="//mcomment">
<li>
<a href="mcomment.html">  <span>Comments</span> </a> </li>
</xsl:if>
</ul>
</div>     
        </div>
    </xsl:template>

<!-- Template for subheader - breadcrumb navigation -->

<xsl:template name="subheader">
 <xsl:variable name="topicnumber" select="concat('topic',position(),'.html')"/>
  <xsl:variable name="previoustopicnumber" select="concat('topic',position()-1,'.html')"/>
<xsl:variable name="nexttopicnumber" select="concat('topic',position()+1,'.html')"/>

   <div class="subheader"><span class="breadcrumbs"><a href="index.html">Home</a></span>
     <xsl:if test="parent::helpmanual"> &gt; <xsl:value-of select="title"/></xsl:if>
   <xsl:if test="ancestor::topic"> &gt; <xsl:for-each select="ancestor::topic">
<xsl:variable name="PageNum"><xsl:value-of select="count(preceding::topic | ancestor-or-self::topic) "/></xsl:variable> 
 <a><xsl:attribute name="href">topic<xsl:value-of select="$PageNum"/>.html</xsl:attribute><xsl:value-of select="title"/> </a> &gt; 
</xsl:for-each>
<xsl:value-of select="./title"/>
</xsl:if>
</div>
</xsl:template>

<!-- Template for subheader arrow navigation -->
<xsl:template name="subheaderarrows">
 <xsl:variable name="topicnumber" select="concat('topic',position(),'.html')"/>
  <xsl:variable name="previoustopicnumber" select="concat('topic',position()-1,'.html')"/>
<xsl:variable name="nexttopicnumber" select="concat('topic',position()+1,'.html')"/>
<div class="navarrows">
    <xsl:if test="position()=1"><a href="index.html"><img src="stylesheets/2.png" alt="Go to previous page"/></a></xsl:if>
   <xsl:text> </xsl:text>
   <xsl:if test="position() != 1"><a href="{$previoustopicnumber}"><img src="stylesheets/2.png" alt="Go to previous page"/></a></xsl:if>
   <xsl:text> </xsl:text>
   <xsl:if test="position() != last()"><a href="{$nexttopicnumber}"><img src="stylesheets/1.png" alt="Go to next page"/></a> </xsl:if>
   <xsl:if test="position() = last() and //biblio"><a href="biblio.html"><img src="stylesheets/1.png" alt="Go to next page"/></a> </xsl:if>
   </div>
</xsl:template>

<!-- Template that creates TOC page. -->
<xsl:template name="toc">

 <html xmlns="http://www.w3.org/1999/xhtml">
      <head><title>Table of Contents</title>
      <link rel="stylesheet"  type="text/css" href="stylesheets/styles.css"/>
 <meta http-equiv="content-type" content="text/html; charset=utf-8" />      
      </head>
      <body>
      <xsl:call-template name="header"/>
      <div class="main">
        <h2>Table of Contents</h2>
        <!-- Output a link for each topic. -->
        <div>
			<xsl:for-each select="//topic">
			  <xsl:variable name="count-title"> <xsl:number count="//topic"  from="helpmanual" level="multiple" format="1.1"/> </xsl:variable>
			<xsl:call-template name="toc-indent"/><a><xsl:attribute name="href">topic<xsl:value-of select="position()"/>.html</xsl:attribute>
<xsl:if test="//helpmanual[@topicnumbers='yes']"><xsl:value-of select="$count-title"/>. </xsl:if><xsl:value-of select="./title"/></a><br /></xsl:for-each><xsl:if test="//biblio"><a href="biblio.html" alt="bibliography">Bibliography</a></xsl:if></div></div>
      </body>
    </html>
</xsl:template>


 <!-- Template to add indenting in TOC links. -->
 <xsl:template name="toc-indent">
   <xsl:for-each select="ancestor::topic">&#160;&#160;&#160;</xsl:for-each></xsl:template>

<!-- Tests for biblio and glossary elements and applies the templates if needed. -->
<xsl:template match="back">
<xsl:if test="biblio">
<xsl:apply-templates/>
</xsl:if>
<xsl:if test="glossary">
<xsl:apply-templates/>
</xsl:if>
</xsl:template>

<!-- Template to create glossary page. -->
<xsl:template name="glossary">
 <html xmlns="http://www.w3.org/1999/xhtml">
      <head><title><xsl:value-of select="helpmanual/front/title"/> </title>
      <link rel="stylesheet"  type="text/css" href="stylesheets/styles.css"/></head>
      <body>
       <xsl:call-template name="header"/>
      
    <div class="main">
        <h2>Glossary</h2>
<dl>
<xsl:for-each select="//glossentry">
<dt><xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if><xsl:value-of  select="glossterm"/></dt>
<dd><xsl:apply-templates select="glossdef"/>
</dd>
</xsl:for-each>  </dl></div>     
           </body>
    </html>
</xsl:template>

<!--  Bibliography page -->
<xsl:template name="bibliopage">

 <html xmlns="http://www.w3.org/1999/xhtml">
      <head><title><xsl:value-of select="helpmanual/front/title"/> </title>
      <link rel="stylesheet"  type="text/css" href="stylesheets/styles.css"/>
      <script type="text/javascript" src="stylesheets/dropdowns.js"></script>
  
      </head>
      <body>
       <xsl:call-template name="header"/>
         <div class="navarrows">
<xsl:variable name="PageNumb"><xsl:value-of select="count(//biblio/preceding::topic | biblio//ancestor-or-self::topic) "/></xsl:variable> 
 <a><xsl:attribute name="href">topic<xsl:value-of select="$PageNumb"/>.html</xsl:attribute><xsl:value-of select="title"/> <img src="stylesheets/2.png" alt="Go to previous page"/></a>
   <xsl:text> </xsl:text>

   </div>
        <div class="main">
          <div class="subheader"><span class="breadcrumbs"><a href="index.html">Home</a></span>
 </div>
       <h2>Bibliography</h2>
        </div>
<div class="main">
<xsl:for-each select="//custmbib">
<div class="bib">
<xsl:apply-templates/>
</div> </xsl:for-each>
    </div>
           </body>
    </html>
</xsl:template>

<!-- Template for front page. -->
<xsl:template name="front">
 <html xmlns="http://www.w3.org/1999/xhtml">
      <head><title><xsl:value-of select="helpmanual/front/title"/> </title>
      <link rel="stylesheet"  type="text/css" href="stylesheets/styles.css"/>
        <script type="text/javascript" src="stylesheets/dropdowns.js"></script>
      </head>
      <body>
      <xsl:call-template name="header"/>
      <div class="navarrows">
 <a href="topic1.html"><img src="stylesheets/1.png" alt="Go to next page"/></a>

   </div>
     <div class="main">
           <div class="subheader"> <span class="breadcrumbs">Home</span></div>
 
        <h2><xsl:value-of select="helpmanual/front/title"/></h2>
<xsl:apply-templates select="helpmanual/front/author"/>      
<xsl:apply-templates select="helpmanual/front/version"/>   
<xsl:apply-templates select="helpmanual/front/date"/>   
<xsl:apply-templates select="helpmanual/front/preface"/>   
</div>
         </body>
    </html>
</xsl:template>

<!-- ADD ALPHABET LINKS to Index-->
          
<xsl:template name="index">

   <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
 <title> <xsl:value-of select="helpmanual/front/title"/> - Index </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link rel="stylesheet" href="stylesheets/styles.css" type="text/css"></link>
     </head>
     <body>
     
     <xsl:call-template name="header"/>
     <div class="main">
   <h2>Index</h2>
   <xsl:for-each-group select="//indexterm" group-by="(@term.entry,text())[1]"> 
                                                          
         <xsl:sort select="upper-case(current-grouping-key())"/>
         <div class="index">
           <span>
             <xsl:value-of select="current-grouping-key()"/>
             <xsl:text> - </xsl:text> <xsl:for-each select="current-group()" > 
               <xsl:variable name="PageNo"><xsl:number count="topic" from="helpmanual" level="any"/>
               </xsl:variable>
               <a><xsl:attribute name="href">topic<xsl:value-of select="$PageNo"/>.html</xsl:attribute>
                 <xsl:value-of select="$PageNo" separator=";"/> 
               </a> 
               <xsl:text>; </xsl:text>
               
             </xsl:for-each>  
           </span>
         </div>
 </xsl:for-each-group>
    
         </div>
     </body>
   </html>
 </xsl:template>
 
<!-- Marker's Comments page. -->
<xsl:template name="mcommentpage">

   <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
 <title> <xsl:value-of select="helpmanual/front/title"/> - Marker's Comments </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link rel="stylesheet" href="stylesheets/styles.css" type="text/css"></link>
   <script type="text/javascript" src="stylesheets/dropdowns.js"></script>
     </head>
     <body>
     
     <xsl:call-template name="header"/>
     <div class="main">
   <h2>Marker's Comments</h2>
   
     <xsl:for-each-group select="//mcomment[ancestor::front]" group-by="ancestor::front"> 
    <div class="mcommenttitle"><a><xsl:attribute name="href">index.html</xsl:attribute><img alt="back link" src="stylesheets/mcomback.gif"/></a> <xsl:value-of select="ancestor::front/title"/></div>
    
    <xsl:for-each select="current-group()" > 
<div><xsl:attribute name="id">comment<xsl:number  count="mcomment" from="helpmanual" level="any"/></xsl:attribute>

<xsl:apply-templates/></div>  
</xsl:for-each>
   </xsl:for-each-group> 
   
    <xsl:for-each-group select="//mcomment"  group-by="ancestor::topic[1]"> 
    <div class="mcommenttitle"><a><xsl:attribute name="href">topic<xsl:value-of select="count(ancestor-or-self::topic[1] | preceding::topic | ancestor-or-self::topic) "/>.html</xsl:attribute><img alt="back link" src="stylesheets/mcomback.gif"/></a> <xsl:value-of select="ancestor::topic[1]/title"/></div>
     <xsl:for-each select="current-group()" > 
<div><xsl:attribute name="id">comment<xsl:number  count="mcomment" from="helpmanual" level="any"/></xsl:attribute>

<xsl:apply-templates/></div>  
</xsl:for-each>
  </xsl:for-each-group> 
    
         </div>
     </body>
   </html>
 </xsl:template> 


<!-- Templates for front elements -->
<xsl:template match="author">
<div class="author"><b>Author: </b><xsl:apply-templates/> </div>
</xsl:template>

<xsl:template match="date">
<div class="date"><b>Date: </b><xsl:apply-templates/> </div>
</xsl:template>

<xsl:template match="version">
<div class="version"><b>Version: </b><xsl:apply-templates/> </div>
</xsl:template>

<xsl:template match="preface">
<xsl:apply-templates/> 
</xsl:template>

<!-- Topic elements -->

<xsl:template match="p">
<p> <xsl:apply-templates/>  </p>
</xsl:template>

<xsl:template match="p" mode="nop">
 <xsl:apply-templates/>  
</xsl:template>

<!-- Bullet list - test for bullet attribute to specify the type attribute. -->
<xsl:template match="ul">
<xsl:element name="ul"> 
<xsl:choose>
	<xsl:when test="@bullet='disc' "><xsl:attribute name="type">disc</xsl:attribute></xsl:when>
	<xsl:when test="@bullet='circle' "><xsl:attribute name="type">circle</xsl:attribute></xsl:when>
	<xsl:when test="@bullet='square' "><xsl:attribute name="type">square</xsl:attribute></xsl:when>
	</xsl:choose>
	
<xsl:for-each select="li"><li><xsl:apply-templates/></li></xsl:for-each>  </xsl:element>
</xsl:template>

<xsl:template match="ol">
<ol> 
<xsl:for-each select="li"><li><xsl:apply-templates/></li></xsl:for-each>  </ol>
</xsl:template>

<!-- Note - tests for the type attribute. -->
<xsl:template match="note">
<xsl:choose>
	<xsl:when test="@type='tip'">
	<div class="note">
	<b>Tip: </b><xsl:apply-templates/>  </div>
	</xsl:when>
	<xsl:when test="@type='caution' ">
	<div class="note"><b>Caution: </b><xsl:apply-templates/>  </div>
	</xsl:when>
	<xsl:when test="@type='note' ">
	<div class="note"><b>Note: </b><xsl:apply-templates/>  </div>
	</xsl:when>
</xsl:choose>
</xsl:template>

<xsl:template match="pre">
<pre> 
<xsl:apply-templates/></pre>  
</xsl:template>

<!-- Inline quote. -->
<xsl:template match="q">
<span class="quote"> 
<xsl:apply-templates/></span>  
</xsl:template>

<!-- Long quote. -->
<xsl:template match="lq">
<blockquote> 
<xsl:apply-templates/></blockquote>  
</xsl:template>

<!-- Figure -->
<xsl:template match="fig">
<div class="figure"> 
<xsl:apply-templates select="image"/>
<xsl:if test="figtitle"><div class="figtitle"><b><xsl:apply-templates select="figtitle"/></b><xsl:if test="desc"> - <span class="figtitle"><xsl:apply-templates select="desc"/></span>
</xsl:if></div>  </xsl:if>
</div>  
</xsl:template>

<!-- Related links that display at the end of a topic -->
<xsl:template match="related-links">
	  	<h4 class="related">Related Links</h4>
  	<div class="related_links">
		<xsl:apply-templates select="link"/>		
  </div>
  </xsl:template>

 <!-- use to link between topics and to link to glossary. -->
<xsl:template match="xref">
	<xsl:variable name="xrefid" select="@id"/>
  	<xsl:variable name="id_list" select="//topic/@id"/>
  	<xsl:variable name="glosdef_list" select="//glossentry/@id"/>
<xsl:if test="$xrefid=$glosdef_list">
<a><xsl:attribute name="href">glossary.html#<xsl:value-of select="@id"/></xsl:attribute>
<xsl:apply-templates/> </a>
</xsl:if>
  
<xsl:if test="$xrefid=$id_list">
	<xsl:variable name="PageNo"><xsl:value-of select="count(//topic[@id=$xrefid]/preceding::topic | //topic[@id=$xrefid]/ancestor-or-self::topic) "/></xsl:variable> 
    <a><xsl:attribute name="href">topic<xsl:value-of select="$PageNo"/>.html</xsl:attribute>
<xsl:apply-templates/> </a>
  </xsl:if>
  </xsl:template> 
  
  <!-- Creates an individual link inside Related Links -->
  <xsl:template match="link">
    <xsl:variable name="linkid" select="@id"/>
  	<xsl:variable name="id_list" select="//topic/@id"/>
<xsl:if test="$linkid=$id_list">
<div class="links">
	<xsl:variable name="PageNo"><xsl:value-of select="count(//topic[@id=$linkid]/preceding::topic | //topic[@id=$linkid]/ancestor-or-self::topic) "/></xsl:variable> 
    <a><xsl:attribute name="href">topic<xsl:value-of select="$PageNo"/>.html</xsl:attribute>
<xsl:apply-templates/> </a>
</div>
  </xsl:if>
  </xsl:template>
  
  <xsl:template match="dropdownlink">
  <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="linktext">
  <xsl:variable name="dropid"><xsl:number count="//dropdownlink" from="helpmanual" level="any"/></xsl:variable>
<div class="onclicktext"><a>
<xsl:attribute name="onclick">expandtext('drop<xsl:value-of select="$dropid"/>')</xsl:attribute>  <xsl:apply-templates/></a></div>

  </xsl:template>
  
  <xsl:template match="dropdowntext">
  <xsl:variable name="dropid"><xsl:number count="//dropdownlink" from="helpmanual" level="any"/></xsl:variable>
<div class="dropdowntext" style="display:none;"> <xsl:attribute name="id">drop<xsl:value-of select="$dropid"/></xsl:attribute> <xsl:apply-templates/></div>
  </xsl:template>
<xsl:template match="body">
<xsl:apply-templates/>  
</xsl:template>

<xsl:template match="section/title">
<h4><xsl:apply-templates/></h4>
</xsl:template>

  <xsl:template match="image">
  <!-- Check if XML file points to image using the path Output/Images. If it does, change the path to Output -->
    <xsl:choose>
      <xsl:when test="starts-with(./@href, 'Output/Images/')">
        <xsl:element name="img">
          <xsl:attribute name="src">
            
            <xsl:value-of select="replace(./@href, 'Output/', ' ')"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:value-of select="@alt"/>
          </xsl:attribute>
          
         
        <!--  Still working on pdf images
 <xsl:if test="@width">
          <xsl:attribute name="width">
            <xsl:value-of select="@width"/>
          </xsl:attribute>
          </xsl:if>
          <xsl:if test="@height">
          <xsl:attribute name="height">
            <xsl:value-of select="@height"/>
          </xsl:attribute>
          </xsl:if>
-->
        </xsl:element>
      </xsl:when>
        <xsl:when test="starts-with(@href, '../Output/helpmanual/')">
        <xsl:element name="img">
          <xsl:attribute name="src">
            
            <xsl:value-of select="replace(@href, '../Output/helpmanual/', ' ')"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:value-of select="@alt"/>
          </xsl:attribute>
              </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:value-of select="concat('Images/',@href)"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:value-of select="@alt"/>
          </xsl:attribute>
        <!--   Still working on pdf images  
<xsl:if test="@width">
          <xsl:attribute name="width">
            <xsl:value-of select="@width"/>
          </xsl:attribute>
          </xsl:if>
          <xsl:if test="@height">
          <xsl:attribute name="height">
            <xsl:value-of select="@height"/>
          </xsl:attribute>
          </xsl:if> -->

        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
<xsl:template match="table">
<xsl:element name="table">
<xsl:if test="@width">
<xsl:attribute name="width">
<xsl:value-of select="@width"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@cellpadding">
<xsl:attribute name="cellpadding">
<xsl:value-of select="@cellpadding"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@cellspacing">
<xsl:attribute name="cellspacing">
<xsl:value-of select="@cellspacing"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@border">
<xsl:attribute name="border">
<xsl:value-of select="@border"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@rules">
<xsl:attribute name="rules">
<xsl:value-of select="@rules"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@bgcolor">
<xsl:attribute name="bgcolor">
<xsl:value-of select="@bgcolor"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@align">
	<xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
	</xsl:if>
	<!-- <xsl:if test="@align='left'">
	<xsl:attribute name="class"><xsl:value-of select="@align"/></xsl:attribute>
	</xsl:if>
		<xsl:if test="@align='center'"><xsl:attribute name="class">
<xsl:value-of select="@align"/></xsl:attribute>
	</xsl:if>
		<xsl:if test="@align='right'"><xsl:attribute name="class">
<xsl:value-of select="@align"/></xsl:attribute>
	</xsl:if>
	 -->

<xsl:if test="caption">
<caption>
  <b><xsl:value-of select="caption"/></b>
</caption>
</xsl:if>
<xsl:apply-templates select="thead"/>
<xsl:apply-templates select="tbody"/>
</xsl:element>
</xsl:template>

<xsl:template match="thead | tbody">
  <!-- 
 Future support of rowspan
<xsl:variable name="colsep">
  <xsl:value-of select="colspan"/>
      <xsl:if test="@colspan"><xsl:value-of select="@colspan"/></xsl:if>
   

      <xsl:if test="@rowsep"><xsl:value-of select="@rowsep"/></xsl:if>
  -->
<xsl:for-each select="tr">
<tr>
<xsl:if test="@valign">
<xsl:attribute name="valign">
<xsl:value-of select="@valign"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@align">
<xsl:attribute name="align">
<xsl:value-of select="@align"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@bgcolor">
<xsl:attribute name="bgcolor">
<xsl:value-of select="@bgcolor"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@width">
<xsl:attribute name="width">
<xsl:value-of select="@width"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@height">
<xsl:attribute name="height">
<xsl:value-of select="@height"/>
</xsl:attribute>
</xsl:if>
<xsl:for-each select="th">
	<th>
<xsl:if test="@valign">
<xsl:attribute name="valign">
<xsl:value-of select="@valign"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@align">
<xsl:attribute name="align">
<xsl:value-of select="@align"/>
</xsl:attribute>
</xsl:if>	
<xsl:if test="@width">
<xsl:attribute name="width">
<xsl:value-of select="@width"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@bgcolor">
<xsl:attribute name="bgcolor">
<xsl:value-of select="@bgcolor"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@width">
<xsl:attribute name="width">
<xsl:value-of select="@width"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@height">
<xsl:attribute name="height">
<xsl:value-of select="@height"/>
</xsl:attribute>
</xsl:if>
	<xsl:apply-templates/></th>
	</xsl:for-each>
	
	<xsl:for-each select="td">
	<td>
<xsl:if test="@valign">
<xsl:attribute name="valign">
<xsl:value-of select="@valign"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@align">
<xsl:attribute name="align">
<xsl:value-of select="@align"/>
</xsl:attribute>
</xsl:if>	
<xsl:if test="@width">
<xsl:attribute name="width">
<xsl:value-of select="@width"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@bgcolor">
<xsl:attribute name="bgcolor">
<xsl:value-of select="@bgcolor"/>
</xsl:attribute>
</xsl:if>
<xsl:if test="@height">
<xsl:attribute name="height">
<xsl:value-of select="@height"/>
</xsl:attribute>
</xsl:if>
	<xsl:apply-templates/></td>
	</xsl:for-each>
	
</tr>
</xsl:for-each>
</xsl:template>

<xsl:template match="b">
<b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="i">
<i><xsl:apply-templates/></i>
</xsl:template>

<!-- WEBLINK opens in new window using js -->
<xsl:template match="weblink">
<a>
<xsl:attribute name="href">
<xsl:value-of select="@href"/>
</xsl:attribute>

	<xsl:if test="contains(@href, 'http://')">

<xsl:attribute name="rel">external</xsl:attribute></xsl:if>
<xsl:apply-templates/>
</a>
</xsl:template>


<xsl:template match="//mcomment">

<a><xsl:attribute name="href">mcomment.html#comment<xsl:number  count="mcomment" from="helpmanual" level="any"/></xsl:attribute>
<img alt="Link to Comment" src="stylesheets/mcomment.gif"/></a>
</xsl:template>

<!-- Do not output content of comment element -->
<xsl:template match="//comment">
</xsl:template>

</xsl:stylesheet>
