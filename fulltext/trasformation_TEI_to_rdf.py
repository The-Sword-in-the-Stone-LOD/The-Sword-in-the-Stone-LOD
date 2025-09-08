import sys
import re
import uuid
from lxml import etree
from rdflib import Graph, Namespace, URIRef, Literal
from rdflib.namespace import RDF, RDFS, DCTERMS, FOAF, SKOS, OWL, XSD
from pathlib import Path


# Configuration

script_dir = Path(__file__).resolve().parent
INPUT_FILE = "text.xml"
OUTPUT_TTL = "text.ttl"
OUTPUT_RDF = "text.rdf"

TEI_NS = "http://www.tei-c.org/ns/1.0"
XML_NS = "http://www.w3.org/XML/1998/namespace"

BASE = Namespace("https://sits.org/book/")
SCHEMA = Namespace("http://schema.org/")
BIBO = Namespace("http://purl.org/ontology/bibo/")

# Helpers

def children(node):  
    #Return list of child nodes or empty list if not iterable / no children.
    try:
        return list(node)
    except Exception:
        return []

def local_name(el):
    t = getattr(el, "tag", None)
    if isinstance(t, str):
        return etree.QName(t).localname
    return None

def get_xml_id(el):
    return el.get("{%s}id" % XML_NS)

def slug(s: str) -> str:
    if not s:
        return str(uuid.uuid4())
    s = re.sub(r"\s+", "-", s.strip())
    s = re.sub(r"[^A-Za-z0-9._~\-]", "", s)
    return s.lower() or str(uuid.uuid4())

def gather_text(el):
    if el is None:
        return ""
    return " ".join(t.strip() for t in el.itertext() if t and t.strip())

def extract_text_with_breaks(el, pb_marker_template="[page {n}]"):
    if el is None:
        return ""
    parts = []
    if el.text:
        parts.append(el.text)
    for child in children(el):
        ln = local_name(child)
        if ln == "lb":
            parts.append("\n")
        elif ln == "pb":
            n = child.get("n") or ""
            marker = pb_marker_template.format(n=n) if n else "[page]"
            parts.append(f"\n{marker}\n")
        elif ln == "cb":
            parts.append("\n[column break]\n")
        else:
            parts.append(extract_text_with_breaks(child))
        if child.tail:
            parts.append(child.tail)
    return "".join(parts)

def find_language(el):
    cur = el
    while cur is not None:
        lang = cur.get("{%s}lang" % XML_NS)
        if lang:
            return lang
        cur = cur.getparent()
    return None

# Parse XML

try:
    tree = etree.parse(str(INPUT_FILE))
    root = tree.getroot()
except Exception as e:
    print(f"Error parsing '{INPUT_FILE}': {e}")
    sys.exit(1)

# --------------------------
# RDF setup
# --------------------------
g = Graph()
g.bind("dcterms", DCTERMS)
g.bind("foaf", FOAF)
g.bind("skos", SKOS)
g.bind("owl", OWL)
g.bind("schema", SCHEMA)
g.bind("bibo", BIBO)
g.bind("base", BASE)

work_uri = URIRef(str(BASE) + "work/edizione-digitale")
g.add((work_uri, RDF.type, BIBO.Document))
g.add((work_uri, RDF.type, SCHEMA.CreativeWork))


# General recursion: maps a TEI node to RDF

seg_counters = {}
def next_seg_uri(tag, hint=None):
    seg_counters.setdefault(tag, 0)
    seg_counters[tag] += 1
    base = slug(hint) if hint else tag
    return URIRef(str(BASE) + f"{tag}/{base}-{seg_counters[tag]}")

def map_node(node, parent_uri):
    tag = local_name(node)
    if not tag:
        return

    xid = get_xml_id(node)
    hint = gather_text(node)[:30] or tag
    seg_uri = URIRef(str(BASE) + tag + "/" + slug(xid or hint))

    # link hierarchy
    g.add((parent_uri, DCTERMS.hasPart, seg_uri))

    # types
    if tag in {"teiHeader"}:
        g.add((seg_uri, RDF.type, SCHEMA.CreativeWork))
    elif tag in {"div", "p", "head", "q", "quote", "lg", "l"}:
        g.add((seg_uri, RDF.type, SCHEMA.CreativeWork))
        txt = extract_text_with_breaks(node).strip()
        if txt:
            lang = find_language(node)
            g.add((seg_uri, SCHEMA.text, Literal(txt, lang=lang)))
    elif tag in {"persName", "person"}:
        g.add((seg_uri, RDF.type, FOAF.Person))
        txt = gather_text(node)
        if txt:
            g.add((seg_uri, FOAF.name, Literal(txt)))
    elif tag in {"place", "placeName"}:
        g.add((seg_uri, RDF.type, SCHEMA.Place))
        label = gather_text(node)
        if label:
            g.add((seg_uri, RDFS.label, Literal(label)))
    elif tag in {"org", "orgName"}:
        g.add((seg_uri, RDF.type, FOAF.Organization))
        label = gather_text(node)
        if label:
            g.add((seg_uri, FOAF.name, Literal(label)))
    elif tag == "title":
        g.add((seg_uri, RDF.type, SCHEMA.CreativeWork))
        txt = gather_text(node)
        if txt:
            g.add((seg_uri, DCTERMS.title, Literal(txt)))
    else:
        # default
        g.add((seg_uri, RDF.type, SCHEMA.CreativeWork))

    # attributes as notes
    for (k, v) in node.items():
        if k != "{%s}id" % XML_NS:
            g.add((seg_uri, SKOS.note, Literal(f"{k}={v}")))

    # recursion on children

    for ch in children(node):
        map_node(ch, seg_uri)


# Process in TEI order: first <teiHeader>, then <text>

for child in children(root):
    if local_name(child) == "teiHeader":
        map_node(child, work_uri)

for child in children(root):
    if local_name(child) == "text":
        map_node(child, work_uri)

# --------------------------
# Serialize
# --------------------------
ttl = g.serialize(format="turtle")
rdf = g.serialize(format="xml")
with open(OUTPUT_TTL, "wb") as f:
    f.write(ttl if isinstance(ttl, bytes) else ttl.encode("utf-8"))
with open(OUTPUT_RDF, "wb") as f:
    f.write(rdf if isinstance(rdf, bytes) else rdf.encode("utf-8"))

print("Serialized RDF/Turtle to:", OUTPUT_TTL, "and", OUTPUT_RDF)
print("Triples generated:", len(g))
