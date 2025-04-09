library(ggtree)
library(ggplot2)
library(treeio)
library(phytools)

setwd("C:/Users/eidcc/OneDrive-EIDCC/BAT/R_pusillus/CoVQ/")

open_reroot <- function(infile){
  #Reroot tree at edge with phytools
  phytree <-read.tree(file=infilename)
  rootnode <- phytree$edge[which(phytree$edge[,2]==which(phytree$tip.label %in% outgroups)[1]),1]
  phytree2 <- reroot(phytree,rootnode,position=0.5*phytree$edge.length[which(phytree$edge[,2]==rootnode)])
  roottreefilename <- gsub(".treefile","rooted.nwk",infilename)
  write.tree(phytree2, roottreefilename)
  
  #open rerooted tree
  infilename <- roottreefilename
  treeio <- read.iqtree(infilename)
  return(treeio)
}

#CoVQ
#infilename <- "R_pusillus_CoVQ_positive_ref_align_13122024_renamed.phy.treefile"
infilename <- "R_pusillus_CoVQ_positive_ref_align_13122024_edited.phy.treefile"
outfilename <- gsub(".treefile",".png",infilename)

outgroups <- c("KM454473.1/Duck_CoV_GD27/Duck/China/2014",
               "JQ065048.1/HKU20-9243/Wigeon/China/2008")

treeio <- open_reroot(infilename)

RpuRB <-  treeio@phylo$tip.label[grep("RpuRB", treeio@phylo$tip.label)]

RpuRB_complete_WGS <- c("RpuRB21140.RSL/CoVQ/R.pusillus",
                        "RpuRB22384.RSL/CoVQ/R.pusillus",
                        "RpuRB21146.RSL/CoVQ/R.pusillus",
                        "RpuRB21065.RSL/CoVQ/R.pusillus",
                        "RpuRB21105.RSL/CoVQ/R.pusillus")

RpuRB_WGS <- c('RpuRB21135.RSL/CoVQ/R.pusillus',
               'RpuRB21028.RSL/CoVQ/R.pusillus',
               'RpuRB21149.RSL/CoVQ/R.pusillus',
               'RpuRB21012.RSL/CoVQ/R.pusillus',
               'RpuRB21023.RSL/CoVQ/R.pusillus',
               'RpuRB21054.RSL/CoVQ/R.pusillus',
               'RpuRB21114.RSL/CoVQ/R.pusillus',
               'RpuRB21122.RSL/CoVQ/R.pusillus')

p <- ggtree(treeio, aes(color = node)) +
  scale_color_continuous(name = "UFBoot", low='gray', high='black', limits = c(0,100)) +
  geom_tiplab(aes(label = label, subset = label %in% RpuRB), offset = 0.04, color = "black") +
  geom_tiplab(aes(label = label, subset = !(label %in% RpuRB)), color = "black") +
  geom_tippoint(aes(label = label, subset = label %in% RpuRB), position=position_nudge(x=0.03, y=0), shape = 17, size = 3, color = "black") +
  geom_tippoint(aes(label = label, subset = label %in% RpuRB_WGS), position=position_nudge(x=0.03, y=0), shape = 17, size = 3, color = 'blue') +
  geom_tippoint(aes(label = label, subset = label %in% RpuRB_complete_WGS), position=position_nudge(x=0.03, y=0), shape = 17, size = 3, color = 'red') +
  #geom_nodelab(aes(label = label, subset= as.numeric(label) > 85), nudge_x = -0.06, nudge_y = 0.5)  +
  geom_treescale(x = 0, y = -0.5) + hexpand(0.5) + 
  theme(legend.position = c(0.9,0.9))
p

ggsave(gsub(".treefile","_clade_test.png",infilename), p, width = 10, height = 13, units = 'in')


#
#p2 <- flip(flip(p,148,160),157,149)
p2 <- flip(flip(p,147,159),156,148)

p2

ggsave(outfilename, p2, width = 10, height = 13, units = 'in')

#show node
tree_node <- ggtree(treeio) + geom_nodelab(aes(label = node)) + geom_tiplab()
ggsave(gsub(".treefile","_node.png",infilename), tree_node, width = 10, height = 13, units = 'in')


#label clade
p1_clade <- p + 
  geom_cladelab(node=159, label="Sarbecovirus Group 1", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=156, label="Sarbecovirus Group 2", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=163, label="Sarbecovirus Group 3", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=166, label="Sarbecovirus Group 4", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=108, label="Decacovirus Group 1", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=116, label="Decacovirus Group 2", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=120, label="Decacovirus Group 3", offset=0.95, offset.text= 0.02) 
p1_clade
ggsave(gsub(".treefile","_clade.png",infilename), p1_clade, width = 10, height = 13, units = 'in')



#Add metadata
metadata <- read.csv("all_metadata.csv", header = TRUE, sep = ",", col.names = c("Name", "Collection_Date", "NGS")) 

t_NGS <- groupOTU(treeio, 
                  list(Complete=metadata$Name[metadata$NGS == "Complete"],
                       Partial=metadata$Name[metadata$NGS == "Partial"],
                       Not_done=metadata$Name[metadata$NGS == "Not done"]), 
                  group_name = "NGS")

