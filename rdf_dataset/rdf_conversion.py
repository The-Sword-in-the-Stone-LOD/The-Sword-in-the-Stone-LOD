import rdflib, csv, os, glob
from datetime import datetime
import pandas as pd
from rdflib import Graph, URIRef, Literal, Namespace
from rdflib.namespace import XSD
from pathlib import Path

g = Graph()

# Setting the namespaces:
ns = {
        "sits" : Namespace("https://github.com/The-Sword-in-the-Stone-LOD/The-Sword-in-the-Stone-LOD/"),
        "wd" : Namespace("https://www.wikidata.org/wiki/"),
        "dbo" : Namespace("https://dbpedia.org/ontology/"),
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
        "tgm" : Namespace("http://id.loc.gov/vocabulary/graphicMaterials/"),
        "mo" : Namespace("http://purl.org/ontology/mo/"),
        "aat" : Namespace("http://vocab.getty.edu/aat/")
    }

for pref, namespace in ns.items():
    g.bind(pref, namespace)


# Acessing the csv files of the items to produce a full dataset:
script_dir = Path(__file__).resolve().parent  # This allows the script to work from its relative path (going back to the absolute) with the csv files' relative path.

csv_folder_path = script_dir.parent / "csv_files" / "formal_language"

all_items = []

for filename in glob.glob(str(csv_folder_path / '*.csv')):
    with open(filename, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        next(reader)

        for row in reader:
            all_items.append(row)

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
            
            # Treating objects that do not have a prefix (namespace):
            if o is None:
                current_year = datetime.now().year
                try:
                    num = int(obj)
                    if 1000 <= num <= current_year + 1:
                        o = Literal(obj, datatype=XSD.gYear) 
                    else:   
                        o = Literal(num, datatype=XSD.integer)   
                except ValueError:
                    o = Literal(obj)
                        
            g.add((s,predicate,o))


output_path = script_dir / "full_dataset.ttl"

g.serialize(destination=output_path, format='turtle')

# print(f"Graph successfully saved to: {output_path}")

