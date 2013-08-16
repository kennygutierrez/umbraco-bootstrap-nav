<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:param name="currentPage"/>

  <!-- update this variable on how deep your site map should be -->
  <xsl:variable name="maxLevelForSitemap" select="4"/>

  <xsl:template match="/">
    <div class="navbar navbar-inverse">
      <div class="navbar-inner">
        <!-- .btn-navbar is used as the toggle for collapsed navbar content -->
        <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
          <span class="icon-bar">&nbsp;</span>

          <span class="icon-bar">&nbsp;</span>

          <span class="icon-bar">&nbsp;</span>
        </a>
        <a class="brand" href="/">
          <img src="/Heath-H-25.png" alt=""/>
        </a>
        <div class="nav-collapse collapse">
          <ul id="topNavigation" class="nav nav-pills">
            <xsl:call-template name="drawTopLevel">
              <xsl:with-param name="parent" select="$currentPage/ancestor-or-self::* [@isDoc and @level=1]"/>
            </xsl:call-template>
          </ul>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="drawTopLevel">
    <xsl:param name="parent"/>
    <xsl:if test="umbraco.library:IsProtected($parent/@id, $parent/@path) = 0 or (umbraco.library:IsProtected($parent/@id, $parent/@path) = 1 and umbraco.library:IsLoggedOn() = 1)">
      <xsl:for-each select="$parent/* [@isDoc and string(umbracoNaviHide) != '1' and @level &lt;= $maxLevelForSitemap]">

        <xsl:if test="count(./* [@isDoc and string(umbracoNaviHide) != '1' and @level &lt;= $maxLevelForSitemap]) = 0">
          <xsl:call-template name="drawSingleItem">
            <xsl:with-param name="parent" select="."/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="count(./* [@isDoc and string(umbracoNaviHide) != '1' and @level &lt;= $maxLevelForSitemap]) &gt; 0">
          <xsl:call-template name="drawDropdownItem">
            <xsl:with-param name="parent" select="."/>
          </xsl:call-template>
        </xsl:if>

      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="drawSingleItem">
    <xsl:param name="parent"/>
    <xsl:if test="umbraco.library:IsProtected($parent/@id, $parent/@path) = 0 or (umbraco.library:IsProtected($parent/@id, $parent/@path) = 1 and umbraco.library:IsLoggedOn() = 1)">
      <li>                
        <a href="{umbraco.library:NiceUrl(@id)}">
          <xsl:value-of select="@nodeName"/>
        </a>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template name="drawDropdownItem">
    <xsl:param name="parent"/>
    <xsl:if test="umbraco.library:IsProtected($parent/@id, $parent/@path) = 0 or (umbraco.library:IsProtected($parent/@id, $parent/@path) = 1 and umbraco.library:IsLoggedOn() = 1)">

      <li class="dropdown">                
        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
          <xsl:value-of select="@nodeName"/>
          <b class="caret">&nbsp;</b>
        </a>

        <ul class="dropdown-menu">
          <li><a href="{umbraco.library:NiceUrl(@id)}">
            <xsl:value-of select="@nodeName"/>
          </a>
              </li>
            <li class="divider">&nbsp;</li>
          <xsl:for-each select="$parent/* [@isDoc and string(umbracoNaviHide) != '1' and @level &lt;= $maxLevelForSitemap]">

            <xsl:call-template name="drawSingleItem">
              <xsl:with-param name="parent" select="."/>
            </xsl:call-template>
          </xsl:for-each>
        </ul>

      </li>

    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
