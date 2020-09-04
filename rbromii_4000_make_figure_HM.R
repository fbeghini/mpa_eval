library(tidyverse)
library(vegan)
library(ggplot2)
library(viridis)
library(cluster)
library("fpc")
library(devtools)
if(!require("ComplexHeatmap")){
    install_github("jokergoo/ComplexHeatmap") 
}
library(ComplexHeatmap)

rm(list = ls())
setwd('/shares/CIBIO-Storage/CM/news/users/leonard.dubois/rbromii4000_panphlan')
dt <- read.csv(file = "rbromii_profile_all.tsv",
               sep = "\t", row.names = 1, check.names = FALSE,
               stringsAsFactors = F, header = T)

# dt <- read.csv(file = "/shares/CIBIO-Storage/CM/news/users/francesco.beghini/chocophlan_paper/NR50_bromii", 
               # sep = "\t", row.names = 1, check.names = FALSE,
               # stringsAsFactors = F, header = T)

#dt_annot <- dt[ ,"annotation"]
#names(dt_annot) <- rownames(dt)
# dt <- dt[ ,-1]
dt <- t(as.matrix(dt))
#dt <- dt[!grepl("REF", x = rownames(dt)), ]
rownames(dt) <- str_remove(rownames(dt), pattern = "_map.tsv.bz2")
dt <- dt[, colSums(dt) != 0]

metadata <- read.table(file = "metadata_eu.csv", header = T, stringsAsFactors = F)
metadata$sampleID <- sapply(metadata$sampleID, function(x){a = str_split(x, '__'); return(a[[1]][2]) })

# ------------------------------------------------------------------------------
# HEATMAP

dt_hm <- t(dt)
# filter ? adapt to the size of matrix and table of rowSums : So far do manually
ggplot(data = as.data.frame( rowSums(dt_hm)), aes(x=rowSums(dt_hm))) +
    geom_density(fill="lightblue", color="black", alpha=0.8) + 
    theme_bw() 

# a_pc <- round(ncol(a) *0.01)
# a = dt_hm[rowSums(dt_hm) > a_pc, ] 
# a = a[rowSums(a) < ncol(a) - a_pc, ] 
a = dt_hm[rowSums(dt_hm) > 2, ] 
a = a[rowSums(a) < 2682, ] 

# -------------Annotation 1 / 3 ----------- Countries color code
countries_colors <- c('#787878', '#ECDB54','#E34132','#6CA0DC','#944743','#DBB2D1','#EC9787', '#bc6ca7', '#00A68C',
                      '#645394','#FFFFFF', '#6C4F3D','#EBE1DF','#000000','#BFD833')
names(countries_colors) <- c('BGD', "CAN",'CHN','EUR','FJI','ISR','KAZ', 'MDG', 'MNG',
                             'PER','REF', 'RUS','TZA','UNK','USA')
id_to_country <- function(id){
    country <- metadata[which(metadata$sampleID == id), "subjectID"][1]
    if(is.na(country))
        return("REF")
    return(country)
}


# -------------Annotation 2 / 3 -----------  Get StrainPhlAn subtree
read_tree <- function(file, name){
    tree <- read_file(file) %>% str_split(pattern = ",") %>% unlist()
    samples_names <- str_split(tree, pattern = "__") %>% 
        lapply(function(x){x[2]}) %>%
        unlist() %>% 
        str_split(pattern = ":") %>% 
        lapply(function(x){x[1]}) %>%
        unlist() 
    assign(x = name, value = samples_names[samples_names %in% colnames(a)], envir = globalenv())
}

read_tree(file = "cluster1.tree", name = "Cluster2")
read_tree(file = "cluster2.tree", name = "Cluster1")


subgroups = case_when(colnames(a) %in% Cluster1 ~ "Cluster1",
                      colnames(a) %in% Cluster2 ~ "Cluster2")
names(subgroups) <- colnames(a)
subgroups[which(is.na(subgroups))] <- "other"
color_subgroups <- c('#e34132','#6ca0dc','#ecbd54')
names(color_subgroups) <- unique(subgroups)

# -------------Annotation 3 / 3 -----------  Westernized or not label
lifestyle_lbl <- rep(NA, times = ncol(a))
names(lifestyle_lbl) <- colnames(a)
lifestyle_lbl <- sapply(colnames(a), function(x){
    lf <- metadata[which(metadata$sampleID == x), "westernised"][1]
    if(is.na(lf))
        return("W")
    return(lf) })
lifestyle_colors = c('#3b5a7d', '#ecdb54')
names(lifestyle_colors) = c("W", "NW")



# ---------------------------- Plot Heatmap -------------------------------

ha = HeatmapAnnotation(country = sapply(colnames(a), id_to_country),
                       StrainPhlAn_subtree = subgroups,
                       Lifestyle = lifestyle_lbl,
                       col = list(country = countries_colors,
                                  StrainPhlAn_subtree = color_subgroups,
                                  Lifestyle= lifestyle_colors),
                       simple_anno_size = unit(0.3, "in"))
