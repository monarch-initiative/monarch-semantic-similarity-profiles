PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
#SELECT ?subject_id ?predicate_id ?object_id   WHERE {
INSERT { ?subject_id owl:equivalentClass ?object_id . }
WHERE {
  VALUES ?predicate_id { skos:exactMatch }
  ?subject_id ?predicate_id ?object_id .
}
