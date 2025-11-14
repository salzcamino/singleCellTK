# Implementation Checklist - Dependency Reduction

## File-by-File Modification Guide

This checklist provides exact changes needed for each file.

---

## 1. DESCRIPTION File Changes

### Remove Completely (2):
```diff
- eds,
- GSVAdata,
```

### Move from Imports to Suggests (45):

Add to Suggests section:
```r
Suggests:
    # ... existing suggests packages ...
    # Shiny UI packages
    shiny,
    shinyjs,
    shinyalert,
    shinycssloaders,
    colourpicker,
    DT,
    # Example data packages
    TENxPBMCData,
    scRNAseq,
    AnnotationHub,
    ExperimentHub,
    ensembldb,
    # Pathway analysis
    enrichR (>= 3.2),
    VAM (>= 0.5.3),
    msigdbr,
    # Batch correction
    batchelor,
    scMerge (>= 1.2.0),
    sva,
    zinbwave,
    # Cell type annotation
    SingleR,
    celldex,
    # QC methods
    SoupX,
    # Doublet detection
    scds (>= 1.2.0),
    scDblFinder,
    ROCR,
    KernSmooth,
    fields,
    # Trajectory
    TSCAN,
    TrajectoryUtils,
    # Workflows
    celda,
    zellkonverter,
    anndata,
    # Testing
    ape,
    ggtree,
    cluster,
    # Plotting
    plotly,
    ggplotify,
    circlize,
    gridExtra,
    # Reports
    rmarkdown,
    yaml,
    # Import/Export
    tximport,
    R.utils
```

---

## 2. R/singleCellTK.R

### Line 11: Remove import
```diff
- #' @import GSVAdata Biobase DelayedArray
+ #' @import Biobase DelayedArray
```

### Lines 24-33: Add dependency check
```r
singleCellTK <- function(inSCE=NULL, includeVersion=TRUE, theme='yeti') {
  # Check for Shiny dependencies
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("The Shiny GUI requires additional packages. ",
         "Install with: singleCellTK::installOptionalDeps('shiny')\n",
         "Or manually: install.packages(c('shiny', 'shinyjs', ",
         "'shinyalert', 'shinycssloaders', 'colourpicker', 'DT'))",
         call. = FALSE)
  }

  appDir <- system.file("shiny", package = "singleCellTK")
  if (!is.null(inSCE) & is.null(rownames(inSCE))){
    stop("ERROR: No row names (gene names) found.")
  }
  shiny::shinyOptions(inputSCEset = inSCE)
  shiny::shinyOptions(includeVersion = includeVersion)
  shiny::shinyOptions(theme = theme)
  shiny::runApp(appDir, display.mode = "normal")
}
```

---

## 3. R/importExampleData.R

### Lines 60-63: Modernize check (optional)
```r
# Current:
if(!("scRNAseq" %in% rownames(utils::installed.packages()))) {
  p <- paste0("Package 'scRNAseq' is not installed. Please install to load dataset '", dataset, "'.")
  stop(p)
}

# Updated:
if (!requireNamespace("scRNAseq", quietly = TRUE)) {
  stop("Package 'scRNAseq' is required to load dataset '", dataset, "'. ",
       "Install with: BiocManager::install('scRNAseq')",
       call. = FALSE)
}
```

### Lines 87-90: Modernize check (optional)
```r
# Current:
if(!("TENxPBMCData" %in% rownames(utils::installed.packages()))) {
  p <- paste0("Package 'TENxPBMCData' is not installed. Please install to load dataset '", dataset, "'.")
  stop(p)
}

# Updated:
if (!requireNamespace("TENxPBMCData", quietly = TRUE)) {
  stop("Package 'TENxPBMCData' is required to load dataset '", dataset, "'. ",
       "Install with: BiocManager::install('TENxPBMCData')",
       call. = FALSE)
}
```

### Lines 72-74: Add checks for AnnotationHub and ensembldb
```r
if (dataset == "NestorowaHSCData") {
  if (!requireNamespace("AnnotationHub", quietly = TRUE) ||
      !requireNamespace("ensembldb", quietly = TRUE)) {
    stop("Loading NestorowaHSCData requires AnnotationHub and ensembldb. ",
         "Install with: BiocManager::install(c('AnnotationHub', 'ensembldb'))",
         call. = FALSE)
  }
  temp <- scRNAseq::NestorowaHSCData()
  ens.mm.v97 <- AnnotationHub::AnnotationHub()[["AH73905"]]
  anno <- ensembldb::select(ens.mm.v97, keys=rownames(temp),
                            keytype="GENEID", columns=c("SYMBOL", "SEQNAME"))
  # ... rest of code
}
```

