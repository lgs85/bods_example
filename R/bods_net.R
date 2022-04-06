library(jsonlite)
library(tidyverse)
library(igraph)
library(showtext)

args = commandArgs(trailingOnly=TRUE)
names_lookup <- read_csv("data/name_lookup.csv")



# Read in file
ck <- jsonlite::fromJSON(args[1])


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

nams <- tibble(id = es$statementID,nam = es$name) %>%
  bind_rows(tibble(id = ps$statementID,
                   nam = ps$names %>%
                     bind_rows() %>%
                     dplyr::filter(type == "individual") %>%
                     pull(fullName)))

V(g1)$name <- tibble(id = V(g1)$name) %>%
  left_join(nams %>% 
              left_join(names_lookup %>% 
                          rename(nam = name))) %>%
  pull(newname)


pdf(file = args[2],width = 15,height = 18)

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

