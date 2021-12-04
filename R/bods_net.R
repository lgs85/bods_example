library(jsonlite)
library(tidyverse)
library(igraph)
library(showtext)

args = commandArgs(trailingOnly=TRUE)

# Read in file
ck <- jsonlite::fromJSON(args)


ps <- filter(ck,statementType == "personStatement")
es <- filter(ck,statementType == "entityStatement")
ocs <- filter(ck,statementType == "ownershipOrControlStatement")

owners <- ifelse(is.na(ocs$interestedParty$describedByPersonStatement),
                 ocs$interestedParty$describedByEntityStatement,
                 ocs$interestedParty$describedByPersonStatement)

entities <- ocs$subject$describedByEntityStatement

g1 <- graph_from_edgelist(matrix(c(owners,entities),ncol = 2,byrow = FALSE))

v.cols <- ifelse(V(g1)$name %in% ps$statementID,"steelblue3","grey")
e.cols <- ifelse(bind_rows(ocs$interests)$beneficialOwnershipOrControl,"black","red")

V(g1)$name <- str_replace_all(V(g1)$name,"-","-\n")


pdf(file = "plots/Chaarat-Kapan-2021-02-19.pdf",width = 15,height = 18)

layout(matrix(1:2,nrow = 2),height = c(0.2,1))

plot.new()
legend("center",
	pch = c(21,21,NA,NA),
	lty = c(NA,NA,1,1),
	legend = c("Person", "Entity","Beneficial ownership","Other ownership"),
	pt.bg = c("steelblue3","grey",NA,NA),
	col = c("black","black","black","red"),
	cex = 3,
	bty = "n",
	ncol = 2
	)

plot(g1,
	vertex.color = v.cols,
	vertex.size = 30,
	vertex.label.color = 'black',
	edge.color = e.cols)


dev.off()

