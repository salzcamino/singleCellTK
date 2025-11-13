# singleCellTK Dependency Analysis Report

## Executive Summary

The singleCellTK package contains **77 active R files** that collectively import **85 distinct dependencies**. The analysis reveals:

- **19 Core Dependencies** (used in 5+ files) - essential to the package's functionality
- **59 Specific Dependencies** (used in 1-2 files) - mostly optional functionality
- **Strong candidates for Suggests:** 18 heavy dependencies currently in Imports that are only used for specific analysis methods

---

## Functional Grouping & Dependencies

### 1. IMPORT FUNCTIONS (12 files)
**Purpose:** Loading data from various upstream formats

**Key Dependencies:**
- Core: `S4Vectors` (11 files), `SingleCellExperiment` (9), `SummarizedExperiment` (9), `DelayedArray` (7)
- Specific: `tximport`, `Matrix`, `data.table`, `plyr`
- Optional: `GSEABase`, `msigdbr`, `ensembldb`, `AnnotationHub`, `ExperimentHub`, `scRNAseq`, `TENxPBMCData`

**Analysis:** Import functions are heavily dependent on core Bioconductor classes. Several data source-specific imports could be moved to Suggests (e.g., `tximport` for Alevin, `ensembldb` for annotation).

---

### 2. QUALITY CONTROL (6 files)
**Purpose:** Cell/sample quality assessment, empty droplet detection, ambient RNA

**Key Dependencies:**
- Core: `S4Vectors` (4 files), `SummarizedExperiment` (3), `scater` (2)
- Specific: `DropletUtils` (2 files), `BiocParallel` (2)
- Heavy: Used in QC assessment but minimal

**Unique Candidates:**
- `DropletUtils` - ONLY in QC functions (droplet-based workflows)

---

### 3. DOUBLET DETECTION (4 files)
**Purpose:** Detecting doublets via multiple methods

**Key Dependencies:**
- Core: `S4Vectors` (3 files), `SummarizedExperiment` (3), `withr` (3)
- Heavy Tools: `scDblFinder` (1 file only), `scds` (1 file), `KernSmooth`, `ROCR`, `fields` (for doubleFinder)

**Analysis:** Each doublet detection method is ISOLATED in its own file. These are perfect candidates for optional dependencies:
- `scDblFinder` - only in scDblFinder_doubletDetection.R
- `scds` - only in scds_doubletdetection.R
- `KernSmooth`, `ROCR`, `fields` - only in doubleFinder_doubletDetection.R

---

### 4. NORMALIZATION (3 files)
**Purpose:** Data normalization/transformation

**Key Dependencies:**
- Core: `scater` (3 files - used for logNormCounts, CPM)
- Minor: `BiocParallel`, `withr`

**Analysis:** Scater is heavily used. These 3 files are lightweight and focused.

---

### 5. BATCH CORRECTION (1 file)
**Purpose:** Batch effect removal/integration

**Key Dependencies:**
- Heavy Tools: `batchelor`, `limma`, `sva`, `scMerge`, `zinbwave`, `reticulate` (for Python methods)
- Core: `S4Vectors`, `SummarizedExperiment`, `SingleCellExperiment`

**Analysis:** CRITICAL - Single `runBatchCorrection.R` file is a "kitchen sink" containing:
- limma (ComBatSeq)
- sva (surrogate variables)
- batchelor (MNN-based methods)
- scMerge (fastMNN)
- zinbwave (ZINB-WAVE)
- reticulate (Python methods like Harmony, BBKNN, Scanorama)

**STRONG CANDIDATE for splitting:** This file could be split into smaller modules, with individual methods as optional.

---

### 6. DIMENSIONALITY REDUCTION (5 files)
**Purpose:** PCA, UMAP, t-SNE for visualization

**Key Dependencies:**
- Core: `SingleCellExperiment` (3 files), `scater` (2), `withr` (3)
- Method-specific: `Rtsne` (only in runTSNE.R), `Seurat` (only in runDimReduce.R)
- Python: `reticulate`, `zellkonverter` (scanpy integration)

