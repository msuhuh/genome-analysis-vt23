# LOAD REQUIRED PACKAGES
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install("DESeq2", version = "3.16")
BiocManager::install("EnhancedVolcano")
install.packages("data.table")
install.packages("tidyverse")
install.packages("reshape2")

# Load necessary libraries
library(tidyverse)
library(data.table)
library(DESeq2)
library(ggplot2)
library(EnhancedVolcano)
library(reshape2)
library(dplyr)

# Set files
out_folder <-"C:/Users/minna/Documents/X4/Genomanalys/Project/08_diff_exp/"
htseq_data <-"C:/Users/minna/Documents/X4/Genomanalys/Project/07_htseq/"
culture_data <-"C:/Users/minna/Documents/X4/Genomanalys/Project/metadata/RNA_types_of_culture.txt"


# Set the working directory
setwd(normalizePath(out_folder))



## --------- ANALYSIS WITH DESEQ2
# First put all htseq files into a list 
file_list <- list.files(path = htseq_data, pattern = "\\.txt$")

# Read in the first file and set row names as gene names
dataset <- read.delim(file = paste(htseq_data,file_list[1],sep=""), sep = '\t', header = FALSE, row.names = 1)

# Add in the other files
for (i in 2:length(file_list)){
  temp_data <- fread(paste(htseq_data,file_list[i],sep=""), stringsAsFactors = F, select = c(2)) 
  dataset <- cbind(dataset, temp_data) 
}

# Set column names as file names (without the extension)
colnames = gsub(".txt","",file_list)
setnames(dataset, colnames)
# Filter out reads that do not map (select rows that correspond to features)
filtered_dataset <- subset(dataset, grepl("JKDPDCFA", row.names(dataset)))

# Load metadata and erase replicates that were not used
metadata = read.delim(file = culture_data, sep=",", header = T, row.names = 1)
metadata <- metadata[1:5,]

# Create DESeq data object
dds <- DESeqDataSetFromMatrix(
  countData = filtered_dataset,
  colData = metadata,
  design = ~ Type 
)

# Conduct DESeq analysis
dds <- DESeq(dds)
resAll <- results(dds)
res <- results(dds, contrast = c("Type","Chemostat","Mineral"))
resOrder <- res[order(res$pvalue),]

plotMA(res)


## RESULTS PLOTS
# Transform count data using the variance stablilizing transform
ddsvst <- vst(dds)

#PCA plot
pos_vec <- c(2, 2, -2, -2, 2)
pca <- plotPCA(ddsvst, intgroup="Type") +
  geom_text(aes(label=colnames), nudge_x = pos_vec) +
  labs(color = "Culture type")

pca

write.csv( as.data.frame(res), file="DESeq_results.csv" )

# Volcano plot
EnhancedVolcano(res,
                lab = rownames(res),
                x = 'log2FoldChange',
                y = 'padj',
                pCutoff = 0.01)









