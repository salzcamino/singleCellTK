
# dir <- "genecount"
.constructSCEFromBUStoolsOutputs <- function(dir,
    sample,
    matrixFileName,
    featuresFileName,
    barcodesFileName,
    gzipped,
    class) {

    cb <- .readBarcodes(file.path(dir, barcodesFileName))
    fe <- .readFeatures(file.path(dir, featuresFileName))
    ma <- .readMatrixMM(file.path(dir, matrixFileName),
        gzipped = gzipped,
        class = class)
    ma <- t(ma)

    coln <- paste(sample, cb[[1]], sep = "_")
    rownames(ma) <- fe[[1]]

    sce <- SingleCellExperiment::SingleCellExperiment(
        assays = list(counts = ma))
    SummarizedExperiment::rowData(sce) <- fe
    SummarizedExperiment::colData(sce) <- S4Vectors::DataFrame(cb,
        column_name = coln,
        sample = sample,
        row.names = coln)

    return(sce)
}


# main function
.importBUStools <- function(
    BUStoolsDirs,
    samples,
    matrixFileName,
    featuresFileName,
    barcodesFileName,
    gzipped,
    class) {

    if (length(BUStoolsDirs) != length(samples)) {
        stop("'BUStoolsDirs' and 'samples' have unequal lengths!")
    }

    res <- vector("list", length = length(samples))

    for (i in seq_along(samples)) {
        dir <- file.path(BUStoolsDirs[i])
        scei <- .constructSCEFromBUStoolsOutputs(dir,
            sample = samples[i],
            matrixFileName = matrixFileName,
            featuresFileName = featuresFileName,
            barcodesFileName = barcodesFileName,
            gzipped = gzipped,
            class = class)
        res[[i]] <- scei
    }

    sce <- do.call(BiocGenerics::cbind, res)
    return(sce)
}


#' @name importBUStools
#' @rdname importBUStools
#' @title Construct SCE object from BUStools output
#' @description Read the barcodes, features (genes), and matrix from BUStools
#'  output. Import them
#'  as one \link[SingleCellExperiment]{SingleCellExperiment} object. Note the
#'  cells in the output files for BUStools 0.39.4 are not filtered.
#' @param BUStoolsDirs A vector of paths to BUStools output files. Each sample
#'  should have its own path. For example: \code{./genecount}.
#'  Must have the same length as \code{samples}.
#' @param samples A vector of user-defined sample names for the samples to be
#'  imported. Must have the same length as \code{BUStoolsDirs}.
#' @param matrixFileName Filename for the Market Exchange Format (MEX) sparse
#'  matrix file (.mtx file).
#' @param featuresFileName Filename for the feature annotation file.
#' @param barcodesFileName Filename for the cell barcode list file.
#' @param gzipped Boolean. \code{TRUE} if the BUStools output files
#'  (barcodes.txt, genes.txt, and genes.mtx) were
#'  gzip compressed. \code{FALSE} otherwise. This is \code{FALSE} in BUStools
#'  0.39.4. Default \code{FALSE}.
#' @param class Character. The class of the expression matrix stored in the SCE
#'  object. Can be one of "DelayedArray" (as returned by
#'  \link[DelayedArray]{DelayedArray} function), "Matrix" (as returned by
#'  \link[Matrix]{readMM} function), or "matrix" (as returned by
#'  \link[base]{matrix} function). Default "Matrix".
#' @return A \code{SingleCellExperiment} object containing the count
#'  matrix, the gene annotation, and the cell annotation.
#' @examples
#' # Example #1
#' # FASTQ files were downloaded from
#' # https://support.10xgenomics.com/single-cell-gene-expression/datasets/3.0.0
#' # /pbmc_1k_v3
#' # They were concatenated as follows:
#' # cat pbmc_1k_v3_S1_L001_R1_001.fastq.gz pbmc_1k_v3_S1_L002_R1_001.fastq.gz >
#' # pbmc_1k_v3_R1.fastq.gz
#' # cat pbmc_1k_v3_S1_L001_R2_001.fastq.gz pbmc_1k_v3_S1_L002_R2_001.fastq.gz >
#' # pbmc_1k_v3_R2.fastq.gz
#' # The following BUStools command generates the gene, cell, and
#' # matrix files
#'
#' # bustools correct -w ./3M-february-2018.txt -p output.bus | \
#' #   bustools sort -T tmp/ -t 4 -p - | \
#' #   bustools count -o genecount/genes \
#' #     -g ./transcripts_to_genes.txt \
#' #     -e matrix.ec \
#' #     -t transcripts.txt \
#' #     --genecounts -
#'
#' # The top 20 genes and the first 20 cells are included in this example.
#' sce <- importBUStools(
#'   BUStoolsDirs = system.file("extdata/BUStools_PBMC_1k_v3_20x20/genecount/",
#'     package = "singleCellTK"),
#'   samples = "PBMC_1k_v3_20x20")
#' @export
importBUStools <- function(
    BUStoolsDirs,
    samples,
    matrixFileName = "genes.mtx",
    featuresFileName = "genes.genes.txt",
    barcodesFileName = "genes.barcodes.txt",
    gzipped = FALSE,
    class = "Matrix") {

    .importBUStools(
        BUStoolsDirs = BUStoolsDirs,
        samples = samples,
        matrixFileName = matrixFileName,
        featuresFileName = featuresFileName,
        barcodesFileName = barcodesFileName,
        gzipped = gzipped,
        class = class)
}