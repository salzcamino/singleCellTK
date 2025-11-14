# Dependency Migration Plan for singleCellTK

## Executive Summary

This plan outlines a systematic approach to reduce the number of imported dependencies in singleCellTK from **84 to approximately 37** (56% reduction) by moving 45 packages to `Suggests` and removing 2 unused packages.

**Benefits:**
- Faster installation (60-70% reduction in install time for minimal use cases)
- Fewer dependency conflicts during updates
- Smaller Docker images
- Clearer separation of core vs optional functionality
- Better user experience (install only what you need)

---

## Phase 1: Immediate Removals (2 packages)

### 1.1 Remove `GSVAdata`

**Status:** Unused in actual code

**Action:**
1. Remove from DESCRIPTION `Imports:`
2. Remove `@import GSVAdata` from `R/singleCellTK.R:11`

**Files to modify:**
- `DESCRIPTION` - Remove from line 67
- `R/singleCellTK.R` - Remove from line 11

**Testing:** Run full test suite; GSVAdata is not used in any function

---

### 1.2 Remove `eds`

**Status:** Unused dependency

**Action:**
1. Remove from DESCRIPTION `Imports:`

**Files to modify:**
- `DESCRIPTION` - Remove from line 104

**Testing:** Run full test suite; no actual usage found

---

## Phase 2: Move Shiny-Related Packages to Suggests (6 packages)

These packages are only needed for the interactive GUI, not for command-line usage.

### Packages to move:
- `shiny`
- `shinyjs`
- `shinyalert`
- `shinycssloaders`
- `colourpicker`
- `DT`

### 2.1 Update DESCRIPTION

Move from `Imports:` to `Suggests:` section

### 2.2 Update `R/singleCellTK.R`