**Analysis:** Well-structured with method-specific dependencies isolated. `Rtsne` only for t-SNE.

---

### 7. FEATURE SELECTION (2 files)
**Purpose:** Variable gene selection

**Key Dependencies:**
- `scran` (1 file), `stats` (1 file)

**Analysis:** Minimal and focused. Well-separated functions.

---

### 8. CLUSTERING (1 file)
**Purpose:** Graph-based and partition clustering

**Key Dependencies:**
- `scran` (for SNN graphs)
- `igraph` (for clustering algorithms)
- `BiocParallel` (parallelization)

---

### 9. DIFFERENTIAL EXPRESSION (3 files)
**Purpose:** DE analysis, marker detection, visualization

**Key Dependencies:**
- Heavy Tools: `DESeq2` (1 file), `MAST` (2 files), `limma` (1 file)
- Analysis Dependencies: `data.table`, `scran`
- Visualization: `ggplot2`, `ggrepel`, `ggplotify`

**Analysis:** Each DE method is well-isolated:
- `runDEAnalysis.R` - contains limma, DESeq2, Wilcox, ANOVA
- `plotDEAnalysis.R` - visualization (uses MAST, celda)

**CANDIDATE for splitting:** Methods within `runDEAnalysis.R` could be separated (limma vs DESeq2 vs Wilcox).

---

### 10. CELL TYPE LABELING (1 file)
**Purpose:** Automatic cell type annotation

**Key Dependencies:**
- Heavy: `SingleR` (ONLY in runSingleR.R), `celldex` (reference data)
- Data: `scRNAseq`

**Analysis:** Perfect isolation. `SingleR` is ONLY in this file - ideal for Suggests.

---

### 11. PATHWAY ANALYSIS (5 files)
**Purpose:** Pathway/module enrichment, signature scoring

**Key Dependencies:**
- Heavy Tools: `enrichR` (1 file), `GSVA` (1 file), `VAM` (1 file)
- Data: `msigdbr`, `GSEABase`
- Core: `S4Vectors` (5 files)

**Analysis:** Well-isolated functional modules:
- `enrichRSCE.R` - enrichR online DB queries
- `runGSVA.R` - GSVA scoring
- `runVAM.R` - VAM module analysis
- `importGeneSets.R` - gene set loading

---

### 12. VISUALIZATION (12 files - plotting)
**Purpose:** Various data visualization functions

**Key Dependencies:**
- Core: `ggplot2` (8 files), `SingleCellExperiment` (7), `S4Vectors` (4), `SummarizedExperiment` (4)
- Specialized: `ComplexHeatmap`, `circlize`, `ggrepel`, `ggplotify`, `gridExtra`, `cowplot`

**Analysis:** Most visualization is modular and well-organized by plot type.

---

### 13. TRAJECTORY ANALYSIS (1 file)
**Purpose:** Pseudotime/trajectory inference

**Key Dependencies:**
- Heavy: `TSCAN`, `TrajectoryUtils` (ONLY in runTSCAN.R)
- Plotting: `ggplot2`, `cowplot`, `ggrepel`, `circlize`
- Analysis: `scater`, `scran`, `scuttle`

**Analysis:** `TSCAN` is ONLY in this file - perfect candidate for Suggests.

---

### 14. SEURAT INTEGRATION (1 file)
**Purpose:** Seurat workflow integration

**Key Dependencies:**
- Heavy: `Seurat` (ONLY in seuratFunctions.R)
- Supporting: `ggplot2`, `cowplot`, `plotly`, `stringr`

**Analysis:** All Seurat integration in one file. Could be moved to Suggests with appropriate wrapper checks.

---

### 15. SCANPY INTEGRATION (2 files)
**Purpose:** Python/Scanpy method integration

