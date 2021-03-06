% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DownsampleMatrix.R
\name{downSampleDepth}
\alias{downSampleDepth}
\title{Estimate numbers of detected genes, significantly differentially expressed
genes, and median significant effect size}
\usage{
downSampleDepth(
  originalData,
  useAssay = "counts",
  minCount = 10,
  minCells = 3,
  maxDepth = 1e+07,
  realLabels,
  depthResolution = 10,
  iterations = 10
)
}
\arguments{
\item{originalData}{\linkS4class{SingleCellExperiment} object storing all
assay data from the shiny app.}

\item{useAssay}{Character. The name of the assay to be used for subsampling.}

\item{minCount}{Numeric. The minimum number of reads found for a gene to be
considered detected.}

\item{minCells}{Numeric. The minimum number of cells a gene must have at
least 1 read in for it to be considered detected.}

\item{maxDepth}{Numeric. The highest number of total reads to be simulated.}

\item{realLabels}{Character. The name of the condition of interest. Must match
a name from sample data.}

\item{depthResolution}{Numeric. How many different read depth should the
script simulate? Will simulate a number of experimental designs ranging from
10 reads to maxReadDepth, with logarithmic spacing.}

\item{iterations}{Numeric. How many times should each experimental design be
simulated?}
}
\value{
A 3-dimensional array, with dimensions = c(iterations,
depthResolution, 3). [,,1] contains the number of detected genes in each
simulated dataset, [,,2] contains the number of significantly differentially
expressed genes in each simulation, and [,,3] contains the mediansignificant
effect size in each simulation. If no genes are significantly differentially
expressed, the median effect size defaults to infinity.
}
\description{
Estimate numbers of detected genes, significantly differentially expressed
genes, and median significant effect size
}
\examples{
data("mouseBrainSubsetSCE")
subset <- mouseBrainSubsetSCE[seq(1000),]
res <- downSampleDepth(subset,
                       realLabels = "level1class",
                       iterations=2)

}
