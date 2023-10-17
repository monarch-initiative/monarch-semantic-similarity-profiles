PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX biolink: <https://w3id.org/biolink/vocab/>

#SELECT ?subject_id ?predicate_id ?object_id   WHERE {
INSERT { ?object_id biolink:has_gene ?subject_id . }
WHERE {
  VALUES ?predicate_id { biolink:has_phenotype }
#  VALUES ?predicate_id { <https://w3id.org/biolink/vocab/has_phenotype> }

  ?subject_id ?predicate_id ?object_id .
}
