library(ggtree)
library(treeio)
library(phytools)

#setwd("C:/Users/eidcc/OneDrive-EIDCC/BAT/All_thai_SarbeCoV_28June2024/phylo")
setwd("/home/tnsrk/BIF/Covid/Bat/New")

outgroups <- c("NC_014470.1|BM48-31|Bulgaria|R.blasii|2008",
               "KY352407.1|BtKY72|Kenya|Rhinolophus_sp|2007")

infilename <- "RacCS2020_27Quan_aligned.fasta.treefile"

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

RB <- c(
        "Rac_Quan_B20639.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20637.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20636.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20632.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20620.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20605.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20601.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20600.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20597.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20588.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20587.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20583.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20574.RSVL|Thailand|R.acuminatus|2020-07",
        "Rac_Quan_B20552.RSVL|Thailand|R.acuminatus|2020-07"

)

CS <- c(
        "Rac_Quan_B20290.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20278.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20272.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20271.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20267.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20264.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20253.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20230.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20228.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20224.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20213.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20209.RSL|Thailand|R.acuminatus|2020-06",
"Rac_Quan_B20203.RSL|Thailand|R.acuminatus|2020-06"
)

#Quan
ggtree(treeio) + geom_tiplab(offset = 0.01) +
  geom_tippoint(aes(label = label, subset = label %in% RB), shape = 17, size = 3, color = 'red') +
  geom_tippoint(aes(label = label, subset = label %in% CS), shape = 17, size = 3, color = 'blue') +
  geom_nodelab(aes(label = label, subset= as.numeric(label) > 85), nudge_x = -0.04, nudge_y = 0.5)  +
  geom_treescale(x = 0, y = -0.2) + hexpand(1.5)


outfilename <- gsub(".nwk",".png",infilename)

ggsave(outfilename, width = 8, height = 8, units = 'in')

