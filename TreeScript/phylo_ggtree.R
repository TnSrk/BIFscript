library(ggtree)
library(treeio)
library(phytools)

setwd("C:/Users/eidcc/OneDrive-EIDCC/BAT/All_thai_SarbeCoV_28June2024/phylo")

outgroups <- c("NC_014470.1|BM48-31|Bulgaria|R.blasii|2008",
               "KY352407.1|BtKY72|Kenya|Rhinolophus_sp|2007")

infilename <- "Rhinolophus_Sarbe_genomes_mafft_2_spike_codon.translated_nostop.fas.treefile"

infilename <- "Rhinolophus_Sarbe_genomes_mafft_2.fasta.treefile"

infilename <- "Rhinolophus_Sarbe_genomes_mafft_2_RBD.translated.fas.treefile"

infilename <- "PB_2020_RBD_aligned.translated.fas_edited.treefile"

infilename <- "PB_2020_Quan_aligned.fasta_edited.treefile"
infilename <- "PB_2020_Quan_aligned.fasta_edited2.treefile"

infilename <- "PB_2020_RBD_aligned.fasta.treefile"

infilename <- "PB_2020_RBD_aligned2.fasta3.treefile"

#Reroot tree at edge with phytools
phytree <-read.tree(file=infilename)
# plotTree(phytree)
# # tiplabels()
# nodelabels()
rootnode <- phytree$edge[which(phytree$edge[,2]==which(phytree$tip.label %in% outgroups)[1]),1]
phytree2 <- reroot(phytree,rootnode,position=0.5*phytree$edge.length[which(phytree$edge[,2]==rootnode)])
# plotTree(phytree2)
roottreefilename <- gsub(".treefile","rooted.nwk",infilename)
write.tree(phytree2, roottreefilename)

#read rooted tree
infilename <- roottreefilename

treeio <- read.iqtree(infilename)

to_color <- c("MW251308.1|RacCS203|Thailand|R.acuminatus|2020",
              "Unpublished|THAB20637.RSL|Thailand|R.acuminatus|2020",
              "Unpublished|THAB21065.RSL|Thailand|R.pusillus|2021",
              "Unpublished|THAB21105.RSL|Thailand|R.pusillus|2021",
              "Unpublished|THAB21140.RSL|Thailand|R.pusillus|2021",
              "Unpublished|THAB21146.RSL|Thailand|R.pusillus|2021",
              "Unpublished|THAB22384.RSL|Thailand|R.pusillus|2022",
              "Unpublished|THAB20340.RSL|Thailand|R.coelophyllus|2020")

# #spike
# ggtree(treeio) + geom_tiplab(offset = 0.3) +
#   geom_tippoint(aes(label = label, subset = label %in% to_color), shape = 17, size = 3, color = 'red') +
#   geom_nodelab(aes(label = label, subset= as.numeric(label) > 85), nudge_x = -0.8, nudge_y = 0.5)  +
#   geom_treescale(x = -0.15, y = 0) + hexpand(1)
# 
# #genome
# ggtree(treeio) + geom_tiplab(offset = 0.02) +
#   geom_tippoint(aes(label = label, subset = label %in% to_color), shape = 17, size = 3, color = 'red') +
#   geom_nodelab(aes(label = label, subset= as.numeric(label) > 85), nudge_x = -0.05, nudge_y = 0.4)  +
#   geom_treescale(x = 0, y = 0) + hexpand(0.6)
# 
# #RBD
# ggtree(treeio) + geom_tiplab(offset = 0.8) +
#   geom_tippoint(aes(label = label, subset = label %in% to_color), shape = 17, size = 3, color = 'red') +
#   geom_nodelab(aes(label = label, subset= as.numeric(label) > 85), nudge_x = -1.5, nudge_y = 0.5)  +
#   geom_treescale(x = 0, y = 0) + hexpand(1.4)


RB <- c("Unpublished|THAB21065.RSL|Thailand|R.pusillus|2021",
        "Unpublished|THAB21105.RSL|Thailand|R.pusillus|2021",
        "Unpublished|THAB21140.RSL|Thailand|R.pusillus|2021",
        "Unpublished|THAB21146.RSL|Thailand|R.pusillus|2021",
        "Unpublished|THAB22384.RSL|Thailand|R.pusillus|2022")

CS <- c("MW251308.1|RacCS203|Thailand|R.acuminatus|2020",
        "Unpublished|THAB20637.RSL|Thailand|R.acuminatus|2020")