---

## 4. R/enrichRSCE.R

### After line 50 (start of runEnrichR function):
```r
runEnrichR <- function(inSCE,
                       features,
                       analysisName,
                       db = NULL,
                       by = "rownames",
                       featureName = NULL) {
  # Check for enrichR package
  if (!requireNamespace("enrichR", quietly = TRUE)) {
    stop("The enrichR package is required for this function. ",
         "Install with: BiocManager::install('enrichR')",
         call. = FALSE)
  }

  if (!inherits(inSCE, "SingleCellExperiment")) {
    stop("inSCE has to inherit from SingleCellExperiment object.")
  }
  # ... rest of function
```

---

## 5. R/runVAM.R

### After line 51 (start of runVAM function):
```r
runVAM <- function(inSCE, geneSetCollectionName = "H", useAssay = "logcounts",
                   resultNamePrefix = NULL, center = FALSE, gamma = TRUE) {
  # Check for VAM package
  if (!requireNamespace("VAM", quietly = TRUE)) {
    stop("The VAM package is required for this function. ",
         "Install with: BiocManager::install('VAM')",
         call. = FALSE)
  }

  if (!inherits(inSCE, "SingleCellExperiment")) {
    stop("inSCE has to inherit from SingleCellExperiment object.")
  }
  # ... rest of function
```

---

## 6. R/importGeneSets.R

Find `importGeneSetsFromMSigDB()` function and add at start:
```r
importGeneSetsFromMSigDB <- function(...) {
  if (!requireNamespace("msigdbr", quietly = TRUE)) {
    stop("The msigdbr package is required for this function. ",
         "Install with: BiocManager::install('msigdbr')",
         call. = FALSE)
  }
  # ... rest of function
```

---

## 7. R/runBatchCorrection.R

### runFastMNN() function - add check:
```r
runFastMNN <- function(...) {
  if (!requireNamespace("batchelor", quietly = TRUE)) {
    stop("The batchelor package is required for FastMNN. ",
         "Install with: BiocManager::install('batchelor')",
         call. = FALSE)
  }
  # ... rest of function
```

### runMNNCorrect() function - add check:
```r
runMNNCorrect <- function(...) {
  if (!requireNamespace("batchelor", quietly = TRUE)) {
    stop("The batchelor package is required for MNN Correct. ",
         "Install with: BiocManager::install('batchelor')",
         call. = FALSE)
  }
  # ... rest of function
```

### runSCMerge() function - add check:
```r
runSCMerge <- function(...) {
  if (!requireNamespace("scMerge", quietly = TRUE)) {
    stop("The scMerge package is required for this function. ",
         "Install with: BiocManager::install('scMerge')",
         call. = FALSE)
  }
  # ... rest of function
```

### runComBatSeq() function - add check after line 127:
```r
runComBatSeq <- function(inSCE, useAssay = "counts", batch = 'batch',
                         covariates = NULL, bioCond = NULL, useSVA = FALSE,
                         assayName = "ComBatSeq", shrink = FALSE,
                         shrinkDisp = FALSE, nGene = NULL) {
  # Check for sva package
  if (!requireNamespace("sva", quietly = TRUE)) {
    stop("The sva package is required for ComBat-Seq. ",
         "Install with: BiocManager::install('sva')",
         call. = FALSE)
  }

  if(!inherits(inSCE, "SingleCellExperiment")){
    stop("\"inSCE\" should be a SingleCellExperiment Object.")
  }
  # ... rest of function
```

### runZINBWaVE() function - add check:
```r
runZINBWaVE <- function(...) {
  if (!requireNamespace("zinbwave", quietly = TRUE)) {
    stop("The zinbwave package is required for this function. ",
         "Install with: BiocManager::install('zinbwave')",
         call. = FALSE)
  }
  # ... rest of function
```

---

## 8. R/runSingleR.R

### runSingleR() function - add check:
```r
runSingleR <- function(...) {
  if (!requireNamespace("SingleR", quietly = TRUE)) {
    stop("The SingleR package is required for this function. ",
         "Install with: BiocManager::install('SingleR')",
         call. = FALSE)
  }
  # ... rest of function
```

### When using celldex references (conditional check):
```r
# In section where celldex references are accessed
if (useBuiltInRef && !requireNamespace("celldex", quietly = TRUE)) {
  stop("Built-in reference datasets require the celldex package. ",
       "Install with: BiocManager::install('celldex')",
       call. = FALSE)
}
```

