source("src/Functions2.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]
method <- commandArgs(trailingOnly=TRUE)[4]
# infile1 = 'data/seurat_annotated.RData'
# infile2 = 'data/hpbase/raw/bulk.csv'

# Loading
load(infile1)
bulk.data <- as.matrix(read.csv(infile2, header=TRUE, row.names=1))

# Seurat => Matrix
sc.data <- as.matrix(seurat.obj@assays$RNA$counts)

# 細胞型ラベル
cluster.annotations <- seurat.obj$seurat_clusters

# バッチID（SCDEの場合のみ）
batch.ids <- rep("Batch1", ncol(sc.data))

# Deconvolution
out <- .omnideconv_methods[[method]](sc.data, bulk.data, cluster.annotations, batch.ids)

# Save
save(out, file=outfile)