PB <- c("Unpublished|THAB20340.RSL|Thailand|R.coelophyllus|2020")

CS_RBD <- c("B20587.RSL|RBD|Rac|2020-07",
            "B20574.RSL|RBD|Rac|2020-07",                               
            "B20583.RSL|RBD|Rac|2020-07",                           
            "B20636.RSL|RBD|Rac|2020-07",                               
            "B20552.RSL|RBD|Rac|2020-07",                               
            "B20601.RSL|RBD|Rac|2020-07",                               
            "B20620.RSL|RBD|Rac|2020-07",                               
            "B20597.RSL|RBD|Rac|2020-07",
            "B20639.RSL|RBD|Rac|2020-07",
            "B20600.RSL|RBD|Rac|2020-07",
            "B20632.RSL|RBD|Rac|2020-07" )

#color by site
#spike aa
ggtree(treeio) + geom_tiplab(offset = 0.02) +
  geom_tippoint(aes(label = label, subset = label %in% RB), shape = 17, size = 3, color = 'red') +
  geom_tippoint(aes(label = label, subset = label %in% CS), shape = 17, size = 3, color = 'blue') +
  geom_tippoint(aes(label = label, subset = label %in% PB), shape = 17, size = 3, color = 'darkgreen') +
  geom_nodelab(aes(label = label, subset= as.numeric(label) > 85), nudge_x = -0.04, nudge_y = 0.5)  +
  geom_treescale(x = 0, y = -0.1) + hexpand(1)

#genome
ggtree(treeio) + geom_tiplab(offset = 0.02) +
  geom_tippoint(aes(label = label, subset = label %in% RB), shape = 17, size = 3, color = 'red') +
  geom_tippoint(aes(label = label, subset = label %in% CS), shape = 17, size = 3, color = 'blue') +
  geom_tippoint(aes(label = label, subset = label %in% PB), shape = 17, size = 3, color = 'darkgreen') +
  geom_nodelab(aes(label = label, subset= as.numeric(label) > 85), nudge_x = -0.05, nudge_y = 0.4)  +
  geom_treescale(x = 0, y = 0) + hexpand(0.6)

#RBD aa
ggtree(treeio) + geom_tiplab(offset = 0.03) +
  geom_tippoint(aes(label = label, subset = label %in% RB), shape = 17, size = 3, color = 'red') +
  geom_tippoint(aes(label = label, subset = label %in% CS), shape = 17, size = 3, color = 'blue') +
  geom_tippoint(aes(label = label, subset = label %in% PB), shape = 17, size = 3, color = 'darkgreen') +
  geom_nodelab(aes(label = label, subset= as.numeric(label) > 85), nudge_x = -0.04, nudge_y = 0.5)  +
  geom_treescale(x = 0, y = -0.1) + hexpand(1.5)

ggtree(treeio) + geom_tiplab(offset = 0.03) +
  geom_tippoint(aes(label = label, subset = label %in% RB), shape = 17, size = 3, color = 'red') +
  geom_tippoint(aes(label = label, subset = label %in% CS), shape = 17, size = 3, color = 'blue') +
  geom_tippoint(aes(label = label, subset = label %in% PB), shape = 17, size = 3, color = 'darkgreen') +
  geom_tippoint(aes(label = label, subset = label %in% CS_RBD), shape = 15, size = 3, color = 'blue') +
  geom_nodelab(aes(label = label, subset= as.numeric(label) > 0), nudge_x = -0.04, nudge_y = 0.5)  +
  geom_treescale(x = 0, y = -0.1) + hexpand(1.5)

#Quan
ggtree(treeio) + geom_tiplab(offset = 0.01) +
  geom_tippoint(aes(label = label, subset = label %in% RB), shape = 17, size = 3, color = 'red') +
  geom_tippoint(aes(label = label, subset = label %in% CS), shape = 17, size = 3, color = 'blue') +
  geom_tippoint(aes(label = label, subset = label %in% PB), shape = 17, size = 3, color = 'darkgreen') +
  geom_nodelab(aes(label = label, subset= as.numeric(label) > 85), nudge_x = -0.04, nudge_y = 0.5)  +
  geom_treescale(x = 0, y = -0.2) + hexpand(1.5)


outfilename <- gsub(".nwk",".png",infilename)
outfilename <- gsub(".nwk","2_site.png",infilename)

ggsave(outfilename, width = 8, height = 8, units = 'in')

