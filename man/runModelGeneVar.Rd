% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scran_modelGeneVar.R
\name{runModelGeneVar}
\alias{runModelGeneVar}
\title{Calculate Variable Genes with Scran modelGeneVar}
\usage{
runModelGeneVar(inSCE, useAssay = "logcounts")
}
\arguments{
\item{inSCE}{A \linkS4class{SingleCellExperiment} object}

\item{useAssay}{A character string to specify an assay to compute variable 
features from. Default \code{"logcounts"}.}
}
\value{
\code{inSCE} updated with variable feature metrics in \code{rowData}
}
\description{
Generates and stores variability data in the input 
\linkS4class{SingleCellExperiment} object, using 
\code{\link[scran]{modelGeneVar}} method. 

Also selects a specified number of top HVGs and store the logical selection 
in \code{rowData}.
}
\examples{
data("scExample", package = "singleCellTK")
sce <- subsetSCECols(sce, colData = "type != 'EmptyDroplet'")
sce <- scaterlogNormCounts(sce, "logcounts")
sce <- runModelGeneVar(sce)
hvf <- getTopHVG(sce, method = "modelGeneVar", hvgNumber = 10,
          useFeatureSubset = NULL)
}
\seealso{
\code{\link{runFeatureSelection}}, \code{\link{runSeuratFindHVG}},
\code{\link{getTopHVG}}, \code{\link{plotTopHVG}}
}
\author{
Irzam Sarfraz
}