**Key Dependencies:**
- `reticulate` (2 files), `zellkonverter` (2 files)
- Supporting: `S4Vectors`, `SummarizedExperiment`

---

### 16. OTHER/UTILITIES (33 files)
**Purpose:** Data manipulation, export, utilities, report generation

**Key Dependencies:**
- Core: `SummarizedExperiment` (16), `SingleCellExperiment` (15), `S4Vectors` (13)
- Supporting: `Matrix`, `data.table`, `dplyr`, `ggplot2`
- Heavy but isolated: `SoupX` (only in runSoupX.R), `celda` (in multiple DE-related functions)

---

## CORE DEPENDENCIES (Used in 5+ files)

These are truly essential and should remain in Imports:

1. **S4Vectors** - 43 files (fundamental Bioconductor classes)
2. **SummarizedExperiment** - 41 files (core SCE parent class)
3. **SingleCellExperiment** - 39 files (primary data structure)
4. **stats** - 18 files (statistical functions, widely used)
5. **utils** - 18 files (utility functions, widely used)
6. **ggplot2** - 12 files (visualization standard)
7. **methods** - 12 files (S4 class system)
8. **DelayedArray** - 10 files (memory-efficient matrices)
9. **withr** - 10 files (context management)
10. **scater** - 8 files (single-cell QC/normalization)
11. **data.table** - 8 files (data manipulation)
12. **reticulate** - 8 files (Python integration)
13. **Matrix** - 7 files (sparse matrix support)
14. **BiocParallel** - 6 files (parallelization)
15. **scran** - 6 files (single-cell statistics)
16. **cowplot** - 5 files (ggplot2 extensions)
17. **dplyr** - 5 files (data manipulation)
18. **Seurat** - 5 files (Seurat integration)
19. **stringr** - 5 files (string manipulation)

---

## CANDIDATES FOR MOVING TO Suggests

### Tier 1: EXTREMELY ISOLATED (used in 1 file only)

**Doublet Detection Methods:**
- `scDblFinder` - 1 file (4 KB)
- `scds` - 1 file (15 KB)
- `KernSmooth` - 1 file (doubletFinder)
- `ROCR` - 1 file (doubletFinder)
- `fields` - 1 file (doubletFinder)

**Pathway/Enrichment:**
- `enrichR` - 1 file (7 KB)
- `VAM` - 1 file (5 KB)
- `GSVA` - 1 file

**Cell Type Annotation:**
- `SingleR` - 1 file (7 KB)
- `celldex` - 1 file (reference data only)

**Trajectory:**
- `TSCAN` - 1 file (41 KB)
- `TrajectoryUtils` - 1 file

**Ambient RNA:**
- `SoupX` - 1 file (39 KB)

**Data Import:**
- `tximport` - 1 file (Alevin-specific)
- `AnnotationHub`, `ExperimentHub`, `TENxPBMCData` - example data only
- `ensembldb`, `msigdbr`, `scRNAseq` - data/annotation lookup

---

### Tier 2: TWO-FILE USAGE (could be optional)

**DE Analysis:**
- `DESeq2` - 1 file (32 KB) - runDEAnalysis.R
- `MAST` - 2 files (specialized DE method)
- `limma` - 2 files (used in batch correction + DE)

**Batch Correction Heavy Tools:**
- `batchelor` - 1 file (within runBatchCorrection.R)
- `scMerge` - 1 file (within runBatchCorrection.R)
- `zinbwave` - 1 file (within runBatchCorrection.R)
- `sva` - 1 file (within runBatchCorrection.R)

**Doublet Detection:**
- `reticulate` - 8 files (but Python module loading is lazy)

**Data Import:**
- `plyr` - 2 files (older, dplyr preferred)

**Visualization Supporting:**
- `ComplexHeatmap` - 2 files
- `DropletUtils` - 2 files (droplet-based QC only)
- `plotly` - 2 files (interactive plotting)
- `metap` - 1 file (Seurat functions)

---

