import rdflib, csv, os
import pandas as pd
from rdflib import Graph, URIRef, Literal, Namespace
from rdflib.namespace import XSD

g = Graph()

ns = {
        "sits" : Namespace("https://github.com/The-Sword-in-the-Stone-LOD/The-Sword-in-the-Stone-LOD/"),
        "wd" : Namespace("https://www.wikidata.org/wiki/"),
        "dcterms" : Namespace("http://purl.org/dc/terms/"),
        "crm" : Namespace("https://cidoc-crm.org/html/cidoc_crm/"),
        "rdf" : Namespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#"),
        "owl" : Namespace("http://www.w3.org/2002/07/owl#"),
        "skos": Namespace("http://www.w3.org/2004/02/skos/core#"),
        "gndo": Namespace("https://d-nb.info/standards/elementset/gnd#"),
        "gn" : Namespace("http://www.geonames.org/ontology#"),
        "bf" : Namespace("http://id.loc.gov/ontologies/bibframe/"),
        "bibo": Namespace("http://purl.org/ontology/bibo/"),
        "rda" : Namespace("http://rdaregistry.info/Elements/a/"),
        "metadigit" : Namespace("http://www.iccu.sbn.it/metaAG1"),
        "foaf": Namespace("https://xlmns.com/foaf/0.1/"),
        "schema" : Namespace("https://schema.org/"),
        "viaf" : Namespace("https://viaf.org/en"),
        "tgm" : Namespace("http://id.loc.gov/vocabulary/graphicMaterials/")
    }

for pref, namespace in ns.items():
    g.bind(pref, namespace)

filepath = ("/Users/Martina/Desktop/KO-project/csv_files/formal_language/all_items_formal.csv")
with open(filepath, "r", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    next(reader)

    for row in reader:
        s_prefix, s_name = row['Subject'].split(':')
        s = ns[s_prefix][s_name]

        p_prefix, p_name = row['Predicate'].split(':')
        predicate = ns[p_prefix][p_name]

        obj = row['Object']
        o = None
        if ':' in obj:
            try:
                obj_prefix, obj_name = obj.split(':', 1)
                if obj_prefix in ns:
                    o = ns[obj_prefix][obj_name] 
            except ValueError:
                pass 

        if o is None:
            if obj.isnumeric():
                o = Literal(obj, datatype=XSD.integer)
            else:
                o = Literal(obj, datatype=XSD.string)

        g.add((s,predicate,o))

save_directory = '/Users/Martina/Desktop/KO-project/output'
file_name = 'final_output.ttl'

output_path = os.path.join(save_directory, file_name)

g.serialize(destination=output_path, format='turtle')

print(f"Graph successfully saved to: {output_path}")

