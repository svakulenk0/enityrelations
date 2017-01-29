# graph: starting with initial (full) graph 
# -> g2: induced subgraph for the subset of terminal nodes Q 
# -> g3: the biggest component of g2 when Q is deleted (includes Q)


# compute distances and SUM index
sum_sp <- function(graph, q){
  shortest_paths = distances(graph, v=V(graph)[q], to=V(graph), weights=NA, mode='out')
  sum_sp <- as.data.frame(colSums(shortest_paths))
  shortest_paths.T <- t(shortest_paths)
  results <- cbind(shortest_paths.T, sum=sum_sp)
  colnames(results)
  names(results)[names(results)=="colSums(shortest_paths)"] <- "SUM"
  return(results)
}

# My full graph
library(readr)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
edges <- read_csv("../data/categories_7.csv")
library('igraph')
graph <- graph.data.frame(edges)

q3 = c("Viktor_Yanukovych", "Yulia_Tymoshenko", "Vladimir_Putin")
q10 = c("Viktor_Yanukovych", "Yulia_Tymoshenko", "Vladimir_Putin", "Ukrainian_hryvnia", "Uganda_Anti-Homosexuality_Act,_2014", "The_Jerusalem_Post", "Harold_Ramis", "Bible", "Media_portrayal_of_the_Ukrainian_crisis", "Childhood_obesity")
q <- q10

# Compute pair-wise similarities (euclidean distances) betw Q 
## (on the whole but undirected graph)
shortest_paths = distances(graph, v=V(graph)[q], to=V(graph), weights=NA, mode='all')
dim(shortest_paths)
# shortest_paths matrix

similarities <- dist(shortest_paths)
## (on directed subgraph for each combination in Q)
# generate all combinations with shortest distance sum (Inf if unreachable through the node r)
  # shortest_paths = distances(graph, v=V(graph)[q], to=V(graph), weights=NA, mode='out')
  # x <- t(shortest_paths)
  # y <- combn(ncol(x), 2L, function(y) rowSums(x[,y]))
  # colnames(y) <- combn(colnames(x), 2L, paste0, collapse = "")
  # rownames(y) <- rownames(x)
  # # TODO loop through combinations
  # pairs <- combn(q3, 2L)
  # for(i in 1:ncol(pairs)){
  #   # select only the common subgraph reachable by the pair of nodess
  #   q = pairs[,i]
  #   # print(q)
  #   sum_sp <- function(graph, q){
  #     shortest_paths = distances(graph, v=V(graph)[q], to=V(graph), weights=NA, mode='out')
  #     sum_sp <- as.data.frame(colSums(shortest_paths))
  #     shortest_paths.T <- t(shortest_paths)
  #     results <- cbind(shortest_paths.T, sum=sum_sp)
  #     colnames(results)
  #     names(results)[names(results)=="colSums(shortest_paths)"] <- "SUM"
  #     return(results)
  #   }
  #   # q = c("Viktor_Yanukovych", "Yulia_Tymoshenko")
  #   # shortest_paths = distances(graph, v=V(graph)[q], to=V(graph), weights=NA, mode='out')
  #   sum_sp <- sum_sp(graph, q)
  #   reachable <- sum_sp[ which(sum_sp$SUM!=Inf),]
  #   dim(reachable)
  #   # compute distance/similarity value 
  #   similarities <- dist(t(reachable)[1:2,])
  #   print(similarities)
  # }

# hierarchical clustering: most similar pairs of entities (try different linkage methods?)
clusters <- hclust(similarities)
plot(clusters)
# cut off into flat clusters
# TODO automatically select hyperparameter for cutting the hclust tree
memb <- cutree(clusters, k = 1:5)
# clusterCut <- cutree(clusters, k=4)
# table(clusterCut, rownames(shortest_paths))

# TODO loop: for each group (cluster or pair of entities) and find a common category label
groups <- tapply(names(memb[, 4]), memb[, 4], c)
q = groups$'2'
length(q)

# select the closest (most similar) entities
q = c("Viktor_Yanukovych", "Yulia_Tymoshenko")
q = c("Viktor_Yanukovych", "Vladimir_Putin", "Yulia_Tymoshenko")
# q = c("Category:Politics_of_Ukraine", "Vladimir_Putin") 
q = c("Uganda_Anti-Homosexuality_Act,_2014", "The_Jerusalem_Post")
# q = c("Ukrainian_hryvnia", "Media_portrayal_of_the_Ukrainian_crisis")
# q = c("Harold_Ramis", "Bible")

# Construct a subrgaph describing the relations between the entities
wiener <- sum_sp(graph, q)
wiener <- wiener[order(-wiener$SUM),]
# select closest common categories 3 6 7 8  9 10
# q2 2 3 4
# TODO select limit based on the distances in wiener matrix! (keep size of the subgraph managable)
limit = 5
cattable <- wiener[ which(wiener$SUM<limit),]
cats = rownames(cattable)
print(length(cats))

# Collect all shortest paths between the nodes including the category
output <- c()
i = 0
for (cat in cats){
  for (node in q){
    i = i + 1
    # path = shortest_paths(graph, from = V(graph)[node], to = V(graph)[cat], mode='out', output='vpath')
    path = all_shortest_paths(graph, from = V(graph)[node], to = V(graph)[cat], mode='out')
    #print(path$res)
    #print(unlist(path$vpath))
    output[[i]] <- unlist(path$res)
  }
}

# create a single component with all root vertices
subv <- unique(unlist(output))
# subv = subv[which(V(graph)[subv] %in% q)] <- NULL
# size of the subgraph
size = print(length(subv))
# create subgraph
g2 <-induced.subgraph(graph = graph, vids=subv)
V(g2)

# Separate subgraph into connected components
# Remove terminal nodes -> dissolve into sepparate connected components
g2 = delete.vertices(g2, q )
V(g2)
# get components
cl <- clusters(g2)
# loop through to extract common vertices (any cluster size allowed, also single vertices)
clusters <- lapply(seq_along(cl$csize), function(x) 
  V(g2)$name[cl$membership %in% x])
length(clusters)

# TODO sort clusters by size descending
clusters
cluster = clusters[1]

# generate cluster subgraph for the biggest cluster (component)
# add back the terminal nodes
subv = c(unlist(cluster),q)
g3 <-induced.subgraph(graph = graph, vids=V(graph)[subv])
V(g3)


# gr <- g2
# plot subgraph
cats_here = unlist(V(g3)[cats]$name)
vcol <- rep("gray40", vcount(g3))

# mark red the common categories nodes
vcol[as.vector(V(g3)[cats_here])] <- "red"
vcol[as.vector(V(g3)[q])] <- "green"
plot(g3, vertex.size=0, edge.arrow.size=0.2, vertex.label.color=vcol)
# dev.off()


# compute centrality metrics
# library("sna")
gr <- g3
# infocent(graph)
metrics <- data.frame(
  degin=degree(gr, mode = 'in'),
  degout=degree(gr, mode = 'out'),
  degall=degree(gr, mode = 'all'),
  bet=betweenness(gr),
  clo=closeness(gr),
  eig=evcent(gr)$vector,
  tra=transitivity(gr,type=c("local"))
)


#=============================