---

## 9. R/runSoupX.R

### runSoupX() function - add check:
```r
runSoupX <- function(...) {
  if (!requireNamespace("SoupX", quietly = TRUE)) {
    stop("The SoupX package is required for this function. ",
         "Install with: BiocManager::install('SoupX')",
         call. = FALSE)
  }
  # ... rest of function
```

---

## 10. R/scds_doubletdetection.R

### Add to runCxds(), runBcds(), and runCxdsBcdsHybrid():
```r
if (!requireNamespace("scds", quietly = TRUE)) {
  stop("The scds package is required for this function. ",
       "Install with: BiocManager::install('scds')",
       call. = FALSE)
}
```

---

## 11. R/scDblFinder_doubletDetection.R

### runScDblFinder() function - add check:
```r
runScDblFinder <- function(...) {
  if (!requireNamespace("scDblFinder", quietly = TRUE)) {
    stop("The scDblFinder package is required for this function. ",
         "Install with: BiocManager::install('scDblFinder')",
         call. = FALSE)
  }
  # ... rest of function
```

---

## 12. R/doubletFinder_doubletDetection.R

### runDoubletFinder() function - add check:
```r
runDoubletFinder <- function(...) {
  # Check for DoubletFinder dependencies
  missing <- character()
  for (pkg in c("ROCR", "KernSmooth", "fields")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      missing <- c(missing, pkg)
    }
  }
  if (length(missing) > 0) {
    stop("DoubletFinder requires additional packages: ",
         paste(missing, collapse = ", "), ". ",
         "Install with: install.packages(c('",
         paste(missing, collapse = "', '"), "'))",
         call. = FALSE)
  }
  # ... rest of function
```

---

## 13. R/runTSCAN.R

### Add to TSCAN functions:
```r
if (!requireNamespace("TSCAN", quietly = TRUE)) {
  stop("The TSCAN package is required for trajectory analysis. ",
       "Install with: BiocManager::install('TSCAN')",
       call. = FALSE)
}
```

### Note: TrajectoryUtils check
```r
if (!requireNamespace("TrajectoryUtils", quietly = TRUE)) {
  stop("The TrajectoryUtils package is required with TSCAN. ",
       "Install with: BiocManager::install('TrajectoryUtils')",
       call. = FALSE)
}
```

---

## 14. R/celda_decontX.R

### runDecontX() function - add check:
```r
runDecontX <- function(...) {
  if (!requireNamespace("celda", quietly = TRUE)) {
    stop("The celda package is required for decontX. ",
         "Install with: BiocManager::install('celda')",
         call. = FALSE)
  }
  # ... rest of function
```

---

## 15. R/scanpyFunctions.R and R/sce2adata.R

### Add to functions using zellkonverter:
```r
if (!requireNamespace("zellkonverter", quietly = TRUE)) {
  stop("Scanpy workflows and AnnData conversion require zellkonverter. ",
       "Install with: BiocManager::install('zellkonverter')",
       call. = FALSE)
}
```

---

## 16. R/exportSCEtoAnndata.R

### exportSCEtoAnnData() function:
```r
exportSCEtoAnnData <- function(...) {
  if (!requireNamespace("zellkonverter", quietly = TRUE)) {
    stop("Exporting to AnnData requires the zellkonverter package. ",
         "Install with: BiocManager::install('zellkonverter')",
         call. = FALSE)
  }
  # Also check for anndata
  if (!requireNamespace("anndata", quietly = TRUE)) {
    stop("Exporting to AnnData requires the anndata package. ",
         "Install with: BiocManager::install('anndata')",
         call. = FALSE)
  }
  # ... rest of function
```

---

## 17. R/htmlReports.R

### Add to all report functions (reportCellQC, reportDropletQC, etc.):
```r
if (!requireNamespace("rmarkdown", quietly = TRUE)) {
  stop("HTML report generation requires the rmarkdown package. ",
       "Install with: install.packages('rmarkdown')",
       call. = FALSE)
}
```

---

## 18. R/sctkQCUtils.R

### Where YAML export occurs:
```r
if (!requireNamespace("yaml", quietly = TRUE)) {
  stop("YAML export requires the yaml package. ",
       "Install with: install.packages('yaml')",
       call. = FALSE)
}
```

---

## 19. R/importAlevin.R

### importAlevin() function:
```r
importAlevin <- function(...) {
  if (!requireNamespace("tximport", quietly = TRUE)) {
    stop("Importing Alevin data requires the tximport package. ",
         "Install with: BiocManager::install('tximport')",
         call. = FALSE)
  }
  # ... rest of function
```

