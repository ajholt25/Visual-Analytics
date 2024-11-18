# install and load packages
# 
# install.packages("GGally")
# install.packages("intergraph")
library(GGally)
library(network)
library(sna)
library(ggplot2)
library(igraph)


## Example using random bernoulli from briatte.github.io/ggnet


# random graph Bernoulli 
net = rgraph(10, mod = "graph", tprob = 0.5)
net = network(net, directed = F)

# vertex names
network.vertex.names(net) = letters[1:10]

# show the graph
ggnet2(net) # net is only req'd arg of ggnet2

# change node color and size
ggnet2(net, node.size = 6, node.color = "black", edge.size = 1, edge.color = "grey")
ggnet2(net, node.size = 6, node.color = rep(c("tomato", "steelblue"), 5), edge.size = 1, edge.color = "grey")

## Social Network Example 
## https://github.com/NormanLo4319/Social_Network_Analysis_with_R

# "The numbers in the data sets represent items/actor in the network. If we have
#  a pair of [1,3], it basically means that there is a connection between item 
#  #1 and item #3 in this network. Each row represents a connection between 2 
#  items/actors."

# setwd("~/Documents/R-Programming")

# load the undirected data into R
undirected <- read.table("undirected.txt")
head(undirected)

# create a basic graph using the undirected data
graph_ud <- graph_from_data_frame(undirected, directed = F, vertices = NULL)
plot(graph_ud)

# load the directed data set
directed <- read.table("directed.txt")
head(directed)

# basic graph with directed data
graph_d <- graph_from_data_frame(directed, directed = T)
plot(graph_d)

# preferential attachment model: uses a weighted probability distribution
# to determine with node to attach the next node to after the first two linked
# nodes

g_preferential <- sample_pa(20, power = 1)
plot(g_preferential)

## "density" or number of links from each vertex is called the vertex's degree
## and measures the connectedness of points

# check degrees of the nodes in preferential model
degree(g_preferential)

## in social networks, some people provide bridges between different groups. we
## estimate the role of these individuals by calculate the betweenness of each
## vertex.  Higher betweenness = more bridging role within the network

# example with preferential attachment model
g2 <- sample_pa( 20, power = 1, directed = F)
plot(g2) # node 3 and 10 are central

# check betweennness of network
betweenness(g2)

## Calculate network density - useful to now how dense a network is; that is
## the number of connections divided by the number of possible connections
## a completely linked network has a density of 1 while other networks will have 
## decimale value that represents the percentage of possible lins that are actually
## present in the network

# new preferential attachment model with 12 nodes
g3 <- sample_pa(12, power = 1, directed = F)
plot(g3)

# calculate the edge density, 2/number of nodes or vertices
edge <- edge_density(g3, loops = FALSE) 
edge # 2/12 = 0.1666667

# preferential network with 20 nodes
g4 <- sample_pa(20, power = 1, directed = FALSE)
plot(g4)

edge20 <- edge_density(g4, loops = FALSE)
edge20  # 2 / 20 = 0.1 edge density is going down

## Identify Cliques in a Graph
## Can identify a clique ( a group of vertices where all possible links are present)

# example with GNP model, 20 nodes and 0.3 probability
g5 <- sample_gnp(n = 20, p = 0.3, directed = F, loops = F)
plot(g5)

# Analyse the clique
# 1. Calculate the size of the largest clique (fully connect subgroup)
clique_num(g5) # return number of largest clique in network -- = 4

# display the number of cliques that are of a particular size (ex. min = 4)
# return the cliques with fully connected size of 4
cliques(g5, min = 4) #  4/ 20 vertices = 5, 11, 15, 17

# find min equals 3 and max equals 4
# # return the cliques with min 3 full connections and max 4 full connections
cliques(g5, min = 3, max = 4)


# try with gnp model (20 nodes, p = 0.6)
g6 <- sample_gnp(20, 0.6, directed = FALSE, loops = FALSE)
plot(g6) # highly interconnected network

# check clique number again
clique_num(g6) # = 5, network density has increased clique number apparently

g7 <- sample_gnp(20, 0.2, directed = T, loops = FALSE)
plot(g7) # highly interconnected network

# try using ggnet to plot the sample gnp network
ggnet2(g6, node.size = 6, node.color = "black", edge.size = 1, edge.color = "grey")
# change the colors
ggnet2(g6, node.size = 6, node.color = rep(c("tomato", "steelblue"), 10), edge.size = 1, edge.color = "grey")

# Dog park social network
# setwd("~/Documents/R-Programming/wk12")
dogs <- read.table("dogs.txt", header = T)
head(dogs)
humans <- c("Mark", "Kathy", "Joe", "John", "Amy", "Carlton", "Ken", "Riley", "Kayce", "CoopersDad", "Elvis")

# basic plot of data frame using network package
graph_dogs <- network(dogs, directed = F, vertices = NULL)

# plot with ggnet
ggnet2(graph_dogs, size = 10, label = T, label.size = 4)

# define humans and dogs

# can't match strings?
graph_dogs %v% "species" = ifelse(graph_dogs %in% c("Mark", "Kathy", "Joe", "John", "Amy", "Carlton", "Ken", "Riley", "Kayce", "CoopersDad", "Elvis"), "human", "dog") 
# pass the attribute to indicate if nodes belong to a group
ggnet2(graph_dogs, color = "species")
# group and give colors to each group
graph_dogs %v% "color" = ifelse(graph_dogs %v% "species" == "dog", "steelblue", "tomato")

# all colored as dogs
ggnet2(graph_dogs, color = "color", size = 12, label.size = 4, label = T)

# also labeled as all dogs
ggnet2(graph_dogs, color = "species", palette = "Set2", label = T, 
       size = 12, label.size = 4)

# no legend
ggnet2(graph_dogs, label = T, 
       size = 12, label.size = 4) +
  scale_color_brewer("", palette = "Set2",
                     labels = c("human" = "H", "dog"= "D"),
                     guide = guide_legend(override.aes = list(size = 6)))
  
clique_num(graph_dogs)
