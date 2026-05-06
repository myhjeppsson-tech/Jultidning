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
                    Digitaliserad version av Julljuset VK 1918
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
                        <xsl:apply-templates select="//tei:titleStmt/tei:title"/>
                    </h1>
                </header>
                <nav id="sitenav">
                    <a href="index.html">Om Julljuset</a> |
                    <a href="Julljuset1918.html">Julljuset 1918</a> |
                    <a href="Ordlista.html">Ordlista</a> |
                    <a href="Konstverk.html">Konstverk</a> |
                    <a href="OmDigitaliseringen.html">Om digitaliseringen</a> |
                </nav>
                <main id="manuscript">
                    <!-- bootstrap "container" class makes the columns look pretty -->
                    <div class="container">
                        <div class="row">
                            
                            <!-- Vänster kolumn: bilder -->
                            <div class="col-md-6">
                                <article id="collection" style="display:flex; flex-direction:column;">
                                    
                                    <xsl:for-each select="//tei:div[@type='page'][position() = (7, 9, 17, 23, 31)]">
                                        <xsl:variable name="facs" select="@facs"/>
                                        
                                        <div style="margin-bottom:1rem;">
                                            <img class="img-full"
                                                src="{//tei:surface[@xml:id=substring-after($facs, '#')]/tei:figure/tei:graphic[1]/@url}"
                                                title="{//tei:surface[@xml:id=substring-after($facs, '#')]/tei:figure/tei:label}"
                                                alt="{//tei:surface[@xml:id=substring-after($facs, '#')]/tei:figure/tei:figDesc}" />
                                        </div>
                                        
                                    </xsl:for-each>
                                    
                                </article>
                            </div>
                            
                            <!-- Höger kolumn: text -->
                            <div class="col-md-6">
                                <article id="description">
                                    
                                    <p><strong>Jules Schyl</strong></p>
                                    
                                    <xsl:apply-templates select="(//tei:profileDesc/tei:abstract)[2]"/>
                                    
                                </article>
                            </div>
                            
                        </div>
                    </div>
                </main>
                <footer>
                <div class="row" id="footer">
                  <div class="col-sm copyright">                     
                      <div>
                          2026 My Hildingsson Jeppsson, Lena Karlsson, Carl Kilstedt, Käbi Petersson.
                      </div>
                    </div>
                </div>
                </footer>
                <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
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

    <!-- transform tei paragraphs into html paragraphs -->
    <xsl:template match="tei:p">
        <p>
            <!-- apply matching templates for anything that was nested in tei:p -->
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- do not show del in toplayer transcription-->
    <xsl:template match="tei:del">
        <span style="display:none">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- transform tei hi (highlighting) with the attribute @rend="u" into html u elements -->
    <!-- how to read the match? "For all tei:hi elements that have a rend attribute with the value "u", do the following" -->
    <xsl:template match="tei:hi[@rend = 'u']">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>

    <!-- transform tei hi (highlighting) with the attribute @rend="sup" into superscript -->
    <xsl:template match="tei:hi[@rend = 'sup']">
        <span style="vertical-align:super; font-size:80%;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- transform tei hi (highlighting) with the attribute @rend="u" into html u elements -->
    <xsl:template match="tei:hi[@rend = 'circled']">
        <span style="border:1px solid black;border-radius:50%">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- give all metamarks with a @place a class of the same name in the html-->
    <!-- out of the box, the css of this template has classes for 'top-left' and 'top-right' values for metamark[@place]. You can change them in `main.css` if you need to.-->
    <!-- if you want to use other values, be sure to also make corresponding class descriptions in your `main.css` stylesheet. -->
    <xsl:template match="tei:metamark[@place]">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="@place"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template> 


</xsl:stylesheet>