---

## 20. R/exportSCEtoTXT.R

### Where R.utils is used for compression:
```r
if (!requireNamespace("R.utils", quietly = TRUE)) {
  stop("File compression requires the R.utils package. ",
       "Install with: install.packages('R.utils')",
       call. = FALSE)
}
```

---

## 21. R/plotDEAnalysis.R

### Where ggplotify is used:
```r
if (!requireNamespace("ggplotify", quietly = TRUE)) {
  stop("This plotting function requires ggplotify. ",
       "Install with: install.packages('ggplotify')",
       call. = FALSE)
}
```

---

## 22. R/plotSCEHeatmap.R

### Where circlize is used for color ramps:
```r
if (!requireNamespace("circlize", quietly = TRUE)) {
  stop("Heatmap color scales require the circlize package. ",
       "Install with: install.packages('circlize')",
       call. = FALSE)
}
```

---

## 23. R/seuratFunctions.R

### Where plotly is used for interactive plots:
```r
# Instead of error, use warning and fallback
if (!requireNamespace("plotly", quietly = TRUE)) {
  warning("The plotly package is recommended for interactive plots. ",
          "Falling back to static ggplot2. ",
          "Install with: install.packages('plotly')")
  use_plotly <- FALSE
} else {
  use_plotly <- TRUE
}
```

---

## 24. CREATE NEW FILE: R/checkDependencies.R

```r
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
#' "examples", "trajectory", "import_export", "plotting"
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
#'   \item{batch}{Batch correction methods (batchelor, scMerge, sva, etc.)}
#'   \item{doublet}{Doublet detection methods (scds, scDblFinder, DoubletFinder)}
#'   \item{pathway}{Pathway and gene set analysis (enrichR, VAM, msigdbr)}
#'   \item{reports}{HTML report generation (rmarkdown, yaml)}
#'   \item{examples}{Example datasets (TENxPBMCData, scRNAseq, etc.)}
#'   \item{trajectory}{Trajectory analysis (TSCAN, TrajectoryUtils)}
#'   \item{import_export}{Special import/export formats (tximport, zellkonverter)}
#'   \item{plotting}{Enhanced plotting (plotly, circlize, ggplotify)}
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
                                              "plotting")) {
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
    plotting = c("plotly", "ggplotify", "circlize", "gridExtra")
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
                 "anndata")

  bioc_to_install <- intersect(to_install, bioc_pkgs)
  cran_to_install <- setdiff(to_install, bioc_pkgs)

  # Install Bioconductor packages
  if (length(bioc_to_install) > 0) {
    if (!requireNamespace("BiocManager", quietly = TRUE)) {
      message("Installing BiocManager first...")
      install.packages("BiocManager")
    }
    message("Installing from Bioconductor: ",
            paste(bioc_to_install, collapse = ", "))
    BiocManager::install(bioc_to_install, update = FALSE, ask = FALSE)
  }

  # Install CRAN packages
  if (length(cran_to_install) > 0) {
    message("Installing from CRAN: ", paste(cran_to_install, collapse = ", "))
    install.packages(cran_to_install)
  }

  message("Installation complete!")
  invisible(NULL)
}
```

---

## Testing Commands

After each phase, run:

```r
# Build package
devtools::document()
devtools::load_all()

# Check
devtools::check()

# BiocCheck
BiocCheck::BiocCheck(".")

# Specific function tests
# Test without package installed
remove.packages("enrichR")
try(runEnrichR(sce, features, "test"))  # Should error gracefully

# Test with package
install.packages("enrichR")
runEnrichR(sce, features, "test")  # Should work
```

---

## Summary

**Total files to modify:** ~25 R files + DESCRIPTION
**New files to create:** 1 (R/checkDependencies.R)
**Estimated time:** 8-12 hours of focused work
**Testing time:** 4-6 hours

---

## Priority Order

1. **HIGH PRIORITY (Do First):**
   - DESCRIPTION changes
   - R/singleCellTK.R (Shiny)
   - R/checkDependencies.R (helper functions)

2. **MEDIUM PRIORITY:**
   - Workflow methods (enrichR, VAM, batch correction, etc.)
   - Example data (already mostly done)

3. **LOWER PRIORITY:**
   - Plotting enhancements
   - Import/export utilities
   - Test-only packages

---

## Notes

- Use consistent error message format across all functions
- Always use `call. = FALSE` in stop() to avoid confusing stack traces
- Test each function both with and without the optional package
- Update roxygen documentation to mention required packages
- Consider adding a startup message listing installed optional packages