### Tier 3: SPECIALTY/OPTIONAL (could be conditional)

- `colourpicker`, `DT`, `shinyjs`, `shinyalert`, `shinycssloaders` - Shiny UI only
- `rmarkdown` - report generation only
- `rlang`, `tibble`, `tidyr`, `yaml` - utility/support libraries
- `ape`, `cluster`, `colorspace`, `ggtree`, `gridExtra` - specialized visualizations
- `R.utils` - text file export utility
- `matrixStats` - basic stats (rarely used)
- `DelayedMatrixStats` - 1 file (computeZScore.R)
- `multtest` - 1 file (DownsampleMatrix.R)

---

## ARCHITECTURAL ISSUES & RECOMMENDATIONS

### Issue 1: runBatchCorrection.R - "Kitchen Sink" File
**Problem:** Single 41KB file contains 8+ heavy dependencies (limma, sva, batchelor, scMerge, zinbwave, reticulate + Python modules)

**Recommendation:** Split into method-specific modules:
```
runBatchCorrection.R (wrapper)
  ├── runBatchCorrection_limma.R (ComBatSeq)
  ├── runBatchCorrection_sva.R (ComBat + SVA)
  ├── runBatchCorrection_mnn.R (batchelor, scMerge methods)
  ├── runBatchCorrection_zinbwave.R (ZINB-WAVE)
  └── runBatchCorrection_python.R (Harmony, BBKNN, Scanorama via reticulate)
```
Move heavy dependencies to Suggests with version checks in functions.

---

### Issue 2: Doublet Detection Not Modular
**Problem:** Four separate files but still loading dependencies for ALL methods at package load time

**Current:**
- doubletFinder_doubletDetection.R
- scDblFinder_doubletDetection.R
- scds_doubletdetection.R
- scrublet_doubletDetection.R

**Recommendation:** Move all to Suggests; add lazy loading:
```r
runDoubletDetection <- function(method = c("doubletFinder", "scDblFinder", "scds", "scrublet"), ...) {
  if (!requireNamespace(method_to_pkg[[method]], quietly=TRUE)) {
    stop("Package ", method_to_pkg[[method]], " required for ", method)
  }
  # dispatch to method
}
```

---

### Issue 3: Heavy Visualization Libraries
**Current:** All loaded even if user only makes simple plots

**Candidates to move to Suggests:**
- `ComplexHeatmap` (only 2 files) - load on-demand
- `plotly` (interactive plotting) - load on-demand
- `ggplotify` (ggplot conversion) - load on-demand
- `circlize` (circular plots) - load on-demand for trajectory plots

---

### Issue 4: Conditional Features (Python Integration)
**Problem:** `reticulate` in Imports but many Python modules are optional and require separate installation

**Current:** 8 files import reticulate but use lazy loading (good!)

