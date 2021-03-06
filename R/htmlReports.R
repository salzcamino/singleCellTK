#' @title Get runDropletQC .html report
#' @description A  function to generate .html Rmarkdown report containing the visualizations of the runDropletQC function output
#' @param inSCE A \link[SingleCellExperiment]{SingleCellExperiment} object containing
#' the full droplet count matrix with the output from runDropletQC function
#' @param subTitle subtitle of the QC HTML report. Default is NULL.
#' @param studyDesign description of the data set and experiment design. It would be shown at the top of QC HTML report. Default is NULL.
#' @param output_file name of the generated file. If NULL/default then the output file name will be based on the name of the Rmarkdown template
#' @param output_dir name of the output directory to save the rendered file. If NULL/default the file is stored to the current working directory
#' @return .html file
#' @examples
#' data(scExample, package = "singleCellTK")
#' \dontrun{
#' sce <- runDropletQC(sce)
#' reportDropletQC(inSCE = sce)
#' }
#' @export
reportDropletQC <- function(inSCE, output_file = NULL,
                                   output_dir = NULL,
                                   subTitle = NULL,
                                   studyDesign = NULL) {

  if (is.null(output_dir)){
    output_dir<- getwd()
    }

  #report_path <- tempfile(fileext = ".Rmd")
  #file.copy(system.file("rmarkdown/qc/DropletQC.Rmd", package = "singleCellTK"), report_path, overwrite = TRUE)

  ## create temp Rmd file to bypass permission issue on server
  rmarkdown::render(system.file("rmarkdown/qc/DropletQC.Rmd", package = "singleCellTK"),
    params = list(object = inSCE, subTitle = subTitle, studyDesign = studyDesign),
    output_file = output_file,
    output_dir = output_dir,
    intermediates_dir = output_dir,
    knit_root_dir = output_dir)
 }


#' @title Get runCellQC .html report
#' @description A  function to generate .html Rmarkdown report containing the visualizations of the runCellQC function output
#' @param inSCE A \link[SingleCellExperiment]{SingleCellExperiment} object containing
#' the filtered count matrix with the output from runCellQC function
#' @param subTitle subtitle of the QC HTML report. Default is NULL.
#' @param studyDesign description of the data set and experiment design. It would be shown at the top of QC HTML report. Default is NULL.
#' @param output_file name of the generated file. If NULL/default then the output file name will be based on the name of the Rmarkdown template.
#' @param output_dir name of the output directory to save the rendered file. If NULL/default the file is stored to the current working directory
#' @return .html file
#' @examples
#' data(scExample, package = "singleCellTK")
#' sce <- subsetSCECols(sce, colData = "type != 'EmptyDroplet'")
#' \dontrun{
#' sce <- runCellQC(sce)
#' reportCellQC(inSCE = sce)
#' }
#' @export
reportCellQC <- function(inSCE, output_file = NULL,
                                output_dir = NULL,
                                subTitle = NULL,
                                studyDesign = NULL) {
  if (is.null(output_dir)){
    output_dir<- getwd()
  }
  #report_path <- tempfile(fileext = ".Rmd")
  #file.copy(system.file("rmarkdown/qc/CellQC.Rmd", package = "singleCellTK"), report_path, overwrite = TRUE)

  rmarkdown::render(system.file("rmarkdown/qc/CellQC.Rmd", package = "singleCellTK"),
    params = list(object = inSCE, subTitle = subTitle, studyDesign = studyDesign),
    output_file = output_file,
    output_dir = output_dir,
    intermediates_dir = output_dir,
    knit_root_dir = output_dir)
}


