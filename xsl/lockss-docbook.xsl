<?xml version="1.0" encoding="UTF-8"?>

<!-- 

Copyright (c) 2000-2017, Board of Trustees of Leland Stanford Jr. University
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <!-- 
        Start with fo/docbook.xsl as a base
  -->
  <xsl:import href="../lib/docbook-xsl-ns/fo/docbook.xsl" />
  <xsl:import href="../lib/docbook-xsl-ns/fo/highlight.xsl" />

  <!-- 
        Turn section numbering on
  -->
  <xsl:param name="section.autolabel" select="1" />

  <!-- 
        Enable syntax highlighting
        Passing xslthl.config via makedoc
  -->
  <xsl:param name="highlight.source" select="1" />

  <!--
        Enable pretty admonition graphics
        Passing admon.graphics.path via makedoc
  -->
  <xsl:param name="admon.graphics" select="1" />
  <xsl:param name="admon.graphics.extension" select="'.svg'" />

  <!-- 
       Give verbatim listings shading
  -->
  <xsl:param name="shade.verbatim" select="1" />

  <!-- 
       Make verbatim font size smaller to approximate body font
       Original at fo/param.xsl lines 454-458
  -->
  <xsl:attribute-set name="monospace.properties">
    <xsl:attribute name="font-family">
      <xsl:value-of select="$monospace.font.family"/>
    </xsl:attribute>
    <xsl:attribute name="font-size"><xsl:value-of select="$body.font.master * 0.85"/><xsl:text>pt</xsl:text></xsl:attribute>
  </xsl:attribute-set>

  <!--
        Cross-references only use the numbering, not the title  
  -->
  <xsl:param name="xref.with.number.and.title" select="0" />

  <!-- 
        Make definition list items blocks, not inline
  -->
  <xsl:param name="variablelist.as.blocks" select="1" />

  <!-- 
        <emphasis>: add role="italic" and make default role bold instead of italic
        Original at fo/inline.xsl lines 733-766
  -->
  <xsl:template match="d:emphasis">
    <xsl:choose>
      <xsl:when test="@role='italic'">
        <xsl:call-template name="inline.italicseq"/>
      </xsl:when>
      <xsl:when test="@role='bold' or @role='strong'">
        <xsl:call-template name="inline.boldseq"/>
      </xsl:when>
      <xsl:when test="@role='underline'">
        <fo:inline text-decoration="underline">
          <xsl:call-template name="inline.charseq"/>
        </fo:inline>
      </xsl:when>
      <xsl:when test="@role='strikethrough'">
        <fo:inline text-decoration="line-through">
          <xsl:call-template name="inline.charseq"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <!-- How many regular emphasis ancestors does this element have -->
        <xsl:variable name="depth" select="count(ancestor::d:emphasis
  	[not(contains(' bold strong underline strikethrough ', concat(' ', @role, ' ')))]
  	)"/>
  
        <xsl:choose>
          <xsl:when test="$depth mod 2 = 1">
            <fo:inline font-style="normal">
              <xsl:apply-templates/>
            </fo:inline>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="inline.boldseq"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- 
        <tag>: make default class "starttag" instead of "element"
        Original: fo/inline.xsl lines 980-1085
  -->
  <xsl:template match="d:sgmltag|d:tag">
    <xsl:variable name="class">
      <xsl:choose>
        <xsl:when test="@class">
          <xsl:value-of select="@class"/>
        </xsl:when>
        <xsl:otherwise>starttag</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
    <xsl:choose>
      <xsl:when test="$class='attribute'">
        <xsl:call-template name="inline.monoseq"/>
      </xsl:when>
      <xsl:when test="$class='attvalue'">
        <xsl:call-template name="inline.monoseq"/>
      </xsl:when>
      <xsl:when test="$class='element'">
        <xsl:call-template name="inline.monoseq"/>
      </xsl:when>
      <xsl:when test="$class='endtag'">
        <xsl:call-template name="inline.monoseq">
          <xsl:with-param name="content">
            <xsl:text>&lt;/</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&gt;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$class='genentity'">
        <xsl:call-template name="inline.monoseq">
          <xsl:with-param name="content">
            <xsl:text>&amp;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$class='numcharref'">
        <xsl:call-template name="inline.monoseq">
          <xsl:with-param name="content">
            <xsl:text>&amp;#</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$class='paramentity'">
        <xsl:call-template name="inline.monoseq">
          <xsl:with-param name="content">
            <xsl:text>%</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$class='pi'">
        <xsl:call-template name="inline.monoseq">
          <xsl:with-param name="content">
            <xsl:text>&lt;?</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&gt;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$class='xmlpi'">
        <xsl:call-template name="inline.monoseq">
          <xsl:with-param name="content">
            <xsl:text>&lt;?</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>?&gt;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$class='starttag'">
        <xsl:call-template name="inline.monoseq">
          <xsl:with-param name="content">
            <xsl:text>&lt;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&gt;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$class='emptytag'">
        <xsl:call-template name="inline.monoseq">
          <xsl:with-param name="content">
            <xsl:text>&lt;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>/&gt;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$class='sgmlcomment' or $class='comment'">
        <xsl:call-template name="inline.monoseq">
          <xsl:with-param name="content">
            <xsl:text>&lt;!--</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>--&gt;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="inline.charseq"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>