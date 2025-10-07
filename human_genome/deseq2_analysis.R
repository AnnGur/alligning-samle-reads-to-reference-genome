# deactivate conda
## Check working directory
# getwd() # Check working directory
# if (!requireNamespace("BiocManager", quietly = TRUE))
#          install.packages("BiocManager")
# BiocManager::install("DESeq2")
# BiocManager::install("ggplot2")
# source("resources/human/deseq2_analysis.R")

# Load libraries
library(DESeq2)
library(ggplot2)

# Validate matrix
# Extract count data (skip first 6 columns: Geneid, Chr, Start, End, Strand, Length)
count_data <- counts_matrix[, 7:ncol(counts)]

# Setup conditions (adjust to match your sample columns)
condition <- factor(c("treated", "control")) 

# Define DESeq dataset
colData <- data.frame(row.names=colnames(count_data), condition)

mm <- model.matrix(~ condition, data = colData)
n_samples <- nrow(mm)
n_params  <- ncol(mm)
rank_mm   <- qr(mm)$rank
cat("samples:", n_samples, " params:", n_params, " rank:", rank_mm, "\n")

## RESULTS:
# As samples: 2  params: 2  rank: 2 , there's no data for dispersion estimation.
# You need at least one more sample than parameters to estimate dispersion.


# For valid dispersion estimation:
# dds <- DESeqDataSetFromMatrix(countData = count_data, colData = colData, design = ~ condition)

# # Run DESeq2 Differential Expression
# dds <- DESeq(dds)
# res <- results(dds)

# # Sort results by adjusted p-value
# res <- res[order(res$padj),]

# # Save results
# write.csv(as.data.frame(res), file="resources/human/deseq2_results.csv")

# # Volcano plot
# res_df <- as.data.frame(res)
# res_df$threshold <- as.factor(res_df$padj < 0.05 & abs(res_df$log2FoldChange) > 1)

# p <- ggplot(res_df, aes(x=log2FoldChange, y=-log10(pvalue), color=threshold)) +
#     geom_point(alpha=0.8, size=1.75) +
#     theme_bw() +
#     xlab("Log2 Fold Change") + ylab("-log10 p-value") +
#     ggtitle("Volcano Plot") +
#     scale_color_manual(values = c("gray", "red")) +
#     theme(legend.position="none")

# ggsave("resources/human/29_GRCh38_volcano_plot.png", plot=p, width=8, height=6)