#' @title Get .html report of the output of the selected QC algorithm
#' @description A  function to generate .html Rmarkdown report for the specified QC algorithm output
#' @param inSCE A \link[SingleCellExperiment]{SingleCellExperiment} object containing
#' the count matrix (full droplets or filtered matrix, depends on the selected QC algorithm) with the output from at least one of these functions:
#' runQCMetrics, runScrublet, runScDblFinder, runCxds, runBcds, runCxdsBcdsHybrid, runDecontX, runBarcodeRankDrops, runEmptyDrops
#' @param algorithm Character. Specifies which QC algorithm report to generate.
#'  Available options are "BarcodeRankDrops", "EmptyDrops", "QCMetrics", "Scrublet", "ScDblFinder", "Cxds", "Bcds", "CxdsBcdsHybrid", "DoubletFinder"  and "DecontX".
#' @param output_file name of the generated file. If NULL/default then the output file name will be based on the name of the selected QC algorithm name .
#' @param output_dir name of the output directory to save the rendered file. If NULL/default the file is stored to the current working directory
#' @return .html file
#' @examples
#' data(scExample, package = "singleCellTK")
#' sce <- subsetSCECols(sce, colData = "type != 'EmptyDroplet'")
#' \dontrun{
#' sce <- runDecontX(sce)
#' sce <- getUMAP(sce)
#' reportQCTool(inSCE = sce, algorithm = "DecontX")
#' }
#' @export
reportQCTool <- function(inSCE, algorithm=c("BarcodeRankDrops",
                                            "EmptyDrops",
                                            "QCMetrics",
                                            "Scrublet",
                                            "ScDblFinder",
                                            "Cxds",
                                            "Bcds",
                                            "CxdsBcdsHybrid",
                                            "DoubletFinder",
                                            "DecontX"),
                         output_file = NULL,
                            output_dir = NULL) {

  algorithm <- match.arg(algorithm)

  if (is.null(output_dir)){
    output_dir<- getwd()
  }

  if (algorithm =="BarcodeRankDrops"){
    rmarkdown::render(system.file("rmarkdown/qc/BarcodeRankDrops.Rmd", package="singleCellTK"), params = list(
      object=inSCE), output_file = output_file, output_dir = output_dir)
  }
  if (algorithm =="EmptyDrops"){
    rmarkdown::render(system.file("rmarkdown/qc/EmptyDrops.Rmd", package="singleCellTK"), params = list(
      object=inSCE), output_file = output_file, output_dir = output_dir)
  }
  if (algorithm =="Cxds"){
    rmarkdown::render(system.file("rmarkdown/qc/Cxds.Rmd", package="singleCellTK"), params = list(
      object=inSCE), output_file = output_file, output_dir = output_dir)
  }
  if (algorithm =="Bcds"){
    rmarkdown::render(system.file("rmarkdown/qc/Bcds.Rmd", package="singleCellTK"), params = list(
      object=inSCE), output_file = output_file, output_dir = output_dir)
  }
  if (algorithm =="CxdsBcdsHybrid"){
    rmarkdown::render(system.file("rmarkdown/qc/CxdsBcdsHybrid.Rmd", package="singleCellTK"), params = list(
      object=inSCE), output_file = output_file, output_dir = output_dir)
  }
  if (algorithm =="DecontX"){
    rmarkdown::render(system.file("rmarkdown/qc/DecontX.Rmd", package="singleCellTK"), params = list(
      object=inSCE), output_file = output_file, output_dir = output_dir)
  }
  if (algorithm =="ScDblFinder"){
    rmarkdown::render(system.file("rmarkdown/qc/ScDblFinder.Rmd", package="singleCellTK"), params = list(
      object=inSCE), output_file = output_file, output_dir = output_dir)
  }
  if (algorithm =="QCMetrics"){
    rmarkdown::render(system.file("rmarkdown/qc/QCMetrics.Rmd", package="singleCellTK"), params = list(
      object=inSCE), output_file = output_file, output_dir = output_dir)
  }
  if (algorithm =="Scrublet"){
    rmarkdown::render(system.file("rmarkdown/qc/Scrublet.Rmd", package="singleCellTK"), params = list(
      object=inSCE), output_file = output_file, output_dir = output_dir)
  }
  if (algorithm =="DoubletFinder"){
    rmarkdown::render(system.file("rmarkdown/qc/DoubletFinder.Rmd", package="singleCellTK"), params = list(
      object=inSCE), output_file = output_file, output_dir = output_dir)
  }
 }

