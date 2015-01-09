<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" 
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:string="xalan://java.lang.String"
  xmlns:java="http://xml.apache.org/xslt/java"  
  exclude-result-prefixes="java">
  
  <xsl:output method="html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />
  <xsl:decimal-format decimal-separator="." grouping-separator="," />
  <xsl:param name="TITLE">Unit Test Results</xsl:param>
  <xsl:param name="NOW"><xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new('yyyy-MM-dd HH:mm:ss'), java:java.util.Date.new())" /></xsl:param>

  <xsl:template match="testsuites">
    <html>
      <head>
        <title>
          <xsl:value-of select="$TITLE" />
        </title>
        <style type="text/css">
          body {
            font-family: verdana,arial,helvetica;
            color: #000000;
            margin: 20px;
          }
          #title {
            margin-bottom: 30px;   
          }
          #logo {
            position: absolute;
            top: 20px;
            right: 20px;
          }
          table.details tr th{
            font-weight: bold;
            text-align: left;
            background: #a6caf0;
          }
          table.details tr td{
            background: #eeeee0;
          }
          p {
            line-height: 1.5em;
            margin-top: 0.5em;
            margin-bottom: 1.0em;
          }
          h1 {
            margin: 0px 0px 5px;
          }
          h2 {
            margin-top: 1em;
            margin-bottom: 0.5em;
          }
          h3, h4, h5, h6 {
            margin-bottom: 0.5em;
          }
          .Error {
            font-weight: bold;
            color: red;
          }
          .Failure {
            font-weight: bold;
            color: purple;
          }
        </style>
        <script type="text/javascript" language="JavaScript"><![CDATA[
        function foo() {}
      ]]>
        </script>
      </head>
      <body>
        <a name="top"></a>
        <xsl:call-template name="pageHeader" />

        <!-- Summary part -->
        <xsl:call-template name="summary" />
        <hr size="1" align="left" />

        <!-- Package List part -->
        <xsl:call-template name="packagelist" />
        <hr size="1" align="left" />

        <!-- For each package create its part -->
        <xsl:call-template name="packages" />
        <hr size="1" align="left" />

        <!-- For each class create the part -->
        <xsl:call-template name="classes" />

      </body>
    </html>
  </xsl:template>



  <!-- ================================================================== -->
  <!-- Write a list of all packages with an hyperlink to the anchor of -->
  <!-- of the package name. -->
  <!-- ================================================================== -->
  <xsl:template name="packagelist">
    <h2>Packages</h2>
    Note: package statistics are not computed recursively, they only sum up all of its testsuites numbers.
    <table class="details" border="0" cellpadding="5" cellspacing="2">
      <xsl:call-template name="testsuite.test.header" />
      <!-- list all packages recursively -->
      <xsl:for-each select="./testsuite[not(./@package = preceding-sibling::testsuite/@package)]">
        <xsl:sort select="@package" />
        <xsl:variable name="testsuites-in-package" select="/testsuites/testsuite[./@package = current()/@package]" />
        <xsl:variable name="testCount" select="sum($testsuites-in-package/@tests)" />
        <xsl:variable name="errorCount" select="sum($testsuites-in-package/@errors)" />
        <xsl:variable name="failureCount" select="sum($testsuites-in-package/@failures)" />
        <xsl:variable name="skippedCount" select="sum($testsuites-in-package/@skipped)" />
        <xsl:variable name="timeCount" select="sum($testsuites-in-package/@time)" />

        <!-- write a summary for the package -->
        <tr valign="top">
          <!-- set a nice color depending if there is an error/failure -->
          <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
                            <xsl:when test="$errorCount &gt; 0">Error</xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
          <td>
            <a href="#{@package}">
              <xsl:value-of select="@package" />
            </a>
          </td>
          <td>
            <xsl:value-of select="$testCount" />
          </td>
          <td>
            <xsl:value-of select="$errorCount" />
          </td>
          <td>
            <xsl:value-of select="$failureCount" />
          </td>
          <td>
            <xsl:value-of select="$skippedCount" />
          </td>
          <td>
            <xsl:call-template name="display-time">
              <xsl:with-param name="value" select="$timeCount" />
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>


  <!-- ================================================================== -->
  <!-- Write a package level report -->
  <!-- It creates a table with values from the document: -->
  <!-- Name | Tests | Errors | Failures | Time -->
  <!-- ================================================================== -->
  <xsl:template name="packages">
    <!-- create an anchor to this package name -->
    <xsl:for-each select="/testsuites/testsuite[not(./@package = preceding-sibling::testsuite/@package)]">
      <xsl:sort select="@package" />
      <a name="{@package}"></a>
      <h3>
        Package
        <xsl:value-of select="@package" />
      </h3>

      <table class="details" border="0" cellpadding="5" cellspacing="2">
        <xsl:call-template name="testsuite.test.header" />

        <!-- match the testsuites of this package -->
        <xsl:apply-templates select="/testsuites/testsuite[./@package = current()/@package]" mode="print.test" />
      </table>
      <a href="#top">Back to top</a>
      <p />
      <p />
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="classes">
    <xsl:for-each select="testsuite">
      <xsl:sort select="@name" />
      <!-- create an anchor to this class name -->
      <a name="{@name}"></a>
      <h3>
        TestCase
        <xsl:value-of select="@name" />
      </h3>

      <table class="details" border="0" cellpadding="5" cellspacing="2">
        <xsl:call-template name="testcase.test.header" />
        <!-- test can even not be started at all (failure to load the class) so report the error directly -->
        <xsl:if test="./error">
          <tr class="Error">
            <td colspan="4">
              <xsl:apply-templates select="./error" />
            </td>
          </tr>
        </xsl:if>
        <xsl:apply-templates select="./testcase" mode="print.test" />
      </table>
      <p />

      <a href="#top">Back to top</a>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="summary">
    <h2>Summary</h2>
    <xsl:variable name="testCount" select="sum(testsuite/@tests)" />
    <xsl:variable name="errorCount" select="sum(testsuite/@errors)" />
    <xsl:variable name="failureCount" select="sum(testsuite/@failures)" />
    <xsl:variable name="skippedCount" select="sum(testsuite/@skipped)" />
    <xsl:variable name="timeCount" select="sum(testsuite/@time)" />
    <xsl:variable name="successRate" select="($testCount - $failureCount - $errorCount) div $testCount" />
    <table class="details" border="0" cellpadding="5" cellspacing="2">
      <tr valign="top">
        <th>Tests</th>
        <th>Failures</th>
        <th>Errors</th>
        <th>Skipped</th>
        <th>Success rate</th>
        <th>Time</th>
      </tr>
      <tr valign="top">
        <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
                    <xsl:when test="$errorCount &gt; 0">Error</xsl:when>
                </xsl:choose>
            </xsl:attribute>
        <td>
          <xsl:value-of select="$testCount" />
        </td>
        <td>
          <xsl:value-of select="$failureCount" />
        </td>
        <td>
          <xsl:value-of select="$errorCount" />
        </td>
        <td>
          <xsl:value-of select="$skippedCount" />
        </td>
        <td>
          <xsl:call-template name="display-percent">
            <xsl:with-param name="value" select="$successRate" />
          </xsl:call-template>
        </td>
        <td>
          <xsl:call-template name="display-time">
            <xsl:with-param name="value" select="$timeCount" />
          </xsl:call-template>
        </td>

      </tr>
    </table>
    <table border="0">
      <tr>
        <td style="text-align: justify;">
          Note:
          <i>failures</i>
          are anticipated and checked for with assertions while
          <i>errors</i>
          are unanticipated.
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- Page HEADER -->
  <xsl:template name="pageHeader">
    <h1 id="title"><xsl:value-of select="$TITLE" /> from <xsl:value-of select="$NOW" /></h1>
    <img src="data:image/gif;base64,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" id="logo"/>
    <hr size="1" />
  </xsl:template>

  <xsl:template match="testsuite" mode="header">
    <tr valign="top">
      <th width="80%">Name</th>
      <th>Tests</th>
      <th>Errors</th>
      <th>Failures</th>
      <th>Skipped</th>
      <th nowrap="nowrap">Time(s)</th>
    </tr>
  </xsl:template>

  <!-- class header -->
  <xsl:template name="testsuite.test.header">
    <tr valign="top">
      <th width="80%">Name</th>
      <th>Tests</th>
      <th>Errors</th>
      <th>Failures</th>
      <th>Skipped</th>
      <th nowrap="nowrap">Time(s)</th>
    </tr>
  </xsl:template>

  <!-- method header -->
  <xsl:template name="testcase.test.header">
    <tr valign="top">
      <th>Name</th>
      <th>Status</th>
      <th nowrap="nowrap">Time(s)</th>
      <th>Requirements</th>
      <th>Risks</th>
    </tr>
  </xsl:template>


  <!-- class information -->
  <xsl:template match="testsuite" mode="print.test">
    <tr valign="top">
      <!-- set a nice color depending if there is an error/failure -->
      <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="@failures[.&gt; 0]">Failure</xsl:when>
                <xsl:when test="@errors[.&gt; 0]">Error</xsl:when>
            </xsl:choose>
        </xsl:attribute>

      <!-- print testsuite information -->
      <td>
        <a href="#{@name}">
          <xsl:value-of select="@name" />
        </a>
      </td>
      <td>
        <xsl:value-of select="@tests" />
      </td>
      <td>
        <xsl:value-of select="@errors" />
      </td>
      <td>
        <xsl:value-of select="@failures" />
      </td>
      <td>
        <xsl:value-of select="@skipped" />
      </td>
      <td>
        <xsl:call-template name="display-time">
          <xsl:with-param name="value" select="@time" />
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="testcase" mode="print.test">
    <tr valign="top">
      <xsl:attribute name="class">
            <xsl:choose>
                <xsl:when test="failure | error">Error</xsl:when>
            </xsl:choose>
        </xsl:attribute>
      <td>
        <xsl:value-of select="@name" />
      </td>
      <xsl:choose>
        <xsl:when test="failure">
          <td>Failure</td>
          <td>
            <xsl:apply-templates select="failure" />
          </td>
        </xsl:when>
        <xsl:when test="error">
          <td>Error</td>
          <td>
            <xsl:apply-templates select="error" />
          </td>
        </xsl:when>
        <xsl:when test="skipped">
          <td>Skipped</td>
          <td>
            <xsl:apply-templates select="skipped" />
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td>Success</td>
        </xsl:otherwise>
      </xsl:choose>
      <td>
        <xsl:call-template name="display-time">
          <xsl:with-param name="value" select="@time" />
        </xsl:call-template>
      </td>
      <td><xsl:value-of select="@requirements" /></td>
      <td><xsl:value-of select="@risks" /></td>
    </tr>
  </xsl:template>


  <xsl:template match="failure">
    <xsl:call-template name="display-failures" />
  </xsl:template>

  <xsl:template match="error">
    <xsl:call-template name="display-failures" />
  </xsl:template>

  <xsl:template match="skipped">
    <xsl:call-template name="display-failures" />
  </xsl:template>

  <!-- Style for the error, failure and skipped in the testcase template -->
  <xsl:template name="display-failures">
    <xsl:choose>
      <xsl:when test="not(@message)">
        N/A
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@message" />
      </xsl:otherwise>
    </xsl:choose>
    <!-- display the stacktrace -->
    <code>
      <br />
      <br />
      <xsl:call-template name="br-replace">
        <xsl:with-param name="word" select="." />
      </xsl:call-template>
    </code>
    <!-- the later is better but might be problematic for non-21" monitors... -->
    <!--pre><xsl:value-of select="."/></pre -->
  </xsl:template>

  <!-- template that will convert a carriage return into a br tag @param word the text from which to convert CR to BR tag -->
  <xsl:template name="br-replace">
    <xsl:param name="word" />
    <xsl:choose>
      <xsl:when test="contains($word, '&#xa;')">
        <xsl:value-of select="substring-before($word, '&#xa;')" />
        <br />
        <xsl:call-template name="br-replace">
          <xsl:with-param name="word" select="substring-after($word, '&#xa;')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$word" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="display-time">
    <xsl:param name="value" />
    <xsl:value-of select="format-number($value,'0.000')" />
  </xsl:template>

  <xsl:template name="display-percent">
    <xsl:param name="value" />
    <xsl:value-of select="format-number($value,'0.00%')" />
  </xsl:template>

</xsl:stylesheet>
