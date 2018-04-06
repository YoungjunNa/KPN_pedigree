library(dplyr)

kpn <- readxl::read_excel("kpn_family.xlsx")
str(kpn)
kpn <- filter(kpn, is.na(kpnno)==FALSE)
kpn$kpnno <- paste0("KPN",kpn$kpnno)

# data ####

kpn1 <- kpn[,1:3]
kpn2 <- kpn[,c(2,4,5)]
kpn3 <- kpn[,c(3,6,7)]
kpn4 <- data.frame(kpnno=kpn[,4],fathername=NA, mothername=NA)
kpn5 <- data.frame(kpnno=kpn[,5],fathername=NA, mothername=NA)
kpn6 <- data.frame(kpnno=kpn[,6],fathername=NA, mothername=NA)
kpn7 <- data.frame(kpnno=kpn[,7],fathername=NA, mothername=NA)

colnames(kpn1) <- c("kpnno","fathername","mothername")
colnames(kpn2) <- c("kpnno","fathername","mothername")
colnames(kpn3) <- c("kpnno","fathername","mothername")
colnames(kpn4) <- c("kpnno","fathername","mothername")
colnames(kpn5) <- c("kpnno","fathername","mothername")
colnames(kpn6) <- c("kpnno","fathername","mothername")
colnames(kpn7) <- c("kpnno","fathername","mothername")

kpn1$sex <- 1
kpn2$sex <- 1
kpn3$sex <- 2
kpn4$sex <- 1
kpn5$sex <- 2
kpn6$sex <- 1
kpn7$sex <- 2

kpn_sum <- rbind(kpn2,kpn3,kpn1,kpn4,kpn5,kpn6,kpn7)
# is.na(kpn_sum$kpnno) %>% table()
kpn_final <- kpn_sum[!duplicated(kpn_sum$kpnno),]


# pedigree ####
# library(kinship2)
# 
# pedigree <- pedigree(id=kpn_final$kpnno,momid=kpn_final$mothername,dadid=kpn_final$fathername,sex=kpn_final$sex)
# 
# plot(pedigree)


# networkD3 ####
pacman::p_load("igraph","networkD3")

nt <- kpn_final %>% filter(sex==1)
nt <- nt[,1:2]
nt <- nt %>% filter(is.na(fathername)==FALSE)

colnames(nt) <- c("R0","R1")

pre <- nt %>%
  count(R0, R1) %>%
  graph_from_data_frame %>%
  igraph_to_networkD3

pre$nodes$group <- ifelse(pre$nodes$name %in% nt$R0, "sons","founders")

networkD3::forceNetwork(Links = pre$links, Nodes = pre$nodes,
                        colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10);"),
                        Source = "source", Target = "target",
                        Value = "value", NodeID = "name",
                        Group = "group", opacity = 0.9, zoom = T,
                        fontSize = 20, fontFamily = "serif", legend = T,
                        opacityNoHover = 0.1)