h3 <- Heatmap(a,  c("grey", "red"),
              heatmap_legend_param = list(
                  title = "Gene", labels = c("absent", "present")),
              cluster_rows = TRUE,
              cluster_columns = TRUE,
              clustering_method_columns = "ward.D2",
              clustering_method_rows = "ward.D2",
              #show_row_dend = FALSE,
              #show_column_dend = FALSE,
              show_row_names = FALSE,
              show_column_names = TRUE,
              row_split = 13,
              column_dend_height = unit(4, "cm"),
              column_names_gp = gpar(fontsize = 1),
              column_title = "Metagenomic samples",
              row_title = "UniRef90 genes families",
              top_annotation = ha
)
# filter core genes but keep same cluster
dend_row_h3 <- row_dend(h3)
dend_col_h3 <- column_dend(h3)
core_lbl <- labels(dend_row_h3[[1]])
a2 <- a[!rownames(a) %in% core_lbl, ]

a3 <- a2[rowSums(a2) > round(ncol(a2) * 0.05), ]

GH_anont_idx <- match(c("UniRef90_A0A2N0UIY3","UniRef90_A0A2N0UZH8","UniRef90_A0A2N0URN7","UniRef90_A0A373KUD0","UniRef90_A0A373KWA7","UniRef90_A0A3D3D8D4","UniRef90_A0A373Y311","UniRef90_A0A2N0UKV7","UniRef90_R5DUF7","UniRef90_A0A2N0UWE9","UniRef90_A0A373XIC5","UniRef90_R5DUE9","UniRef90_R5E4U9","UniRef90_A0A292S005","UniRef90_A0A374DER7"),rownames(a3))
GH_annot <- c("GT4(195-318)","GH3(121-347)","GT4(195-341)","GT2_Glycos_transf_2(8-157)","GT0","GT4(227-374)","GT2_Glycos_transf_2(82-205)","GT2_Glycos_transf_2(5-106)","GT4(187-338)","GH23","GH13(66-327)+CBM26(803-866)","GT2_Glycos_transf_2(6-136)","GT4(186-296)","GT2_Glycos_transf_2(8-136)","GT2_Glycos_transf_2(7-127)")

GHrA = rowAnnotation(GH = anno_mark(at = GH_anont_idx, labels = GH_annot))

h4 <- Heatmap(a3,  c("grey", "red"),
              heatmap_legend_param = list(
                  title = "Gene", labels = c("absent", "present")),
              cluster_rows = TRUE,
              cluster_columns = dend_col_h3,
              clustering_method_columns = "ward.D2",
              clustering_method_rows = "ward.D2",
              show_row_dend = FALSE,
              show_column_dend = FALSE,
              row_split = 13,
              show_row_names = FALSE,
              show_column_names = FALSE,
              column_dend_height = unit(4, "cm"),
              column_names_gp = gpar(fontsize = 1),
              column_title = "Metagenomic samples",
              row_title = "UniRef90 genes families",
              top_annotation = ha,
              right_annotation = GHrA
)

HM<-h4
r.dend <- dend_row_h3
rcl.list <- row_order(HM)
mat <- a3
lapply(ccl.list, function(x) length(x))

for (i in 1:length(ccl.list)){
    if (i == 1) {
        clu <- t(t(row.names(mat[rcl.list[[i]],])))
        out <- cbind(clu, paste("cluster", i, sep=""))
        colnames(out) <- c("GeneID", "Cluster")
        } else {
            clu <- t(t(row.names(mat[rcl.list[[i]],])))
            clu <- cbind(clu, paste("cluster", i, sep=""))
            out <- rbind(out, clu)
            }
    }


dend_row_h4 <- row_dend(h4)

c.dend <- dend_col_h3
ccl.list <- column_order(HM)


for (i in 1:length(row_order(HM))){
    if (i == 1) {
        clu <- t(t(row.names(mat[row_order(HM)[[i]],])))
        out <- cbind(clu, paste("cluster", i, sep=""))
        colnames(out) <- c("GeneID", "Cluster")
    } else {
        clu <- t(t(row.names(mat[row_order(HM)[[i]],])))
        clu <- cbind(clu, paste("cluster", i, sep=""))
        out <- rbind(out, clu)
    }
}
# ================ FINAL PLOT ============================================



# svg("/shares/CIBIO-Storage/CM/news/users/francesco.beghini/chocophlan_paper/mpa3_paper_fig4b_rbromii_2_2682_ward2_both.svg", width = 32, height = 14)

svg("/shares/CIBIO-Storage/CM/news/users/francesco.beghini/chocophlan_paper/mpa3_paper_fig4b_rbromii_2_2682_ward2_NR90.svg", width = 32, height = 14)
# svglite::svglite("/shares/CIBIO-Storage/CM/news/users/francesco.beghini/chocophlan_paper/mpa3_paper_fig4b_rbromii_2_2682_ward2_both.svg", width = 32, height = 14)

h4

dev.off()
