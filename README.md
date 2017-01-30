## Untangling Entity Relations in the Knowledge Graph

### Idea
Use Knowledge Graph (DBpedia) as a proxy for clustering (e.g. tweets) using entity linking.

### Research Questions

* How to separate common from spurious relations between entities in the knowledge graph?

### Approach

1. Induce entity subgraph: find relations between DBpedia entities in the DBpedia knowledge graph
2. Choose cluster labels: choose nodes in the knowledge graph used to cluster the input entities


### Results
* Hierarchical clustering of DBpedia entities
<img src="results/10_hclust.png" width="800">
* Entity-relation subgraphs
    * Tymoshenko-Putin-Yanukovych
(depth: 1, cores: 1, symmetry: 1, paths: 1)
     ![](results/connectorsTYP.png)
    * Hryvnia-Ukrainian_crisis (depth: 4, cores: 1, symmetry: 1/3, paths: 1)

     ![](results/ukrainecrisis_hryvnia.png)

    * Uganda-JerusalemPost (depth: 7, cores: 3, symmetry: (3/4, 3/4, 4/3), paths: 2, betweenness: Uganda)

    ![](results/uganda_jerusalempost.png)

    * Bible-Ramis (depth: 5, cores: 3, symmetry: [1/4, 2/3, 2/3], paths: 2, betweenness: Jewish_literature)

     ![](results/bible_ramis.png)

* Tymoshenko-Putin-Yanukovych relation subgraph

min distance = 3 edges (Living people)
=> depth = 3/3 = 1 edge on average

max distance path = 114 edges (History of the Pacific Ocean)

|C| = 6,790 (cores/categories)

![](results/TYPdistribution.png)

1. Induce subgraph with distance < 10: |V| = 98 |C| = 25
2. Remove terminal nodes |Q|=3 => connected components = 3

  - People (|V| = 3 = |C|, depth: (1, 2, 3), symmetry: 1, paths: 1)
  ![](results/peopleTYP.png)

  - Alumni_by_university_or_college_in_Europe (|V| = 6, |C| = 1, depth: 3, symmetry: 1, paths: 1)
  ![](results/universityTYP.png)

  - Politics (|V| = 86, |E| = 327, |C| = 21, max_in_degree: Politicians, depth: [7/3; 11/3], betweenness: Ukrainian_politicians)
  ![](results/politicsTYP.png)

  ![](results/politics_labeled_TYP.png)

  ![](results/paths_TYP.png)

* Tymoshenko-Yanukovych relation subgraph

distance < 5 =>
|C| = 27, |V| = 56, width: 7 connected components




### TODO

* algorithm to find the minimum set of vertices to be deleted to separate the vertices in Q


"[Girvan–Newman algorithm](https://en.wikipedia.org/wiki/Girvan–Newman_algorithm) detects communities by progressively removing edges from the original network" using betweenness measure.



### Related Work

#### Entity relations

1. [ESPRESSO (MPI)](http://espresso.mpi-inf.mpg.de/)

  * [ESPRESSO: Explaining Relationships between Entity Sets. S Seufert, K Berberich, SJ Bedathur, SK Kondreddi… CIKM, 2016](https://people.mpi-inf.mpg.de/~kberberi/publications/2016-cikm2016-2.pdf)

  * [Instant Espresso: Interactive Analysis of Relationships in Knowledge Graphs. Stephan Seufert, Patrick Ernst, Srikanta J. Bedathur, Sarath Kumar Kondreddi, Klaus Berberich, and Gerhard Weikum. WWW. 2016](http://www2016.net/proceedings/companion/p251.pdf)

2. Explaining and Suggesting Relatedness in Knowledge Graphs. Pirro.

* The Minimum Wiener Connector Problem. SIGMOD. 2015

#### Scalable graph mining
  * represent graph in vector space:
      * Percy Liang (Stanford)
      * graph2vec
      * subgraph2vec: Learning Distributed Representations of Rooted Sub-graphs from Large Graphs

  * precompute structure indices

      * Exploiting Network Structure for Active Inference in Collective Classification. Matthew J. Rattigan. ICDM.


  * graph summary
      * Stephane Campinas
