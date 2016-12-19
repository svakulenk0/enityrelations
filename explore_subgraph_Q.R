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

# calculate WI
wi <- function(graph, q){
  shortest_paths = distances(graph, v=V(graph)[q], to=V(graph), weights=NA, mode='out')
  sum_sp <- as.data.frame(colSums(shortest_paths[1:2,])+colSums(shortest_paths[2:3,])+colSums(shortest_paths[1:3,]))
  shortest_paths.T <- t(shortest_paths)
  x <- shortest_paths.T
  y <- combn(ncol(x), 2L, function(y) rowSums(x[,y]))
  sum_sp <- colSums(shortest_paths)
  results <- cbind(shortest_paths.T, Wiener=rowSums(y), sum=sum_sp)
  return(results)
}
wi <- wi(graph, q)
View(wi)
write.csv(results, file='results.csv')

x <- shortest_paths.T
ncol(x)
class(x)
dim(x)
rowSums(x[,1:2])
sum_sp <- as.data.frame(colSums(shortest_paths[,1:2]))
sapply(list(1:2, 3:4), function(y) rowSums(x[y]))
y <- combn(ncol(x), 2L)
y <- combn(ncol(x), 2L, function(y) rowSums(x[,y]))
rowSums(y)
colnames(y) <- combn(colnames(x), 2L, paste, collapse = "")
y

library(readr)
edges <- read_csv("~/Downloads/categories.csv")
# neighbors <- edges[ which(edges$V3<4),]

library(igraph)
graph <- graph.data.frame(edges)
V(graph)

library(QuACN)
library("RBGL")
g <- randomGraph(1:8, 1:5, 0.36, weights=FALSE)
wiener(g)

q = c("Viktor_Yanukovych", "Yulia_Tymoshenko", "Vladimir_Putin")
sum_sp <- sum_sp(graph, q)

g4 <- graph.data.frame(neighbors)
V(g4)

gg <- g4
sum_sp <- sum_sp(gg, q)

# compute metrics per node
graph <- gg

metrics <- data.frame(
  degin=degree(graph, mode = 'in'),
  degout=degree(graph, mode = 'out'),
  degall=degree(graph, mode = 'all'),
  bet=betweenness(graph),
  clo=closeness(graph),
  eig=evcent(graph)$vector,
  tra=transitivity(graph,type=c("local"))
)
results <- cbind(sum_sp, metrics)
write.csv(results, file='results.csv')

# smaller subgraph
q1 = c("Viktor_Yanukovych", "Yulia_Tymoshenko")
sum_sp <- sum_sp(gg, q1)
# remove unreachable nodes from the graph
reachable <- sum_sp[ which(SUM!=Inf),]
dim(reachable)
reachable_nodes <- rownames(reachable)
subv = c(reachable_nodes)
length(subv)
g2 <-induced.subgraph(graph = gg, vids=subv)
V(g2)
# calculate metrics and SUM index
#sum_sp <- sum_sp(g2, q1)
# compute metrics per node
graph <- g2
metrics <- data.frame(
  degin=degree(graph, mode = 'in'),
  degout=degree(graph, mode = 'out'),
  degall=degree(graph, mode = 'all'),
  bet=betweenness(graph),
  clo=closeness(graph),
  eig=evcent(graph)$vector,
  tra=transitivity(graph,type=c("local"))
)
results <- cbind(reachable, metrics)
write.csv(results, file='results.csv')

# P with prev category
q = c("Category:21st-century_people_by_conflict", "Category:Heads_of_government_in_Europe")
sum_sp <- sum_sp(graph, q)

# remove unreachable nodes from the graph
reachable <- sum_sp[ which(SUM!=Inf),]
dim(reachable)
reachable_nodes <- rownames(reachable)
subv = c(reachable_nodes)
length(subv)
g2 <-induced.subgraph(graph = gg, vids=subv)
V(g2)
# calculate metrics and SUM index
#sum_sp <- sum_sp(g2, q1)
# compute metrics per node
graph <- g2
metrics <- data.frame(
  degin=degree(graph, mode = 'in'),
  degout=degree(graph, mode = 'out'),
  degall=degree(graph, mode = 'all'),
  bet=betweenness(graph),
  clo=closeness(graph),
  eig=evcent(graph)$vector,
  tra=transitivity(graph,type=c("local"))
)
results <- cbind(reachable, metrics)
write.csv(results, file='results.csv')
        

plot(g2)

# r pivotal node
q = c('Category:Living_people')
wi <- t(distances(graph, v=V(graph)[q], to=V(graph), weights=NA, mode='out'))
View(wi)


