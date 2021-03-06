% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/seuratFunctions.R
\name{seuratFindHVG}
\alias{seuratFindHVG}
\title{seuratFindHVG
Find highly variable genes and store in the input sce object}
\usage{
seuratFindHVG(
  inSCE,
  useAssay = "seuratNormData",
  hvgMethod = "vst",
  hvgNumber = 2000,
  altExp = FALSE,
  verbose = TRUE
)
}
\arguments{
\item{inSCE}{(sce) object to compute highly variable genes from and to store
back to it}

\item{useAssay}{Normalized assay inside the SCE object to use for hvg
computation.}

\item{hvgMethod}{selected method to use for computation of highly variable
genes. One of 'vst', 'dispersion', or 'mean.var.plot'. Default \code{"vst"}.}

\item{hvgNumber}{numeric value of how many genes to select as highly
variable. Default \code{2000}}

\item{altExp}{Logical value indicating if the input object is an
altExperiment. Default \code{FALSE}.}

\item{verbose}{Logical value indicating if informative messages should
be displayed. Default is \code{TRUE}.}
}
\value{
Updated \code{SingleCellExperiment} object with highly variable genes
computation stored
}
\description{
seuratFindHVG
Find highly variable genes and store in the input sce object
}
\examples{
data(scExample, package = "singleCellTK")
\dontrun{
sce <- seuratNormalizeData(sce, useAssay = "counts")
sce <- seuratFindHVG(sce, useAssay = "counts")
}
}
