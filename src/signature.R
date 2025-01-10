# library("Seurat")

# # Loading
# load("data/seurat_annotated.RData")

# # Preprocess
# celltype <- seurat.integrated@meta.data$celltype
# hvg_genes <- VariableFeatures(seurat.integrated)
# matdata <- as.matrix(seurat.integrated@assays$RNA@counts)
# matdata <- matdata[hvg_genes, ]

# # Subsampling


# # Save
# save(seurat.integrated, file='data/seurat_annotated_subsampled.RData')
