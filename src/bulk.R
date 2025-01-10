source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Loading
data_xlsx <- read.xlsx(infile1, sheetIndex=1)
data_xlsx <- data_xlsx[, c("HPU_gene_id", "HPU_gene_name")]

data_bulk <- read.table(infile2, header=TRUE, row.names=1)
data_bulk <- data_bulk[, 6:7]
colnames(data_bulk) <- c("cad", "cont")
idx <- intersect(which(data_bulk$cad != 0), which(data_bulk$cont != 0))
data_bulk <- data_bulk[idx, ]
rownames_bulk <- gsub("-mRNA-.*", "", rownames(data_bulk))
data_bulk <- cbind(rownames_bulk, data_bulk)

# Preprocess（HPU_gene_id => HPU_gene_name）
merged_data <- merge(data_bulk, data_xlsx, by.x="rownames_bulk", by.y="HPU_gene_id")

outdata <- merged_data[, 3:2]
rownames(outdata) <- make.unique(merged_data$HPU_gene_name)

# Save
write.csv(outdata, file=outfile)
