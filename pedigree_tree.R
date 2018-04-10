# library & data ####
pacman::p_load("igraph","networkD3","dplyr")

kpn <- readxl::read_excel("kpn_family.xlsx") %>% 
  filter(is.na(kpnno)==FALSE)

kpn$kpnno <- paste0("KPN",kpn$kpnno)

# data ####
kpn1 <- kpn[,1:2]
kpn2 <- kpn[,c(1,3)]
kpn3 <- kpn[,c(2,4)]
kpn4 <- kpn[,c(3,6)]

colnames(kpn1) <- c("kpnno","fathername")
colnames(kpn2) <- c("kpnno","fathername")
colnames(kpn3) <- c("kpnno","fathername")
colnames(kpn4) <- c("kpnno","fathername")


kpn_sum <- rbind(kpn1,kpn2,kpn3,kpn4)
kpn_final <- kpn_sum


kpn_final$fathername %in% kpn_final$kpnno ==TRUE
kpn_final <- filter(kpn_final, kpn_final$fathername %in% kpn_final$kpnno ==TRUE)

# networkD3 ####
nt <- kpn_final
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
