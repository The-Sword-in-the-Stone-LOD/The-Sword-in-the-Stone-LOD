<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/tei:TEI">
        <html lang="en">
            <head>
                <title>
                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/>
                    <xsl:if test="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub']">
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/>
                    </xsl:if>
                </title>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <style>
                    /* Stile generale con layout migliorato */
                    body { 
                        font-family: 'Times New Roman', serif; 
                        line-height: 1.6; 
                        margin: 0; 
                        padding: 20px; 
                        background-color: #f9f5e9; 
                        color: #333;
                        display: flex;
                        justify-content: center;
                    }
                    .container { 
                        max-width: 800px; 
                        background: white; 
                        padding: 40px; 
                        box-shadow: 0 0 15px rgba(0,0,0,0.1); 
                        border: 1px solid #ddd;
                    }
                    h1, h2, h3, h4 { 
                        color: #5a3921; 
                        font-family: Georgia, serif;
                    }
                    h1 { 
                        border-bottom: 2px solid #c9ad7f; 
                        padding-bottom: 15px; 
                        margin-bottom: 30px;
                        text-align: center;
                    }
                    h2 { 
                        border-left: 4px solid #c9ad7f; 
                        padding-left: 15px; 
                        margin-top: 40px;
                    }
                    h3 { 
                        color: #7a5c39; 
                        margin-top: 30px;
                    }
                    .author-info { 
                        font-style: italic; 
                        text-align: center; 
                        margin-bottom: 30px; 
                        color: #666;
                    }
                    .metadata-section { 
                        border: 1px solid #ddd; 
                        padding: 20px; 
                        margin-bottom: 30px; 
                        background-color: #f8f5ef; 
                        border-radius: 5px;
                    }
                    .bibl-info { 
                        margin-left: 20px; 
                        font-size: 0.95em; 
                        color: #555;
                    }
                    .bibl-info p { 
                        margin: 5px 0;
                    }
                    .meta-info { 
                        font-size: 0.9em; 
                        color: #777; 
                        margin-bottom: 15px;
                    }
                    .person-name, .place-name, .term-concept { 
                        font-weight: bold; 
                        color: #8b4513;
                    }
                    .activity { 
                        font-style: italic; 
                        color: #556b2f;
                    }
                    .note { 
                        font-size: 0.85em; 
                        color: #888; 
                        margin-left: 15px; 
                        border-left: 2px solid #ddd; 
                        padding-left: 5px;
                    }
                    .list-people { 
                        margin-top: 15px;
                    }
                    .list-people .person { 
                        margin-bottom: 10px;
                    }
                    .list-people .person-details { 
                        margin-left: 15px; 
                        font-size: 0.9em; 
                        color: #555;
                    }
                    .list-people .person-details .occupation { 
                        font-style: italic;
                    }
                    .list-places .place { 
                        margin-bottom: 10px;
                    }
                    .list-places .place-details { 
                        margin-left: 15px; 
                        font-size: 0.9em; 
                        color: #555;
                    }
                    .keywords-list { 
                        list-style: none; 
                        padding: 0; 
                        display: flex; 
                        flex-wrap: wrap;
                    }
                    .keywords-list li { 
                        background-color: #e6d7c1; 
                        border-radius: 3px; 
                        padding: 5px 10px; 
                        margin: 0 5px 5px 0; 
                        font-size: 0.9em;
                    }
                    .chapter { 
                        margin-bottom: 40px;
                        text-align: justify;
                    }
                    .section { 
                        margin-bottom: 30px;
                    }
                    p { 
                        text-align: justify;
                        margin: 15px 0;
                    }
                    q { 
                        font-style: italic; 
                        quotes: "“" "”" "‘" "’";
                    }
                    .epigraph { 
                        text-align: right; 
                        font-style: italic; 
                        margin: 20px 0; 
                        padding: 10px; 
                        border-top: 1px solid #ddd; 
                        border-bottom: 1px solid #ddd;
                    }
                    .page-break { 
                        font-size: 0.8em; 
                        color: #aaa; 
                        text-align: center; 
                        margin: 10px 0; 
                        font-style: italic;
                    }
                    .center { 
                        text-align: center;
                    }
                    .bold { 
                        font-weight: bold;
                    }
                    .italic { 
                        font-style: italic;
                    }
                    a { 
                        color: #8b4513; 
                        text-decoration: none;
                    }
                    .term-concept {
                        background-color: #fff3cd; /* giallo chiaro per evidenziazione */
                        color: #856404; /* colore testo scuro per contrasto */
                        padding: 2px 6px;
                        border-radius: 3px;
                        border: 1px solid #ffeaa7;
                        font-weight: normal; /* rimuove il grassetto */
                    }
                    .term-concept:hover {
                        background-color: #ffeaa7;
                        cursor: help;
                    }
                    a:hover { 
                        text-decoration: underline;
                    }
                    .source-info {
                        background-color: #f0f0f0;
                        padding: 15px;
                        border-radius: 5px;
                        margin: 15px 0;
                    }
                    .digital-edition-info {
                        background-color: #e6f7ff;
                        padding: 15px;
                        border-radius: 5px;
                        margin: 15px 0;
                    }
                    .two-columns {
                        display: flex;
                        flex-wrap: wrap;
                        justify-content: space-between;
                    }
                    .two-columns > div {
                        width: 48%;
                        margin-bottom: 20px;
                    }
                    @media (max-width: 768px) {
                        .two-columns > div {
                            width: 100%;
                        }
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>
                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/>
                    </h1>
                    <xsl:if test="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub']">
                        <h2 class="center">
                            <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/>
                        </h2>
                    </xsl:if>
                    

                    <!-- METADATA SECTION: ORIGINAL AND DIGITAL EDITION INFORMATION -->
                    <div class="metadata-section">
                        <h2>Source Description</h2>
                        
                        <div class="two-columns">
                            <!-- Original edition information -->
                            <div class="source-info">
                                <h3>Original Edition (1865)</h3>
                                <p><strong>Title:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title[@type='main']"/>
                                </p>
                                <p><strong>Subtitle:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:title[@type='sub']"/>
                                </p>
                                <p><strong>Author:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:author/tei:persName/tei:forename"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:author/tei:persName/tei:surname"/>
                                </p>
                                <p><strong>Publisher:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:publisher"/>
                                </p>
                                <p><strong>Place of publication:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:pubPlace"/>
                                </p>
                                <p><strong>Publication date:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:date"/>
                                </p>
                                <p><strong>Identifiers:</strong> 
                                    OCLC: <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:idno[@type='OCLC']"/>,
                                    WorldCat: <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:idno[@type='WorldCat']"/>
                                </p>
                                <p><strong>Online access:</strong> 
                                    <a href="{tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:ref/@target}" target="_blank">
                                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/tei:ref"/>
                                    </a>
                                </p>
                            </div>
                            
                            <!-- Digital edition information -->
                            <div class="digital-edition-info">
                                <h3>Digital Edition (2025)</h3>
                                <p><strong>Project:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:encodingDesc/tei:projectDesc/tei:p"/>
                                </p>
                                <p><strong>Digital title:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/>
                                    <xsl:if test="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub']">
                                        <xsl:text>: </xsl:text>
                                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='sub']"/>
                                    </xsl:if>
                                </p>
                                <p><strong>Digital curator:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName/tei:forename"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName/tei:surname"/>
                                </p>
                                <p><strong>Digital publisher:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:publisher"/>
                                </p>
                                <p><strong>Digital publication date:</strong> 
                                    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date/@when"/>
                                </p>
                                <p><strong>License:</strong> 
                                    <a href="{tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/@target}" target="_blank">
                                        <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence"/>
                                    </a>
                                </p>
                            </div>
                        </div>

                        <h3>Project Description</h3>
                        <p><xsl:value-of select="tei:teiHeader/tei:encodingDesc/tei:projectDesc/tei:p"/></p>

                        <h3>Cited Works</h3>
                        <ul>
                            <xsl:for-each select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:bibl">
                                <li>
                                    <strong><xsl:value-of select="tei:title"/></strong>
                                    <xsl:text> by </xsl:text>
                                    <xsl:value-of select="tei:author/tei:persName"/>
                                    <xsl:if test="tei:date">
                                        <xsl:text> (</xsl:text>
                                        <xsl:value-of select="tei:date/@when"/>
                                        <xsl:text>)</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="@sameAs">
                                        <xsl:text> [</xsl:text>
                                        <a href="{@sameAs}" target="_blank">Details</a>
                                        <xsl:text>]</xsl:text>
                                    </xsl:if>
                                </li>
                            </xsl:for-each>
                        </ul>

                        <h3>People and Places Mentioned</h3>
                        <h4>Historical People</h4>
                        <ul class="list-people">
                            <xsl:for-each select="tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listPerson[@type='cited-historical-person']/tei:person">
                                <li class="person">
                                    <span class="person-name">
                                        <xsl:value-of select="tei:persName"/>
                                        <xsl:if test="@sameAs"> (<a href="{@sameAs}" target="_blank">Info</a>)</xsl:if>
                                    </span>
                                    <xsl:if test="tei:note">
                                        <div class="person-details">
                                            <xsl:value-of select="tei:note"/>
                                        </div>
                                    </xsl:if>
                                </li>
                            </xsl:for-each>
                        </ul>

                        <h4>Fictional Characters</h4>
                        <ul class="list-people">
                            <xsl:for-each select="tei:teiHeader/tei:profileDesc/tei:particDesc/tei:listPerson[@type='cited-fictional-character']/tei:person">
                                <li class="person">
                                    <span class="person-name">
                                        <xsl:value-of select="tei:persName"/>
                                        <xsl:if test="@sameAs"> (<a href="{@sameAs}" target="_blank">Info</a>)</xsl:if>
                                    </span>
                                    <xsl:if test="tei:note">
                                        <div class="person-details">
                                            <xsl:value-of select="tei:note"/>
                                        </div>
                                    </xsl:if>
                                </li>
                            </xsl:for-each>
                        </ul>

                        <h4>Places</h4>
                        <ul class="list-places">
                            <xsl:for-each select="tei:teiHeader/tei:profileDesc/tei:settingDesc/tei:listPlace/tei:place">
                                <li class="place">
                                    <span class="place-name">
                                        <xsl:value-of select="tei:placeName"/>
                                        <xsl:if test="tei:idno[@type='geonames']"> (<a href="{tei:idno[@type='geonames']}" target="_blank">Info</a>)</xsl:if>
                                        <xsl:if test="tei:idno[@type='pleiades']"> (<a href="{tei:idno[@type='pleiades']}" target="_blank">Info</a>)</xsl:if>
                                        <xsl:if test="tei:idno[@type='wikidata']"> (<a href="{tei:idno[@type='wikidata']}" target="_blank">Info</a>)</xsl:if>
                                    </span>
                                    <xsl:if test="tei:note">
                                        <div class="place-details">
                                            <xsl:value-of select="tei:note"/>
                                        </div>
                                    </xsl:if>
                                </li>
                            </xsl:for-each>
                        </ul>

                        <h3>Keywords</h3>
                        <ul class="keywords-list">
                            <xsl:for-each select="tei:teiHeader/tei:profileDesc/tei:textClass/tei:keywords/tei:term[@xml:lang='en']">
                                <li>
                                    <xsl:value-of select="."/>
                                    <xsl:if test="@sameAs"> (<a href="{@sameAs}" target="_blank">↗</a>)</xsl:if>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>

                    <h2>Annotated Text Content</h2>
                    <xsl:apply-templates select="tei:text"/>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:text">
        <xsl:apply-templates select="tei:front | tei:body"/>
    </xsl:template>

    <xsl:template match="tei:front">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:body">
        <div class="body">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:div[@type='title_page']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:div[@type='preface']">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:div[@type='chapter']">
        <xsl:apply-templates select="tei:head | tei:div[@type='section']"/>
    </xsl:template>

    <xsl:template match="tei:div[@type='section']">
        <xsl:apply-templates select="tei:head | tei:p | tei:quote"/>
    </xsl:template>

    <xsl:template match="tei:p">
        <p>
            <xsl:choose>
                <xsl:when test="@rend='center'"> <!-- If the paragraph has rend='center' -->
                    <xsl:attribute name="class">center</xsl:attribute>
                 </xsl:when>
                 <!-- CONDITION: If the tei:p element has a @rend attribute (any value)-->
                <xsl:when test="@rend"> 
                    <xsl:attribute name="class"> <!-- Then add a 'class' attribute to the <p> tag -->
                        <xsl:value-of select="@rend"/> <!-- The value of the class attribute will be the value of the @rend attribute -->
                    </xsl:attribute>
                </xsl:when>
             </xsl:choose>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:head">
        <xsl:element name="{if (parent::tei:div[@type='chapter']) then 'h2' else 'h3'}"> <!--If the parent of <tei:head> is a <tei:div> with @type='chapter' → create <h2>. Otherwise → create <h3>-->
            <xsl:if test="@rend='center'">
                <xsl:attribute name="class">center</xsl:attribute>  <!--Adds the class="center" attribute to the created element-->
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:epigraph">
        <div class="epigraph">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:quote">
        <q>
            <xsl:apply-templates/>
        </q>
    </xsl:template>

    <xsl:template match="tei:pb">
        <div class="page-break">
            <xsl:text>[Page </xsl:text>
            <xsl:value-of select="@n"/> <!--Extracts the value of the @n (number) attribute of the <tei:pb> element-->
            <xsl:text>]</xsl:text>
        </div>
    </xsl:template>

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>

    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='bold'"> <!-- CASE 1: If the element has the attribute rend='bold' -->
                <span class="bold">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend='italic'"> <!-- CASE 2: If the element has the attribute rend='italic' -->
                <span class="italic">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise> <!-- CASE 3: For all other cases -->
                <span>
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:persName">
        <span class="person-name">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:placeName">
        <span class="place-name">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:term">
        <span class="term-concept">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:date">
        <span class="date">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:name">
        <span class="name">
            <xsl:if test="@sameAs">
                <a href="{@sameAs}" target="_blank">
                    <xsl:apply-templates/>
                </a>
            </xsl:if>
            <xsl:if test="not(@sameAs)"> <!--no link-->
                <xsl:apply-templates/>
            </xsl:if>
        </span>
    </xsl:template>

    <xsl:template match="tei:title">
        <span class="title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:bibl">
        <div class="bibl">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:note">
        <span class="note">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

</xsl:stylesheet>