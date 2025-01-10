library("omnideconv")
library("Seurat")
library("htmlwidgets")

# DWLS
.dwls <- function(sc.data, bulk.data, cell.type.annotations, batch.ids){
    cat("### 1/2 ###\n")
    signature.matrix.dwls <- build_model(
        single_cell_object = sc.data,
        cell_type_annotations = cell.type.annotations,
        method = 'dwls',
        dwls_method = 'mast_optimized')

    cat("### 2/2 ###\n")
    deconvolute(
        bulk_gene_expression = bulk.data,
        signature = signature.matrix.dwls,
        method = 'dwls',
        dwls_submethod = 'DampenedWLS')
}
 
# BayesPrism（1ステップ）
.bayesprism <- function(sc.data, bulk.data, cell.type.annotations, batch.ids){
    cat("### 1/1 ###\n")
    deconvolute(
        bulk_gene_expression = bulk.data,
        single_cell_object = sc.data,
        cell_type_annotations = cell.type.annotations,
        signature = NULL,
        method = 'bayesprism',
        n_cores=1)
}

# MOMF
.momf <- function(sc.data, bulk.data, cell.type.annotations, batch.ids){
    cat("### 1/2 ###\n")
    signature.matrix.momf <- build_model(
        single_cell_object = sc.data,
        cell_type_annotations = cell.type.annotations,
        bulk_gene_expression = bulk.data,
        method = 'momf')

    cat("### 2/2 ###\n")
    deconvolute(
        single_cell_object = sc.data,
        bulk_gene_expression = bulk.data,
        signature = signature.matrix.momf,
        method = 'momf')
}

# SCDC（1ステップ、Batch idsが必要）
.scdc <- function(sc.data, bulk.data, cell.type.annotations, batch.ids){
    cat("### 1/1 ###\n")
    deconvolute(
        batch_ids = batch.ids,
        bulk_gene_expression = bulk.data,
        single_cell_object = sc.data,
        cell_type_annotations = cell.type.annotations,
        signature = NULL,
        method = 'scdc')
}

# Omnideconv Methods
.omnideconv_methods <- list(
    dwls=.dwls,
    bayesprism=.bayesprism,
    momf=.momf,
    scdc=.scdc)
