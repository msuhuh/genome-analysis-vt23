# LOAD REQUIRED PACKAGES
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install("DESeq2", version = "3.16")

# Load libraries
library(data.table)
library(DESeq2)
library(ggplot2)
library(EnhancedVolcano)
library(reshape2)
library(dplyr)

# File paths for easier access
path08 <-"~/C:/Users/minna/Documents/X4/Genomanalys/Project/08/"
path07 <-"~/C:/Users/minna/Documents/X4/Genomanalys/Project/07/"
pathdata <-"~/C:/Users/minna/Documents/X4/Genomanalys/Project/metadata/"

path10 <- "/C:/Users/minna/Documents/X4/Genomanalys/Project/names/"

setwd(path08)

##ANALYSIS WITH DESEQ2
# First put all file names into a list 
file_list <- list.files(path = path07,pattern = ".txt")

# Read in the first file and set row names as gene names
dataset <- read.delim(file = paste(path07,file_list[1],sep=""), sep = '\t', header = FALSE, row.names = 1)

# Add in the other files
for (i in 2:length(file_list)){
  temp_data <- fread(paste(path07,file_list[i],sep=""), stringsAsFactors = F, select = c(2)) 
  dataset <- cbind(dataset, temp_data) 
}

# Set column names as file names (without the extension)
colnames <- gsub(".txt","",file_list)
setnames(dataset, colnames)
# Filter out reads that do not map (select rows that correspond to features)
filtered_dataset <- subset(dataset, grepl("LFT", row.names(dataset)))

# load metadata and erase replicates we did not use
metadata <- read.delim(file = pathdata, sep=",", header = T, row.names = 1)
metadata <- metadata[1:5,]

# Create DESeq data object
dds <- DESeqDataSetFromMatrix(
  countData <- filtered_dataset,
  colData <- metadata,
  design <- ~ Type 
)

# Conduct DESeq analysis
dds <- DESeq(dds)
resAll <- results(dds)
res <- results(dds, contrast = c("Type","Chemostat","Mineral"))
resOrder <- res[order(res$pvalue),]

plotMA(res)
# MA plot looks fine (the scatter from the center line is pretty symmetric)

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

# Heatmap

resdf <- as.data.frame(res)

# Convert the DESeq transformed object to a data frame
ddsvst <- assay(ddsvst)
ddsvst <- as.data.frame(ddsvst)
ddsvst$Gene <- rownames(ddsvst)

# Keep only the significantly differentiated genes where the fold-change was at least 3
sigGenes <- rownames(resdf[resdf$padj <= .001 & abs(resdf$log2FoldChange) > 3,])
ddsvst <- ddsvst[ddsvst$Gene %in% sigGenes,]

# Convert the VST counts to long format for ggplot2
ddsvst <- melt(ddsvst, id.vars=c("Gene"))
check_genes <- distinct(select(ddsvst, Gene))

# Change gene locus to name
names <- read.delim(file = path10, sep = ',', header = TRUE, row.names = 1, stringsAsFactors = FALSE)
colnames(names) <- c("Gene","Name")
ddsvst <- left_join(ddsvst, names, by="Gene")
ddsvst$Name[is.na(ddsvst$Name)] <- as.character(ddsvst$Gene[is.na(ddsvst$Name)])
ddsvst <- select(ddsvst, Name, variable, value)

# Make a heatmap
library(viridis)
heatmap <- ggplot(ddsvst, aes(x=variable, y=Name, fill=value)) + geom_raster() + scale_fill_viridis(trans="sqrt") + theme(axis.text.x=element_text(angle=65, hjust=1)) + xlab("Sample") + labs(fill = "Expression")
heatmap

# Conduct differential expression analysis by functional type
classification <- read.delim(file = "classification.csv", sep = ",", header = TRUE, row.names = 2)
classification <- select(classification, category)

class_df <- merge(classification, resdf, by="row.names")

class_df$p.value <- ifelse(class_df$padj <= 0.01, "<0.01", ">0.01")
class_df$p.value[is.na(class_df$p.value)] <- ">0.01"

## Plotting
p <- ggplot(class_df, aes(x = category, y = log2FoldChange)) +
  geom_jitter(aes(color=p.value, shape=p.value, alpha = p.value), width = 0.2, height = 0, size = 2) +
  scale_x_discrete(limits=c("ATP synthase", "Carbon fixation via CBB cycle", "Carbon fixation via rTCA cycle", "c−di−GMP", "Chemotaxis", 
                            "Cytochromes","Metal resistance", "Motility", "NADH dehydrogenase", "Nitrogen fixation", 
                            "Oxidative stress response", "pH homeostasis","Polysaccharides", "Other")) +
  scale_alpha_manual(values=c(1,0.5)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  geom_hline(yintercept=0) +
  ylim(-5,7.5) +
  xlab("Generalized functional categories")


# Which functions do the genes in the heatmap have?
setDT(classification, keep.rownames = "Gene")
hmfunc <- left_join(check_genes, classification)
hmfunc <- left_join(hmfunc, names)
write.csv(hmfunc, file="heatmap_func.csv" )