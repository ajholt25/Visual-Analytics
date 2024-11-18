# https://briatte.github.io/ggnet/
# Network visualisation with ggnet2/ggplot2

# random graph Bernoulli 
net = rgraph(10, mod = "graph", tprob = 0.5)
net = network(net, directed = F)
plot(net)

# vertex names
network.vertex.names(net) = letters[1:10]

# show the graph
ggnet2(net) # net is only req'd arg of ggnet2

# change node color and size
ggnet2(net, node.size = 6, node.color = "black", edge.size = 1, edge.color = "grey")

# pass vector of node colors
ggnet2(net, node.size = 6, node.color = rep(c("tomato", "steelblue"), 5), edge.size = 1, edge.color = "grey")

# Node Placement
ggnet2(net, mode = "circle")
ggnet2(net, mode = "kamadakawai")

# can pass options to the algorithms through layout.par arg
ggnet2(net, mode = "fruchtermanreingold", layout.par = (list(cell.jitter = 0.75)))
ggnet2(net, mode = "target", layout.par = (list(niter = 100)))

# Node Colors
# assign vertex attribute to indicate if name is a vowel or consonant
net %v% "phono" = ifelse(letters[1:10] %in% c("a", "e", "i"), "vowel", "consonant")
# pass attribute to indicate if nodes belong to a group
ggnet2(net, color = "phono")

# group and give colors to each group
net %v% "color" = ifelse(net %v% "phono" == "vowel", "steelblue", "tomato")
ggnet2(net, color = "color")
# use color with an RColorBrewer palette
ggnet2(net, color = "phono", palette = "Set2")

#  Node Sizes - size nodes by their centrality or an indicator of interest
#  ggnet can take a numeric value, a vector of values, or an attribute
ggnet2(net, size = "phono")
# using a size palette to specify the sizes
ggnet2(net, size = "phono", size.palette = c("vowel"= 10, "consonant" = 1))
#when size isn't a single numeric, max size of nodes is determined by max_size arg
ggnet2(net, size = sample(0:2, 10, replace = T), max_size = 9)
# ggnet can size nodes by calc the in-degree, out-degree, or total degree with degree
# function from sna package
ggnet2(net, size = "degree")
# can also cut node sizes into quantiles, if set to TRUE, the default is quartiles
ggnet2(net, size = "degree", size.cut = 3)
# subset graph when size contains numeric values (removes nodes)
x = ggnet2(net, size = "degree", size.min = 1)
# remove all nodes
x <- ggnet2(net, size = "degree", size.max=1)
# control whether to plot zero-sized nodes. false by default
ggnet2( net, size = sample(0:2, 10, replace = T), size.zero = T)

# Node Legends
# changes node characteristic and labels legend
ggnet2(net, alpha = "phono", alpha.legend = "Phonetics")
ggnet2(net, shape = "phono", shape.legend = "Phonetics")
ggnet2(net, color = "phono", color.legend = "Phonetics")
ggnet2(net, size = "degree", size.legend = "Phonetics")

# remove legend completely
ggnet2(net, color = "phono", size = "degree") +
  guides(color = "none", size = "none")

# replace legends with ggplot2 scale.  must be discrete_scale controllers
# controle the colors of the nodes
ggnet2(net, color = "phono") +
  scale_color_brewer("", palette = "Set1",
                     labels = c("consonant" = "C", "vowel"= "V"),
                     guide = guide_legend(override.aes = list(size = 6)))

# control the size of the nodes
ggnet2(net, size = 12, label = T, label.size = 5) +
  scale_size_discrete("", range = c(5, 10), breaks = seq(10, 2, -2))

# customize legend and plot background
ggnet2(net, color = "phono", legend.size = 12, legend.position = "bottom") +
  theme(panel.background = element_rect(color = "grey"))