#' @title Get runDEAnalysis .html report
#' @description A  function to generate .html Rmarkdown report containing the
#' visualizations of the \code{\link{runDEAnalysis}} function output
#' @param inSCE A \code{\link[SingleCellExperiment]{SingleCellExperiment}}
#' object containing the output from \code{\link{runDEAnalysis}} function
#' @param study The specific analysis to visualize, used as \code{analysisName}
#' argument when running differential expression.
#' @param output_file name of the generated file. If \code{NULL} then the output
#' file name will be based on the name of the Rmarkdown template. Default
#' \code{NULL}.
#' @param output_dir name of the output directory to save the rendered file. If
#' \code{NULL} the file is stored to the current working directory.
#' Default \code{NULL}.
#' @return Saves the HTML report in the specified output directory.
#' @export
reportDiffExp <- function(inSCE, study,
                          output_file = NULL,
                          output_dir = NULL) {

  if (is.null(output_dir)){
    output_dir <- getwd()
  }
  if (!study %in% names(S4Vectors::metadata(inSCE)$diffExp)) {
    stop("Specified study not found in given SCE object")
  }
  rmarkdown::render(system.file("rmarkdown/de/DifferentialExpression.Rmd",
                                package="singleCellTK"),
                    params = list(object=inSCE, study=study),
                    output_file = output_file,
                    output_dir = output_dir )
}

#' @title Get findMarkerDiffExp .html report
#' @description A  function to generate .html Rmarkdown report containing the
#' visualizations of the \code{\link{findMarkerDiffExp}} function output
#' @param inSCE A \code{\link[SingleCellExperiment]{SingleCellExperiment}}
#' object containing the output from \code{\link{findMarkerDiffExp}} function
#' @param output_file name of the generated file. If \code{NULL} then the output
#' file name will be based on the name of the Rmarkdown template. Default
#' \code{NULL}.
#' @param output_dir name of the output directory to save the rendered file. If
#' \code{NULL} the file is stored to the current working directory.
#' Default \code{NULL}.
#' @return An HTML file of the report will be generated at the path specified
#' in the arguments.
#' @export
reportFindMarker <- function(inSCE, output_file = NULL, output_dir = NULL) {

  if (is.null(output_dir)){
    output_dir <- getwd()
  }
  if (!"findMarker" %in% names(S4Vectors::metadata(inSCE))) {
    stop("Find marker result not presented in input SCE object. Run ",
         "findMarkerDiffExp() first. ")
  }
  att <- names(attributes(S4Vectors::metadata(inSCE)$findMarker))
  if (!"useAssay" %in% att) {
    stop("Can't identify the structure of find marker result. Run ",
         "findMarkerDiffExp() first. ")
  }
  rmarkdown::render(system.file("rmarkdown/de/FindMarker.Rmd",
                                package="singleCellTK"),
                    params = list(object = inSCE),
                    output_file = output_file,
                    output_dir = output_dir )
}

