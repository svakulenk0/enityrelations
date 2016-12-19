## Wiki2Topic

### Task
Use DBpedia entities to cluster tweets

### Approach

1. Induce entity subgraph: find relations between DBpedia entities in the DBpedia KG
2. Choose cluster labels: nodes in KG used to cluster the input entities


### Insights

Need to separate (filter out) spurious relations

### Related Work

1. Entity relations: MPI, Pirro
2. Scalable graph mining:
  * represent graph in vector space:
    * Percy Liang (Stanford)
    * graph2vec
  * precompute structure indices
    * NSI, e.g. APSP (Rattigan)
  * graph summary
    * Stephane Campinas