# remove categories that are not living people or its supercategories (undirected graph) ?
# remove the node with the highest SUM index from the subgraph and recalculate the distances
g2 <- delete_vertices(g2, c('Category:Living_people'))
g2 <- delete_vertices(g2, c('Category:2003_Tuzla_island_conflict'))
V(g2)

sum_sp <- sum_sp(g2, q)

paths = shortest_paths(g2, from = V(g2)['Vladimir_Putin'], to = V(g2)['Category:21st-century_people_by_conflict'])
length(paths$res)

for (node in q){
  # shortest_paths Category:Politicians
  paths = shortest_paths(g2, from = V(g2)[node], to = V(g2)["Category:Wikipedia_categories_named_after_diplomatic_crises"], mode='out')
  print(paths)
}

# all paths
output <- data.frame()
for (cat in cats){
  for (node in q){
    paths = all_shortest_paths(g2, from = V(g2)[node], to = V(g2)[cat], mode='out')
    output[cat,node] <- length(paths$res)
  }
}


# construct A connector with r
#=============================
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
edges <- read_csv("~/Downloads/categories_7.csv")
graph <- graph.data.frame(edges)

q = c("Viktor_Yanukovych", "Yulia_Tymoshenko", "Vladimir_Putin")
q = c("Viktor_Yanukovych", "Yulia_Tymoshenko")
q = c("Category:Ukrainian_politicians", "Vladimir_Putin")
wiener <- sum_sp(graph, q)
wiener <- wiener[order(-wiener$SUM),]

# select closest common categories 3 6 7 8  9 10
# q2 2 3 4
limit = 6
cattable <- wiener[ which(wiener$SUM<limit),]
cats = rownames(cattable)
print(length(cats))
cat_nodes = print(V(graph)[cats])
# list of all vertices on the shortest paths
# create component for each category
#pdf(paste0("connectors/", size, cat, "_connector.pdf"),width=7,height=5)

# pdf("connectors.pdf",width=7,height=5)

output <- c()
i = 0

for (cat in cats){
  # print(cat)
  # output <- c()
  # i = 0
  # collect all shortest paths
  for (node in q){
    i = i + 1
    # path = shortest_paths(graph, from = V(graph)[node], to = V(graph)[cat], mode='out', output='vpath')
    path = all_shortest_paths(graph, from = V(graph)[node], to = V(graph)[cat], mode='out')
    #print(path$res)
    #print(unlist(path$vpath))
    output[[i]] <- unlist(path$res)
  }
  # create component for each root separately?
        # subv <- unique(unlist(output))
        # 
        # # print(V(g2)$name)
        # # print(intersect(subv, cat_nodes))
        # cats_here = unlist(V(graph)[intersect(subv, cat_nodes)]$name)
        # # print(subv)
        # # print(cats_here)
        # # Remove already visited categories from the queue
        # # cats <- setdiff(cats, cats_here)
        # 
        # # size of the subgraph
        # size = length(subv)
        # sum = wiener[cat,]$SUM
        # print(paste0(size, " x ",sum, " = ", sum * size))
        # # create subgraph
        # g2 <-induced.subgraph(graph = gg, vids=subv)
        # 
        # # print(V(g2)$name)
        # # cats_here = intersect(V(g2)$name, cats)
        # 
        # 
        # # plot subgraph
        # vcol <- rep("gray40", vcount(g2))
        # class(V(g2)[q])
        # vcol[as.vector(V(g2)[q])] <- "green"
        # vcol[as.vector(V(g2)[cats_here])] <- "red"
        # 
        # plot(g2, vertex.size=0, edge.arrow.size=0.2, vertex.label.color=vcol)
  
  # remove vertex from the graph
  
}
# dev.off()

# create a single component with all root vertices
subv <- unique(unlist(output))
# subv = subv[which(V(graph)[subv] %in% q)] <- NULL
# size of the subgraph
size = print(length(subv))
# create subgraph
g2 <-induced.subgraph(graph = gg, vids=subv)
# remove terminal nodes -> components
g2 = delete.vertices(g2, q )
# V(g2)

  # cats_here = unlist(V(graph)[cats]$name)
  # # plot subgraph
  # vcol <- rep("gray40", vcount(g2))
  # #class(V(g2)[q])
  # # vcol[as.vector(V(g2)[q])] <- "green"
  # vcol[as.vector(V(g2)[cats_here])] <- "red"
  # 
  # plot(g2, vertex.size=0, edge.arrow.size=0.2, vertex.label.color=vcol)
  # dev.off()

# find components: get clusters
g = g2
cl <- clusters(g)
# loop through to extract common vertices
clusters <- lapply(seq_along(cl$csize)[cl$csize > 1], function(x) 
  V(g)$name[cl$membership %in% x])
