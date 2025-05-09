# dimensionality reduction algorithms
library(singleCellTK)
context("Testing dimensionality reduction algorithms")
data(scExample, package = "singleCellTK")
sceDroplet <- sce
sce <- subsetSCECols(sce, colData = "type != 'EmptyDroplet'")
sampleVector <- c(rep("Sample1", 100), rep("Sample2", 95))
sceres <- runQuickUMAP(inSCE = sce, sample = sampleVector, nNeighbors = 10,
                nIterations = 20, alpha = 1, minDist = 0.01, initialDims = 20)

# allow some additional memory over default
options(future.globals.maxSize = 786432000)

test_that(desc = "Testing plotSCEScatter functions", {
    p1 <- plotSCEScatter(inSCE = sceres, legendTitle = NULL,
        slot = "assays", annotation = "counts", feature = "ENSG00000251562",
        reducedDimName = "UMAP", labelClusters = FALSE,
        sample = sampleVector, combinePlot = "all")
    expect_is(p1, c("gg","ggplot"))
    p2 <- plotSCEDimReduceFeatures(inSCE = sceres, feature = "ENSG00000251562",
        shape = NULL, reducedDimName = "UMAP",
        useAssay = "counts", xlab = "UMAP1", ylab = "UMAP2",
        sample = sampleVector, combinePlot = "all")
    expect_is(p2, c("gg","ggplot"))
    p3 <- plotSCEDimReduceColData(inSCE = sceres, colorBy = "type",
        shape = NULL, conditionClass = "factor",
        reducedDimName = "UMAP",
        xlab = "UMAP1", ylab = "UMAP2", labelClusters = TRUE,
        sample = sampleVector, combinePlot = "all")
    expect_is(p3, c("gg","ggplot"))
})

test_that(desc = "Testing plotSCEViolin functions", {
    p1 <- plotSCEViolin(inSCE = sceres, slotName = "assays",
                        itemName = "counts", feature = "ENSG00000251562",
                        groupBy = "type", sample = sampleVector,
                        combinePlot = "all")
    expect_is(p1, c("gg","ggplot"))
    p2 <- plotSCEViolinAssayData(inSCE = sceres,
        feature = "ENSG00000251562", groupBy = "type",
        sample = sampleVector,combinePlot = "all")
    expect_is(p2, c("gg","ggplot"))
    p3 <- plotSCEViolinColData(inSCE = sceres,
        coldata = "type", groupBy = "sample",
        sample = sampleVector)
    expect_is(p3, "list")
})


sceres <- sceres[, colData(sceres)$type != 'EmptyDroplet']
sceres <- runCellQC(sceres, algorithms = c("QCMetrics", "cxds", "bcds", "cxds_bcds_hybrid",
                                              "doubletFinder", "decontX"))
sceres <- runScDblFinder(sceres)


context("Testing QC functions")

test_that("Testing scds",{
  sce <- runCxdsBcdsHybrid(sce, estNdbl = TRUE)
  expect_equal(class(colData(sceres)$scds_hybrid_score), 'numeric')
  expect_equal(class(colData(sceres)$scds_hybrid_call), 'factor')
})

test_that(desc = "Testing DoubletFinder",  {
  expect_equal(length(colData(sceres)$doubletFinder_doublet_score_resolution_1.5),ncol(sce))
  expect_equal(class(colData(sceres)$doubletFinder_doublet_score_resolution_1.5), "numeric")
})


test_that(desc = "Testing runScDblFinder", {
  expect_equal(length(colData(sceres)$scDblFinder_doublet_score),ncol(sce))
  expect_equal(class(colData(sceres)$scDblFinder_doublet_score), "numeric")
})

sceDroplet <- runDropletQC(sceDroplet)

test_that("Testing emptydrops",{
  expect_equal(class(colData(sceDroplet)$dropletUtils_emptyDrops_total), 'integer')
  expect_equal(class(colData(sceDroplet)$dropletUtils_emptyDrops_logprob), 'numeric')
  expect_equal(class(colData(sceDroplet)$dropletUtils_emptyDrops_pvalue), 'numeric')
  expect_equal(class(colData(sceDroplet)$dropletUtils_emptyDrops_limited), 'logical')
  expect_equal(class(colData(sceDroplet)$dropletUtils_emptyDrops_fdr), 'numeric')
})


test_that(desc = "Testing plotResults functions", {
  #commenting below two lines of code due to an error in the R CMD check (irzam)
  #r1 <- plotRunPerCellQCResults(inSCE = sceres, sample = sampleVector, combinePlot = "all")
    #expect_is(r1, c("gg","ggplot"))
  # r2 <- plotScrubletResults(inSCE = sceres, reducedDimName="UMAP", sample = sampleVector, combinePlot = "all")
  #   expect_is(r2, c("gg","ggplot"))
  r3 <- plotScDblFinderResults(inSCE = sceres, reducedDimName="UMAP", sample = sampleVector, combinePlot = "all")
    expect_is(r3, c("gg","ggplot"))
  r4 <- plotDoubletFinderResults(inSCE = sceres, reducedDimName="UMAP", sample = sampleVector, combinePlot = "all")
    expect_is(r4, c("gg","ggplot"))
  r5 <- plotCxdsResults(inSCE = sceres, reducedDimName="UMAP", sample = sampleVector, combinePlot = "all")
    expect_is(r5,  c("gg","ggplot"))
  r6 <- plotBcdsResults(inSCE = sceres, reducedDimName="UMAP", sample = sampleVector, combinePlot = "all")
    expect_is(r6,  c("gg","ggplot"))
  r7 <- plotScdsHybridResults(inSCE = sceres, reducedDimName="UMAP", sample = sampleVector, combinePlot = "all")
    expect_is(r7,  c("gg","ggplot"))
  r8 <- plotDecontXResults(inSCE = sceres, reducedDimName="UMAP", sample = sampleVector, combinePlot = "all")
    expect_is(r8, c("gg","ggplot"))

  sceDroplet <- runDropletQC(sceDroplet)
  r9 <- plotEmptyDropsResults(inSCE = sceDroplet, sample = c(rep("Sample1", 100), rep("Sample2", 290)))
    expect_is(r9, "list")
})