#' Computes an HTML report from the Seurat workflow and returns the output SCE
#'  object with the computations stored in it.
#' @param inSCE Input \code{SingleCellExperiment} object.
#' @param outputFile Specify the name of the generated output HTML file. If \code{NULL} then the output
#' file name will be based on the name of the Rmarkdown template. Default
#' \code{NULL}.
#' @param outputDir Specify the name of the output directory to save the
#'  rendered HTML file. If \code{NULL} the file is stored to the current
#'  working directory.
#' @param subtitle A \code{character} value specifying the subtitle to use in the
#'  Seurat report.
#' @param authors A \code{character} value specifying the names of the authors
#'  to use in the Seurat report.
#' @param sce A \code{character} value specifying the path of the input
#'  \code{SingleCellExperiment} object.
#' @param biological.group A character value that specifies the name of the
#'  \code{colData} column to use as the main biological group in the seurat
#'  report for differential expression and grouping.
#' @param phenotype.groups A \code{character} vector that specifies the names
#'  of the \code{colData} columns to use for differential expression in addition
#'  to the \code{biological.group} parameter.
#' @param selected.markers A \code{character} vector specifying the user decided
#'  gene symbols of pre-selected markers that be used to generate gene plots in
#'  addition to the gene markers computed from differential expression.
#' @param clustering.resolution A \code{numeric} value indicating the resolution
#'  to use with clustering. Default is \code{0.8}.
#' @param variable.features A \code{numeric} value indicating the number of
#'  top variable genes to identify in the seurat report. Default is \code{2000}.
#' @param pc.count A \code{numeric} value indicating the number of principal
#'  components to use in the analysis workflow. Default is \code{10}.
#' @param showSession A \code{logical} value indicating if session information
#'  should be displayed or not. Default is \code{TRUE}.
#' @param pdf A \code{logical} value indicating if a pdf should also be
#'  generated for each figure in the report. Default is \code{TRUE}.
#' @return A \code{SingleCellExperiment} object that has the seurat computations
#'  stored and can be used to interactively visualize the plots by importing
#'  in the \code{singleCellTK} user interface.
#' @export
seuratReport <- function(inSCE,
                         outputFile = NULL,
                         outputDir = NULL,
                         subtitle = "BUMC Single Cell Sequencing Core",
                         authors = "Tianmu (Timo) Hu, Irzam Sarfraz",
                         sce = NULL,
                         biological.group = NULL,
                         phenotype.groups = NULL,
                         selected.markers = NULL,
                         clustering.resolution = 0.8,
                         variable.features = 2000,
                         pc.count = 10,
                         showSession = TRUE,
                         pdf = TRUE){

  if(is.null(biological.group)){
    stop("Must specify atleast one biological.group that is present in the colData of input object.")
  }

  if(!biological.group %in% names(colData(inSCE))){
    stop(biological.group, " not found in the colData of input object.")
  }

  if(!is.null(phenotype.groups)){
    if(!all(phenotype.groups %in% names(colData(inSCE)))){
      stop(phenotype.groups, " not found in the colData of input object.")
    }
  }

  if(is.null(outputDir)){
    outputDir <- getwd()
    message("No output directory defined, using current working directory ", outputDir, " instead.")
  }

  rmarkdown::render(system.file("rmarkdown/seurat/SeuratReport.Rmd",
                                package="singleCellTK"),
                    params = list(
                      subtitle = subtitle,
                      authors = authors,
                      sce = inSCE,
                      biological.group = biological.group,
                      phenotype.groups = phenotype.groups,
                      selected.markers = selected.markers,
                      clustering.resolution = clustering.resolution,
                      variable.features = variable.features,
                      pc.count = pc.count,
                      outputPath = outputDir,
                      showSession = showSession,
                      pdf = pdf
                    ),
                    output_file = outputFile,
                    output_dir = outputDir,
                    intermediates_dir = outputDir,
                    knit_root_dir = outputDir)

  path <- paste0(outputDir, "SCE_SeuratReport", "-", gsub(" ", "_", Sys.Date()), ".rds")
  outSCE <- readRDS(path)

  message("Output SCE object stored as ", paste0("SCE_SeuratReport", "-", gsub(" ", "_", Sys.Date()), ".rds"), " in ", outputDir, ".")
  message("Output HTML file stored as ", outputFile, " in ", outputDir, ".")

  return(outSCE)
}


#' @export
reportDifferentialFET <-
    function(sce,
             variable,
             phenotype,
             control,
             case,
             output_dir = ".",
             output_file = "DifferentialAbundanceFET_Report",
             pdf = FALSE,
             showSession = TRUE
    ){
        res <- differentialAbundanceFET(sce, variable, phenotype, control, case)
        rmarkdown::render(
            system.file("rmarkdown/DifferentialAbundanceFET_Report.Rmd"),
            params = list(
                sce = sce,
                res = res,
                pdf = isTRUE(pdf),
                showSession = isTRUE(showSession)
            ),
            output_file = output_file,
            output_dir = output_dir
        )
    }


#' @export
reportClusterAbundance <- function(sce,
                                   variable,
                                   phenotype,
                                   output_dir = ".",
                                   output_file = "plotClusterAbundance_Report",
                                   pdf = FALSE,
                                   showSession = TRUE
){
    plot <- plotClusterAbundance(sce, variable, phenotype)
    rmarkdown::render(
        system.file("rmarkdown/PlotClusterAbundance_Report.Rmd"),
        params = list(
            sce = sce,
            plot = plot,
            pdf = isTRUE(pdf),
            showSession = isTRUE(showSession)
        ),
        output_file = output_file,
        output_dir = output_dir
    )
}