# TODO sort clusters by size descending
length(clusters)
clusters
# generate cluster subgraph
cluster = clusters[1]
# subv = unlist(cluster)
# add terminal nodes
subv = c(unlist(cluster),q)
g3 <-induced.subgraph(graph = graph, vids=V(graph)[subv])
V(g3)

plot(g3, vertex.size=0, edge.arrow.size=0.2, vertex.label.color=vcol)
dev.off()


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


#=============================
library(igraph)

# Syntactic data
#set.seed(2002)
#g <- erdos.renyi.game(100, 1/10) # graph
# V(g)$name <- as.character(1:100)
## Some steiner nodes:
#steiner.points <- sample(1:100, 5)
## Complete distance graph G'
#Gi <- graph.full(5)
#V(Gi)$name <- steiner.points

# My full graph
library(readr)
edges <- read_csv("~/Downloads/categories.csv")
Gi <- graph.data.frame(edges)


## Find a minimum spanning tree T' in G'
mst <- minimum.spanning.tree(Gi)

##  For each edge in mst, replace with shortest path:
edge_list <- get.edgelist(mst)

Gs <- mst
for (n in 1:nrow(edge_list)) {
  i <- edge_list[n,2]
  j <- edge_list[n,1]
  ##  If the edge of T' mst is shared by Gi, then remove the edge from T'
  ##    and replace with the shortest path between the nodes of g: 
  if (length(E(Gi)[which(V(mst)$name==i) %--% which(V(mst)$name==j)]) == 1) {
    ##  If edge is present then remove existing edge from the 
    ##    minimum spanning tree:
    Gs <- Gs - E(Gs)[which(V(mst)$name==i) %--% which(V(mst)$name==j)]
    
    ##  Next extract the sub-graph from g corresponding to the 
    ##    shortest path and union it with the mst graph:
    g_sub <- induced.subgraph(g, (get.shortest.paths(g, from=V(g)[i], to=V(g)[j])$vpath[[1]]))
    Gs <- graph.union(Gs, g_sub, byname=T)
  }
}

par(mfrow=c(1,2))
plot(mst)
plot(Gs)

#=============================

getwd()

# find related categories
gcats <-induced.subgraph(graph = gg, vids=cats)
V(gcats)
plot(gcats)

# subgraph closest categories
reachable <- sum_sp[ which(SUM<8),]
dim(reachable)
reachable_nodes <- rownames(reachable)
subv = c(reachable_nodes,q)

plot.igraph(g2)
tkplot(g2)
rglplot(g2)
# vertex.label=NA

# cluster
ceb <- cluster_edge_betweenness(g2) 
plot(ceb, g2, vertex.size=0, edge.arrow.size=0, vertex.label.color=vcol)
membership(ceb)

clp <- cluster_label_prop(g2)
plot(clp, g2)

net = g2

# looks good
V(net)$community <- ceb$membership
colrs <- adjustcolor( c("gray50", "tomato", "gold", "yellowgreen"), alpha=.6)
plot(net, vertex.color=colrs[V(net)$community], edge.arrow.size=0, vertex.label.color=vcol)

V(net)$community <- clp$membership
colrs <- adjustcolor( c("gray50", "tomato", "gold", "yellowgreen"), alpha=.6)
plot(net, vertex.color=colrs[V(net)$community], edge.arrow.size=0, vertex.label.color=vcol)

dev.off()


install.packages("sna")
library(devtools)
install_github('wjrl/RBioFabric', force=TRUE)
library(RBioFabric)

bfGraph = g2
height <- vcount(bfGraph)
width <- ecount(bfGraph)
aspect <- height / width;
plotWidth <- 100.0
plotHeight <- plotWidth * (aspect * 1.2)
pdf("myBioFabricOutput.pdf", width=plotWidth, height=plotHeight)
bioFabric(bfGraph)
dev.off()


graph.sym <- as.undirected(graph, mode= "collapse")
cliques(graph.sym)



graph <- g2

# compute similarity betw Q (on the whole but undirected graph)
shortest_paths = distances(graph, v=V(graph)[q], to=V(graph), weights=NA, mode='all')
dim(shortest_paths)
dist(shortest_paths)


graph <- g2
metrics <- data.frame(
  degin=degree(graph, mode = 'in'),
  degout=degree(graph, mode = 'out'),
  degall=degree(graph, mode = 'all'),
  bet=betweenness(graph),
  clo=closeness(graph),
  eig=evcent(graph)$vector,
  tra=transitivity(graph,type=c("local"))
)

ceb <- cluster_edge_betweenness(graph)

