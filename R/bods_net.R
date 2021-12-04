library(jsonlite)
library(tidyverse)
library(igraph)

x <- fromJSON("data/Chaarat-Kapan-2021-02-19.json")


ps <- filter(x,statementType == "personStatement")
es <- filter(x,statementType == "entityStatement")
ocs <- filter(x,statementType == "ownershipOrControlStatement")

owners <- ifelse(is.na(ocs$interestedParty$describedByPersonStatement),
                 ocs$interestedParty$describedByEntityStatement,
                 ocs$interestedParty$describedByPersonStatement)

entities <- ocs$subject$describedByEntityStatement



 g1 <- graph_from_edgelist(matrix(c(owners,entities),ncol = 2,byrow = FALSE))
 mycols <- ifelse(V(g1)$name %in% ps$statementID,"red","grey")
 
pdf("R/Chaarat-Kapan-2021-02-19.pdf")
plot(g1,vertex.color = mycols,vertex.label = NA)
dev.off()