**Current code (lines 24-32):**
```r
singleCellTK <- function(inSCE=NULL, includeVersion=TRUE, theme='yeti') {
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

**Updated code:**
```r
singleCellTK <- function(inSCE=NULL, includeVersion=TRUE, theme='yeti') {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("The Shiny GUI requires the 'shiny' package. ",
         "Install required packages with: ",
         "install.packages(c('shiny', 'shinyjs', 'shinyalert', ",
         "'shinycssloaders', 'colourpicker', 'DT'))",
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

**Files to modify:**
- `DESCRIPTION`
- `R/singleCellTK.R`

**Testing:**
- Test that command-line functions work without shiny installed
- Test that GUI launches properly when shiny packages are installed

---

## Phase 3: Move Example Data Packages to Suggests (5 packages)

These are only needed for loading demonstration datasets.

### Packages to move:
- `TENxPBMCData`
- `scRNAseq`
- `AnnotationHub`
- `ExperimentHub`
- `ensembldb`

### 3.1 Update DESCRIPTION

Move from `Imports:` to `Suggests:`

### 3.2 Update `R/importExampleData.R`

**Good news:** This file ALREADY has conditional checks! (lines 60-63, 87-89)

**Current pattern:**
```r
if(!("scRNAseq" %in% rownames(utils::installed.packages()))) {
  p <- paste0("Package 'scRNAseq' is not installed. Please install to load dataset '", dataset, "'.")
  stop(p)
}
```

**Recommended update to use modern pattern:**
```r
if (!requireNamespace("scRNAseq", quietly = TRUE)) {
  stop("Package 'scRNAseq' is required to load dataset '", dataset, "'. ",
       "Install with: BiocManager::install('scRNAseq')",
       call. = FALSE)
}
```

**Files to modify:**
- `DESCRIPTION`
- `R/importExampleData.R` (modernize checks - optional, current checks work)

**Testing:** Test each example dataset import with and without packages

---

## Phase 4: Move Optional Workflow Methods to Suggests (15 packages)

Each of these packages supports a specific optional analysis method.

### 4.1 Pathway/Gene Set Analysis (3 packages)

#### `enrichR`
- **Used in:** `R/enrichRSCE.R`
- **Function:** `runEnrichR()`

**Add to function start (after line 50):**
```r
if (!requireNamespace("enrichR", quietly = TRUE)) {
  stop("The enrichR package is required for this function. ",
       "Install with: BiocManager::install('enrichR')",
       call. = FALSE)
}
```

#### `VAM`
- **Used in:** `R/runVAM.R`
- **Function:** `runVAM()`

**Add to function start (after line 57):**
```r
if (!requireNamespace("VAM", quietly = TRUE)) {
  stop("The VAM package is required for this function. ",
       "Install with: BiocManager::install('VAM')",
       call. = FALSE)
}
```

#### `msigdbr`
- **Used in:** `R/importGeneSets.R`
- **Function:** `importGeneSetsFromMSigDB()`

**Action:** Add check at function start

---

### 4.2 Batch Correction Methods (4 packages)

#### `batchelor`
- **Used in:** `R/runBatchCorrection.R`
- **Functions:** `runFastMNN()`, `runMNNCorrect()`

**Add check to both functions:**
```r
if (!requireNamespace("batchelor", quietly = TRUE)) {
  stop("The batchelor package is required for this function. ",
       "Install with: BiocManager::install('batchelor')",
       call. = FALSE)
}
```

#### `scMerge`
- **Used in:** `R/runBatchCorrection.R`
- **Function:** `runSCMerge()`

**Add check:**
```r
if (!requireNamespace("scMerge", quietly = TRUE)) {
  stop("The scMerge package is required for this function. ",
       "Install with: BiocManager::install('scMerge')",
       call. = FALSE)
}
```

#### `sva`
- **Used in:** `R/runBatchCorrection.R`
- **Function:** `runComBatSeq()` (uses sva::ComBat_seq)

**Add check (after line 127):**
```r
if (!requireNamespace("sva", quietly = TRUE)) {
  stop("The sva package is required for ComBat-Seq batch correction. ",
       "Install with: BiocManager::install('sva')",
       call. = FALSE)
}
```

#### `zinbwave`
- **Used in:** `R/runBatchCorrection.R`
- **Function:** `runZINBWaVE()`

**Action:** Add check at function start

---

### 4.3 Cell Type Annotation (2 packages)

#### `SingleR`
- **Used in:** `R/runSingleR.R`
- **Function:** `runSingleR()`

**Add check:**
```r
if (!requireNamespace("SingleR", quietly = TRUE)) {
  stop("The SingleR package is required for this function. ",
       "Install with: BiocManager::install('SingleR')",
       call. = FALSE)
}
```

#### `celldex`
- **Used in:** `R/runSingleR.R`
- **Function:** Used for reference datasets

**Note:** Check is only needed if user requests built-in reference

**Add conditional check:**
```r
# When accessing celldex references
if (!requireNamespace("celldex", quietly = TRUE)) {
  stop("The celldex package is required for built-in reference datasets. ",
       "Install with: BiocManager::install('celldex')",
       call. = FALSE)
}
```

---

### 4.4 QC/Decontamination Methods (2 packages)

#### `SoupX`
- **Used in:** `R/runSoupX.R`
- **Function:** `runSoupX()`

**Add check:**
```r
if (!requireNamespace("SoupX", quietly = TRUE)) {
  stop("The SoupX package is required for this function. ",
       "Install with: BiocManager::install('SoupX')",
       call. = FALSE)
}
```

---

### 4.5 Doublet Detection Methods (2 packages)

#### `scds`
- **Used in:** `R/scds_doubletdetection.R`
- **Functions:** `runCxds()`, `runBcds()`, `runCxdsBcdsHybrid()`

**Add to each function:**
```r
if (!requireNamespace("scds", quietly = TRUE)) {
  stop("The scds package is required for this function. ",
       "Install with: BiocManager::install('scds')",
       call. = FALSE)
}
```

#### `scDblFinder`
- **Used in:** `R/scDblFinder_doubletDetection.R`
- **Function:** `runScDblFinder()`

**Add check:**
```r
if (!requireNamespace("scDblFinder", quietly = TRUE)) {
  stop("The scDblFinder package is required for this function. ",
       "Install with: BiocManager::install('scDblFinder')",
       call. = FALSE)
}
```

---

### 4.6 Trajectory Analysis (2 packages)

#### `TSCAN`
- **Used in:** `R/runTSCAN.R`
- **Functions:** Multiple TSCAN functions

**Add check:**
```r
if (!requireNamespace("TSCAN", quietly = TRUE)) {
  stop("The TSCAN package is required for trajectory analysis. ",
       "Install with: BiocManager::install('TSCAN')",
       call. = FALSE)
}
```

#### `TrajectoryUtils`
- **Used in:** `R/runTSCAN.R`
- **Automatically loaded with TSCAN**

**Action:** Move to Suggests; no separate check needed (dependency of TSCAN)

---

### 4.7 Workflow-Specific (2 packages)

#### `celda`
- **Used in:** `R/celda_decontX.R`, others
- **Functions:** `runDecontX()` and related

**Add check to decontX function:**
```r
if (!requireNamespace("celda", quietly = TRUE)) {
  stop("The celda package is required for this function. ",
       "Install with: BiocManager::install('celda')",
       call. = FALSE)
}
```

#### `zellkonverter`
- **Used in:** `R/scanpyFunctions.R`, `R/sce2adata.R`, `R/exportSCEtoAnndata.R`
- **Functions:** Scanpy workflow and AnnData export

**Add check to relevant functions:**
```r
if (!requireNamespace("zellkonverter", quietly = TRUE)) {
  stop("The zellkonverter package is required for Scanpy workflows and AnnData export. ",
       "Install with: BiocManager::install('zellkonverter')",
       call. = FALSE)
}
```

---

## Phase 5: DoubletFinder Dependencies to Suggests (3 packages)

These are ONLY used by DoubletFinder method.

### Packages:
- `ROCR`
- `KernSmooth`
- `fields`

### 5.1 Update `R/doubletFinder_doubletDetection.R`

**Add to `runDoubletFinder()` function start:**
```r
if (!requireNamespace("ROCR", quietly = TRUE) ||
    !requireNamespace("KernSmooth", quietly = TRUE) ||
    !requireNamespace("fields", quietly = TRUE)) {
  stop("DoubletFinder requires additional packages. ",
       "Install with: install.packages(c('ROCR', 'KernSmooth', 'fields'))",
       call. = FALSE)
}
```

**Files to modify:**
- `DESCRIPTION`
- `R/doubletFinder_doubletDetection.R`

---

## Phase 6: Report Generation to Suggests (2 packages)

### Packages:
- `rmarkdown`
- `yaml`

### 6.1 `rmarkdown`

- **Used in:** `R/htmlReports.R`
- **Functions:** All report generation functions

**Add to report functions (e.g., `reportCellQC()`, `reportDropletQC()`, etc.):**
```r
if (!requireNamespace("rmarkdown", quietly = TRUE)) {
  stop("HTML report generation requires the rmarkdown package. ",
       "Install with: install.packages('rmarkdown')",
       call. = FALSE)
}
```

### 6.2 `yaml`

- **Used in:** `R/sctkQCUtils.R`

**Add check where YAML writing occurs:**
```r
if (!requireNamespace("yaml", quietly = TRUE)) {
  stop("YAML export requires the yaml package. ",
       "Install with: install.packages('yaml')",
       call. = FALSE)
}
```

---

## Phase 7: Import/Export Specific Packages to Suggests (2 packages)

### 7.1 `tximport`

- **Used in:** `R/importAlevin.R`
- **Function:** `importAlevin()`

**Add check:**
```r
if (!requireNamespace("tximport", quietly = TRUE)) {
  stop("Importing Alevin data requires the tximport package. ",
       "Install with: BiocManager::install('tximport')",
       call. = FALSE)
}
```

### 7.2 `R.utils`

- **Used in:** `R/exportSCEtoTXT.R`
- **Function:** File compression in export

**Add check:**
```r
if (!requireNamespace("R.utils", quietly = TRUE)) {
  stop("Compression requires the R.utils package. ",
       "Install with: install.packages('R.utils')",
       call. = FALSE)
}
```

---

## Phase 8: Test-Only Dependencies to Suggests (3 packages)

### Packages:
- `ape`
- `ggtree`
- `cluster`

**Status:** These are ONLY used in `R/miscFunctions.R` in `.testFunctions()`

**Action:**
1. Move to `Suggests:`
2. Add note in `.testFunctions()` documentation that these packages are needed for testing

**Note:** `.testFunctions()` is an internal test function, so no user-facing error needed

---

## Phase 9: Plotting Enhancement Packages (Consider for Suggests)

### 9.1 `plotly` (2 files)

- **Used in:** `R/seuratFunctions.R`, `R/miscFunctions.R` (test only)
- **Real usage:** Only in Seurat interactive plots

**Add check in Seurat plotting functions:**
```r
if (!requireNamespace("plotly", quietly = TRUE)) {
  warning("The plotly package is recommended for interactive plots. ",
          "Falling back to static plots. ",
          "Install with: install.packages('plotly')")
  # Fall back to ggplot2
}
```

### 9.2 `ggplotify` (1 file)

- **Used in:** `R/plotDEAnalysis.R`

**Add check:**
```r
if (!requireNamespace("ggplotify", quietly = TRUE)) {
  stop("This plotting function requires ggplotify. ",
       "Install with: install.packages('ggplotify')",
       call. = FALSE)
}
```

### 9.3 `circlize` (2 real files)

- **Used in:** `R/runTSCAN.R`, `R/plotSCEHeatmap.R`
- **Purpose:** Color scale generation for heatmaps

**Add check where used:**
```r
if (!requireNamespace("circlize", quietly = TRUE)) {
  stop("This function requires circlize for color scales. ",
       "Install with: install.packages('circlize')",
       call. = FALSE)
}
```

### 9.4 `gridExtra` (1 file)

**Add check where used for grid arrangement**

---

## Phase 10: Optional Major Workflows (Consider Carefully)

### 10.1 `Seurat` (5 files) - **KEEP AS IMPORTS FOR NOW**

**Reasoning:**
- Used in 5 different files
- Major workflow that many users expect
- Consider in future release after user feedback

**Alternative approach:**
- Create separate package `singleCellTK.seurat` for Seurat workflow
- Keep minimal Seurat support in main package

### 10.2 `anndata` - Move to Suggests

- **Used for:** AnnData/Scanpy interoperability
- **Action:** Move to Suggests, add checks in anndata functions

---

## Phase 11: Create Helper Functions

### 11.1 Create `R/checkDependencies.R`

```r
#' Check if required packages are installed
#'
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

#' Create helper function to install optional dependencies
#' @export
installOptionalDeps <- function(category = c("all", "shiny", "batch",
                                              "doublet", "pathway",
                                              "reports", "examples")) {
  category <- match.arg(category)

  packages <- list(
    shiny = c("shiny", "shinyjs", "shinyalert", "shinycssloaders",
              "colourpicker", "DT"),
    batch = c("batchelor", "scMerge", "sva", "zinbwave"),
    doublet = c("scds", "scDblFinder", "ROCR", "KernSmooth", "fields"),
    pathway = c("enrichR", "VAM", "msigdbr"),
    reports = c("rmarkdown", "yaml"),
    examples = c("TENxPBMCData", "scRNAseq", "AnnotationHub",
                 "ExperimentHub", "ensembldb")
  )

  if (category == "all") {
    to_install <- unlist(packages, use.names = FALSE)
  } else {
    to_install <- packages[[category]]
  }

  message("Installing optional dependencies: ", paste(to_install, collapse = ", "))

  bioc_pkgs <- c("batchelor", "scMerge", "sva", "zinbwave", "scds",
                 "scDblFinder", "enrichR", "VAM", "TENxPBMCData",
                 "scRNAseq", "AnnotationHub", "ExperimentHub", "ensembldb")

  bioc_to_install <- intersect(to_install, bioc_pkgs)
  cran_to_install <- setdiff(to_install, bioc_pkgs)

  if (length(bioc_to_install) > 0) {
    if (!requireNamespace("BiocManager", quietly = TRUE)) {
      install.packages("BiocManager")
    }
    BiocManager::install(bioc_to_install)
  }

  if (length(cran_to_install) > 0) {
    install.packages(cran_to_install)
  }

  message("Installation complete!")
}
```

---

## Testing Strategy

### Unit Tests
1. Test each modified function WITHOUT optional package installed
   - Should fail gracefully with helpful error message
2. Test each modified function WITH optional package installed
   - Should work as before

### Integration Tests
1. Test complete workflows with minimal dependencies
2. Test complete workflows with all dependencies
3. Test that Shiny app only loads when shiny is available

### Installation Tests
1. Test fresh install on clean R environment
2. Measure installation time before/after
3. Test `installOptionalDeps()` helper function

### Documentation Tests
1. Update all function documentation to note optional dependencies
2. Update vignettes to mention package installation requirements
3. Update README with dependency information

---

## Implementation Checklist

### Pre-Implementation
- [ ] Create feature branch for dependency reduction
- [ ] Backup current DESCRIPTION file
- [ ] Create this migration plan document
- [ ] Set up test environment with clean R installation

### Phase 1: Removals
- [ ] Remove `GSVAdata` from DESCRIPTION
- [ ] Remove `@import GSVAdata` from singleCellTK.R
- [ ] Remove `eds` from DESCRIPTION
- [ ] Test build
- [ ] Run R CMD check

### Phase 2: Shiny Packages
- [ ] Move 6 packages to Suggests in DESCRIPTION
- [ ] Add check to singleCellTK() function
- [ ] Test GUI launch with packages
- [ ] Test that error message shows without packages
- [ ] Update singleCellTK() documentation

### Phase 3: Example Data
- [ ] Move 5 packages to Suggests
- [ ] Modernize checks in importExampleData.R (optional)
- [ ] Test each dataset import
- [ ] Update documentation

### Phase 4-9: Optional Methods
For each package:
- [ ] Move to Suggests in DESCRIPTION
- [ ] Add requireNamespace check to function(s)
- [ ] Test function without package (expect error)
- [ ] Test function with package (expect success)
- [ ] Update function documentation
- [ ] Add note about required package

### Phase 10: Helper Functions
- [ ] Create R/checkDependencies.R
- [ ] Add .checkRequiredPackages() helper
- [ ] Add installOptionalDeps() function
- [ ] Export installOptionalDeps()
- [ ] Document helper functions
- [ ] Add examples for installOptionalDeps()

### Testing
- [ ] Run full test suite
- [ ] Run R CMD check
- [ ] Run BiocCheck
- [ ] Test installation in clean environment
- [ ] Measure installation time improvement
- [ ] Test key workflows (QC, clustering, DE, batch correction)
- [ ] Test Shiny GUI

### Documentation
- [ ] Update README.md with dependency info
- [ ] Update vignettes mentioning optional packages
- [ ] Update NEWS.md with breaking changes
- [ ] Create migration guide for users
- [ ] Update function documentation (@importFrom → manual namespace)

### Final Steps
- [ ] Review all changes
- [ ] Update version number
- [ ] Create comprehensive commit message
- [ ] Push to feature branch
- [ ] Create pull request
- [ ] Request reviews from maintainers

---

## Migration Guide for Users

Create a user-facing document explaining:

1. **What changed:** Dependency structure is now modular
2. **Why:** Faster installs, fewer conflicts, clearer organization
3. **How to install:**
   - Minimal: `BiocManager::install("singleCellTK")` (core functions)
   - With GUI: `singleCellTK::installOptionalDeps("shiny")`
   - Full install: `singleCellTK::installOptionalDeps("all")`
4. **Error messages:** What they mean and how to resolve
5. **Workflow examples:** Show which packages needed for which analyses

---

## Expected Timeline

- **Phase 1-2:** 1 day (removals + Shiny)
- **Phase 3-9:** 3-4 days (optional methods with checks)
- **Phase 10:** 1 day (helper functions)
- **Testing:** 2-3 days (comprehensive testing)
- **Documentation:** 1-2 days
- **Review/revisions:** 2-3 days

**Total:** ~10-14 days for full implementation and testing

---

## Rollback Plan

If issues arise:
1. Keep original DESCRIPTION file backed up
2. Revert specific package moves if problems found
3. Can implement in stages (e.g., Shiny first, then optional methods)
4. Use feature flag approach for gradual rollout

---

## Future Considerations

1. **Seurat dependency:** Monitor usage; consider making optional in future release
2. **Split packages:** Consider creating companion packages (e.g., `singleCellTK.batch`, `singleCellTK.gui`)
3. **Vignette packages:** Some vignette-only packages could go to VignetteBuilder
4. **Lazy loading:** Consider lazy loading for some heavier optional packages

---

## Summary of Changes

### DESCRIPTION file changes:

**Remove from Imports (47 packages):**
- GSVAdata, eds (delete completely)
- shiny, shinyjs, shinyalert, shinycssloaders, colourpicker, DT
- TENxPBMCData, scRNAseq, AnnotationHub, ExperimentHub, ensembldb
- enrichR, VAM, msigdbr
- batchelor, scMerge, sva, zinbwave
- SingleR, celldex
- SoupX
- scds, scDblFinder
- ROCR, KernSmooth, fields
- TSCAN, TrajectoryUtils
- celda, zellkonverter
- ape, ggtree, cluster
- plotly, ggplotify, circlize, gridExtra
- rmarkdown, yaml
- tximport, R.utils
- anndata

**Keep in Imports (37 packages):**
Core functionality packages that are widely used across the package

**Add to Suggests:**
All 45 packages moved from Imports (excluding 2 deleted)

---

## Contact & Questions

For questions about this migration plan:
- Review implementation details in each phase
- Check function-specific modifications
- Consult helper function documentation
- Test in isolated environment before production