ggtree(t_NGS, aes(color = node)) +
  scale_color_continuous(name = "UFBoot", low='gray', high='black', limits = c(0,100)) +
  geom_tiplab(aes(label = label), offset = 0.04) +
  geom_tippoint(aes(label = label, subset = label %in% RpuRB, shape = NGS), position=position_nudge(x=0.03, y=0), size = 3) 

t_CD <- groupOTU(t_NGS, 
                 list(Mar2021=metadata$Name[metadata$Collection_Date == "44281"],
                      Oct2021=metadata$Name[metadata$Collection_Date == "44484"],
                      Sep2022=metadata$Name[metadata$Collection_Date == "44813"]), 
                 group_name = "CollectionDate")

# install.packages("ggnewscale")          # Install ggnewscale package
library("ggnewscale")                   # Load ggnewscale

#UFBoot
p3 <- ggtree(t_CD, aes(color = node)) + 
  scale_color_continuous(name = "UFBoot", low='gray', high='black', limits = c(0,100)) + #, breaks=c(0,50,100)
  new_scale_color() + 
  geom_tiplab(aes(label = label, subset = label %in% RpuRB), offset = 0.04, color = "black", alpha = 1) +
  geom_tiplab(aes(label = label, subset = !(label %in% RpuRB)), color = "black", alpha = 1) +
  geom_tippoint(aes(label = label, subset = label %in% RpuRB, shape = NGS, color = CollectionDate), 
                position=position_nudge(x=0.03, y=0), size = 3, alpha = 1) +
  scale_colour_manual(name = "Collection month", values = c("blue","red", 'darkgreen')) +
  scale_shape_manual(values = c(17,15,19), breaks = c("Complete", "Partial", "Not_done"),labels = c("Complete", "Partial", "Not done")) +
  theme(legend.position = c(0.9,0.8), legend.text=element_text(size=10), legend.key.height = unit(0.5, 'cm')) + 
  geom_treescale(x = 0, y = -0.5) + hexpand(0.5)

p3_flip <- flip(flip(p3,147,159),156,148)
p3_flip
#UFBoot alpha scale
# p3 <- ggtree(t_CD, aes(alpha = node)) +
#   scale_alpha_continuous(name = "UFBoot", guide = 'none')+
#   geom_tiplab(aes(label = label, subset = label %in% RpuRB), offset = 0.04, color = "black", alpha = 1) +
#   geom_tiplab(aes(label = label, subset = !(label %in% RpuRB)), color = "black", alpha = 1) +
#   geom_tippoint(aes(label = label, subset = label %in% RpuRB, shape = NGS, color = CollectionDate), 
#                 position=position_nudge(x=0.03, y=0), size = 3, alpha = 1)+
#   scale_colour_manual(values = c("blue","red", 'darkgreen')) +
#   scale_shape_manual(values = c(17,15,19), breaks = c("Complete", "Partial", "Not_done"),labels = c("Complete", "Partial", "Not done")) +
#   theme(legend.position = c(0.9,0.9), legend.text=element_text(size=10)) + 
#   geom_treescale(x = 0, y = -0.5) + hexpand(0.5)


#label clade
p3_clade <- p3_flip + 
  geom_cladelab(node=159, label="Sarbecovirus Group 1", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=156, label="Sarbecovirus Group 2", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=163, label="Sarbecovirus Group 3", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=166, label="Sarbecovirus Group 4", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=108, label="Decacovirus Group 1", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=116, label="Decacovirus Group 2", offset=0.95, offset.text= 0.02) +
  geom_cladelab(node=120, label="Decacovirus Group 3", offset=0.95, offset.text= 0.02) 

p3_clade

# ggsave(gsub(".treefile","_metadata_clade.png",infilename), p3_clade, width = 10, height = 13, units = 'in')
ggsave(gsub(".treefile","_metadata_clade_color.png",infilename), p3_clade, width = 10, height = 13, units = 'in')


#Test CoVQ_filterSARS
# outgroups <- c("NC_025217/BatCovZhejiang2013/H.pratti/China/2013")
# infilename <- "R_pusillus_CoVQ_positive_ref_align_13122024_renamed2_filterSARS.phy.treefile"
# outfilename <- gsub(".treefile",".png",infilename)
# 
# #Reroot tree at edge with phytools
# phytree <-read.tree(file=infilename)
# rootnode <- which(phytree$tip.label %in% outgroups)
# phytree2 <- reroot(phytree,rootnode,position=0.5*phytree$edge.length[which(phytree$edge[,2]==rootnode)])
# roottreefilename <- gsub(".treefile","rooted.nwk",infilename)
# write.tree(phytree2, roottreefilename)
# 
# #open rerooted tree
# infilename <- roottreefilename
# treeio <- read.iqtree(infilename)
# 
# ggtree(treeio) + geom_tiplab(offset = 0.02) +
#   geom_tippoint(aes(label = label, subset = label %in% RpuRB), shape = 17, size = 3) +
#   geom_tippoint(aes(label = label, subset = label %in% RpuRB_WGS), shape = 17, size = 3, color = 'blue') +
#   geom_tippoint(aes(label = label, subset = label %in% RpuRB_complete_WGS), shape = 17, size = 3, color = 'red') +
#   geom_nodelab(aes(label = label, subset= as.numeric(label) > 85), nudge_x = -0.08, nudge_y = 0.5)  +
#   geom_treescale(x = 0, y = -0.5) + hexpand(0.6)
# 
# 
# ggsave(outfilename, width = 10, height = 12, units = 'in')