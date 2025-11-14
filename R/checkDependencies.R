#' Check if required packages are installed
#'
#' Internal helper function to check for required packages
#' @param packages Character vector of package names
#' @param message Custom message for error
#' @param bioc Logical, are these Bioconductor packages?
#' @return NULL (stops with error if packages missing)
#' @keywords internal
.checkRequiredPackages <- function(packages, message = NULL, bioc = TRUE) {
  missing <- character()
  for (pkg in packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      missing <- c(missing, pkg)
    }
  }

  if (length(missing) > 0) {
    install_cmd <- if (bioc) {
      paste0("BiocManager::install(c('", paste(missing, collapse = "', '"), "'))")
    } else {
      paste0("install.packages(c('", paste(missing, collapse = "', '"), "'))")
    }

    default_msg <- paste0(
      "The following required package(s) are not installed: ",
      paste(missing, collapse = ", "), ". ",
      "Install with: ", install_cmd
    )

    stop(if (!is.null(message)) message else default_msg, call. = FALSE)
  }

  invisible(NULL)
}


#' Install optional singleCellTK dependencies
#'
#' Helper function to install optional dependencies for specific features
#'
#' @param category Character. Which category of dependencies to install.
#' Options: "all", "shiny", "batch", "doublet", "pathway", "reports",
#' "examples", "trajectory", "import_export", "plotting", "annotation", "qc"
#'
#' @return NULL (invisibly). Installs packages as side effect.
#'
#' @details
#' The singleCellTK package has a modular dependency structure. Core
#' functionality is available with the base installation, but many specialized
#' features require additional packages. This function helps you install
#' packages for specific use cases:
#'
#' \describe{
#'   \item{shiny}{Packages for the interactive Shiny GUI}
#'   \item{batch}{Batch correction methods (batchelor, scMerge, sva, zinbwave)}
#'   \item{doublet}{Doublet detection methods (scds, scDblFinder, DoubletFinder)}
#'   \item{pathway}{Pathway and gene set analysis (enrichR, VAM, msigdbr)}
#'   \item{reports}{HTML report generation (rmarkdown, yaml)}
#'   \item{examples}{Example datasets (TENxPBMCData, scRNAseq, etc.)}
#'   \item{trajectory}{Trajectory analysis (TSCAN, TrajectoryUtils)}
#'   \item{import_export}{Special import/export formats (tximport, zellkonverter, anndata)}
#'   \item{plotting}{Enhanced plotting (plotly, circlize, ggplotify, gridExtra)}
#'   \item{annotation}{Cell type annotation (SingleR, celldex)}
#'   \item{qc}{Additional QC methods (SoupX, celda)}
#'   \item{all}{All optional dependencies}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Install Shiny GUI dependencies
#' installOptionalDeps("shiny")
#'
#' # Install all batch correction methods
#' installOptionalDeps("batch")
#'
#' # Install everything
#' installOptionalDeps("all")
#' }
installOptionalDeps <- function(category = c("all", "shiny", "batch",
                                              "doublet", "pathway",
                                              "reports", "examples",
                                              "trajectory", "import_export",
                                              "plotting", "annotation", "qc")) {
  category <- match.arg(category)

  packages <- list(
    shiny = c("shiny", "shinyjs", "shinyalert", "shinycssloaders",
              "colourpicker", "DT"),
    batch = c("batchelor", "scMerge", "sva", "zinbwave"),
    doublet = c("scds", "scDblFinder", "ROCR", "KernSmooth", "fields"),
    pathway = c("enrichR", "VAM", "msigdbr"),
    reports = c("rmarkdown", "yaml"),
    examples = c("TENxPBMCData", "scRNAseq", "AnnotationHub",
                 "ExperimentHub", "ensembldb"),
    trajectory = c("TSCAN", "TrajectoryUtils"),
    import_export = c("tximport", "R.utils", "zellkonverter", "anndata"),
    plotting = c("plotly", "ggplotify", "circlize", "gridExtra"),
    annotation = c("SingleR", "celldex"),
    qc = c("SoupX", "celda")
  )

  if (category == "all") {
    to_install <- unique(unlist(packages, use.names = FALSE))
  } else {
    to_install <- packages[[category]]
  }

  message("Installing optional dependencies for '", category, "': ",
          paste(to_install, collapse = ", "))

  # Define which packages are from Bioconductor
  bioc_pkgs <- c("batchelor", "scMerge", "sva", "zinbwave", "scds",
                 "scDblFinder", "enrichR", "VAM", "TENxPBMCData",
                 "scRNAseq", "AnnotationHub", "ExperimentHub", "ensembldb",
                 "TSCAN", "TrajectoryUtils", "tximport", "zellkonverter",
                 "anndata", "SingleR", "celldex", "SoupX", "celda")

  bioc_to_install <- intersect(to_install, bioc_pkgs)
  cran_to_install <- setdiff(to_install, bioc_pkgs)

  # Install Bioconductor packages
  if (length(bioc_to_install) > 0) {
    if (!requireNamespace("BiocManager", quietly = TRUE)) {
      message("Installing BiocManager first...")
      utils::install.packages("BiocManager")
    }
    message("Installing from Bioconductor: ",
            paste(bioc_to_install, collapse = ", "))
    BiocManager::install(bioc_to_install, update = FALSE, ask = FALSE)
  }

  # Install CRAN packages
  if (length(cran_to_install) > 0) {
    message("Installing from CRAN: ", paste(cran_to_install, collapse = ", "))
    utils::install.packages(cran_to_install)
  }

  message("Installation complete!")
  invisible(NULL)
}