**Recommendation:** Keep reticulate in Imports (it's lightweight) but move heavy Python-dependent packages:
- `scanpy` - Python package (users must install via conda/pip)
- `harmony`, `scanorama`, `bbknn` - Python packages (users must install)
- `scrublet` - Python package (used via reticulate)

---

### Issue 5: DE Analysis Methods Not Separated
**Problem:** `runDEAnalysis.R` contains multiple heavy dependencies (DESeq2, MAST, limma)

**Recommendation:** 
```
runDEAnalysis.R (wrapper)
  ├── .runDEAnalysis_limma() - uses limma
  ├── .runDEAnalysis_deseq2() - uses DESeq2
  ├── .runDEAnalysis_mast() - uses MAST
  ├── .runDEAnalysis_wilcox() - uses base stats
  └── .runDEAnalysis_anova() - uses base stats
```

Move DESeq2, MAST, limma to Suggests with checks.

---

## SUGGESTED DEPENDENCY REORGANIZATION

### Current State
- **Imports:** 84 packages (heavy load at startup)
- **Suggests:** 15 packages

### Proposed State
- **Imports:** ~35-40 packages (core only)
- **Suggests:** 55-60 packages (optional/specialized)

### Minimum Imports (Core)
```r
Depends:
  R (>= 4.0),
  SummarizedExperiment,
  SingleCellExperiment,
  DelayedArray,
  Biobase

Imports:
  # Core Bioconductor
  S4Vectors,
  BiocParallel,
  
  # Core visualization
  ggplot2,
  cowplot,
  grid,
  gridExtra,
  
  # Data manipulation
  dplyr,
  data.table,
  reshape2,
  tidyr,
  stringr,
  tibble,
  rlang,
  magrittr,
  
  # Utilities
  methods,
  utils,
  stats,
  tools,
  withr,
  
  # Single-cell analysis
  scater,
  scran,
  scuttle,
  DelayedMatrixStats,
  
  # Python integration
  reticulate,
  zellkonverter,
  
  # Shiny UI
  shiny,
  shinyjs,
  shinyalert,
  shinycssloaders,
  
  # Supporting viz
  ggrepel,
  circlize,
  ComplexHeatmap,
  
  # Supporting analysis
  Matrix,
  matrixStats,
  igraph,
  cluster,
  
  # Data
  GSVAdata,
  DropletUtils,
  eds
```

### Move to Suggests
```r
Suggests:
  # Heavy DE/analysis
  DESeq2,
  MAST,
  limma,
  
  # Batch correction
  batchelor,
  scMerge,
  zinbwave,
  sva,
  
  # Doublet detection
  scDblFinder,
  scds,
  
  # Cell type annotation
  SingleR,
  celldex,
  
  # Enrichment
  enrichR,
  GSVA,
  VAM,
  
  # Trajectory
  TSCAN,
  TrajectoryUtils,
  
  # Ambient RNA
  SoupX,
  
  # Seurat integration
  Seurat,
  
  # Visualization specialized
  plotly,
  ggplotify,
  colorspace,
  colourpicker,
  DT,
  ggtree,
  ape,
  
  # Data import
  tximport,
  AnnotationHub,
  ExperimentHub,
  scRNAseq,
  TENxPBMCData,
  ensembldb,
  msigdbr,
  GSEABase,
  
  # Utilities
  plyr,
  R.utils,
  rmarkdown,
  metap,
  multtest,
  ROCR,
  KernSmooth,
  fields,
  Rtsne,
  
  # Testing/Documentation
  testthat,
  BiocStyle,
  knitr,
  lintr,
  spelling,
  kableExtra,
  
  # Optional UI
  shinyBS,
  shinyjqui,
  shinyWidgets,
  shinyFiles,
  shinythemes,
  
  # Other
  BiocGenerics,
  RColorBrewer,
  fastmap,
  harmony,
  SeuratObject,
  optparse
```

---

## IMMEDIATE ACTIONS

1. **Profile Usage** - Add instrumentation to track which methods are actually used in real workflows
2. **Create Feature Flags** - Add .onLoad checks for optional dependencies
3. **Split Large Files** - Break up runBatchCorrection.R, runDEAnalysis.R
4. **Add Convenience Wrappers** - For commonly paired operations
5. **Update Tests** - Ensure optional dependencies don't break package load
6. **Create Installation Profiles:**
   - `lite`: Core only (~30 packages)
   - `standard`: Core + common methods (~50 packages)
   - `full`: Everything (current)

---

## IMPACT ASSESSMENT

### Benefits of Proposed Changes
- **Faster Package Installation:** Fewer dependencies to install
- **Smaller Memory Footprint:** Lazy loading of analysis methods
- **Easier Maintenance:** Clear dependency boundaries
- **Better Modularity:** Users can install only needed methods
- **Clearer User Experience:** Helpful error messages for missing optional packages

### Risks & Mitigation
- **User Confusion:** Mitigate with clear documentation
- **Broken Workflows:** Mitigate with comprehensive error messages
- **Testing Complexity:** Mitigate with CI matrix testing optional deps

