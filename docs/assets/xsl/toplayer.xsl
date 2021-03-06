<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs tei html" version="2.0">
    <xsl:output method="html"/>

    <!-- transform the root element (TEI) into an HTML template -->
    <xsl:template match="tei:TEI">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text><xsl:text>&#xa;</xsl:text>
        <html lang="en" xml:lang="en">
            <head>
                <title>
                    <!-- add the title from the metadata. This is what will be shown
                    on your browsers tab-->
                    Ida Thoresen Letters
                </title>
                <!-- load bootstrap css (requires internet!) so you can use their pre-defined css classes to style your html -->
                <link rel="stylesheet"
                    href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
                    integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
                    crossorigin="anonymous"/>
                <!-- load the stylesheets in the assets/css folder, where you can modify the styling of your website -->
                <link rel="stylesheet" href="assets/css/main.css"/>
                <link rel="stylesheet" href="assets/css/desktop.css"/>
            </head>
            <body>
                <header>
                    <h1>
                        <xsl:apply-templates select="//tei:TEI//tei:bibl//tei:title"/>
                    </h1>
                </header>
                <nav id="sitenav">
                    <a href="index.html">Home</a> |
                    <a href="Letters.html">Letters</a>
                </nav>
                <main>
                    <div class="content">
                        <!-- first column: load the thumbnail image based on the IIIF link in the graphic above -->
                        <div class="col-">
                            <article id="thumbnail" class="image-container">
                                <img class="letter-image">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="//tei:surface[@xml:id='postit01']//tei:graphic[@xml:id='postit01_thumb']/@url"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="title">
                                        <xsl:value-of select="//tei:facsimile/tei:surface[@xml:id='postit01']//tei:label"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="alt">
                                        <xsl:value-of select="//tei:facsimile/tei:surface[@xml:id='postit01']//tei:figDesc"/>
                                    </xsl:attribute>
                                </img>
                            </article>
                        </div>
                        <!-- second column: apply matching templates for anything nested underneath the tei:text element -->
                        <div class="col-md">
                            <article id="transcription" style="width: fit-content;">
                                <xsl:apply-templates select="//tei:TEI//tei:text"/>
                            </article>
                        </div>
                    </div>
                </main>
                <footer>
                <div class="row" id="footer">
                  <div class="col-sm copyright">
                      <div>
                        <a href="https://creativecommons.org/licenses/by/4.0/legalcode">
                            <img src="assets/img/logos/cc.svg" class="copyright_logo" alt="Creative Commons License"/><img src="assets/img/logos/by.svg" class="copyright_logo" alt="Attribution 4.0 International"/>
                        </a>
                      </div>
                      <div>
                         2022 Charlotte Selander and Sofia R??dstr??m.
                      </div>
                    </div>
                </div>
                </footer>
            </body>
        </html>
    </xsl:template>

    <!-- by default all text nodes are printed out, unless something else is defined.
    We don't want to show the metadata. So we write a template for the teiHeader that
    stops the text nodes underneath (=nested in) teiHeader from being printed into our
    html-->
    <xsl:template match="tei:teiHeader"/>

    <!-- we turn the tei head element (headline) into an html h1 element-->
    <xsl:template match="tei:head">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <xsl:apply-templates/> <br />    
    </xsl:template>
    <xsl:template match="tei:figDesc|tei:note">
        <p hidden="true"> <xsl:apply-templates/> </p>
    </xsl:template>
    
    <xsl:template match="tei:opener|tei:closer">
        <p>
            <!-- apply matching templates for anything that was nested in tei:p -->
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- transform tei paragraphs into html paragraphs -->
    <xsl:template match="tei:p|tei:closer">
        <xsl:choose>
            <xsl:when test="@rend='indent'">
                <p style="text-indent: 2em; margin-bottom: 0px;"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:when test="@rend='text-align: center'">
                <p style="text-align: center; margin-bottom: 0px;"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:otherwise>
                <p style="margin-bottom: 0px;"><xsl:apply-templates/></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:signed|tei:salute|tei:dateline|tei:placeName|tei:opener">
        <xsl:choose>
            <xsl:when test="@rend='text-align: right'">
                <p style="text-align: right; margin-bottom: 0px;"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:when test="@rend='text-align: center'">
                <p style="text-align: center; margin-bottom: 0px;"><xsl:apply-templates/></p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- do not show del in toplayer transcription-->
    <xsl:template match="tei:del">
        <span style="display:none">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- transform tei hi (highlighting) with the attribute @rend="u" into html u elements -->
    <!-- how to read the match? "For all tei:hi elements that have a rend attribute with the value "u", do the following" -->
    <xsl:template match="tei:emph">
        <xsl:choose>
            <xsl:when test="@rend='underline'">
                <u>
                    <xsl:apply-templates/>
                </u>
            </xsl:when>
            <xsl:when test="@rend='italic'">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
