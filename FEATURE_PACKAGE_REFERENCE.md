# Feature-Package Reference Guide

Quick lookup for which packages enable which singleCellTK features.

---

## Quick Command Reference

```r
# Install by category (recommended):
singleCellTK::installOptionalDeps("category_name")

# Available categories:
# "shiny", "batch", "doublet", "pathway", "reports"
# "examples", "trajectory", "import_export", "plotting"
# "annotation", "qc", "all"
```

---

## Function-to-Package Lookup

Use this table to quickly find what package enables a specific function.

| Function | Required Package(s) | Install Command |
|----------|-------------------|-----------------|
| **GUI Functions** |
| `singleCellTK()` | shiny, shinyjs, DT, etc. | `installOptionalDeps("shiny")` |
| **Pathway Analysis** |
| `runEnrichR()` | enrichR | `installOptionalDeps("pathway")` |
| `runVAM()` | VAM | `installOptionalDeps("pathway")` |
| `importGeneSetsFromMSigDB()` | msigdbr | `installOptionalDeps("pathway")` |
| `runGSVA()` | ✅ Core (always available) | - |
| **Batch Correction** |
| `runFastMNN()` | batchelor | `installOptionalDeps("batch")` |
| `runMNNCorrect()` | batchelor | `installOptionalDeps("batch")` |
| `runSCMerge()` | scMerge | `installOptionalDeps("batch")` |
| `runComBatSeq()` | sva | `installOptionalDeps("batch")` |
| `runZINBWaVE()` | zinbwave | `installOptionalDeps("batch")` |
| `runHarmony()` | harmony | `BiocManager::install("harmony")` or `installOptionalDeps("batch")` |
| `runLimmaBC()` | ✅ Core (always available) | - |
| **Doublet Detection** |
| `runDoubletFinder()` | ROCR, KernSmooth, fields | `installOptionalDeps("doublet")` |
| `runCxds()` | scds | `installOptionalDeps("doublet")` |
| `runBcds()` | scds | `installOptionalDeps("doublet")` |
| `runCxdsBcdsHybrid()` | scds | `installOptionalDeps("doublet")` |
| `runScDblFinder()` | scDblFinder | `installOptionalDeps("doublet")` |
| **Cell Type Annotation** |
| `runSingleR()` | SingleR, celldex | `installOptionalDeps("annotation")` |
| **QC Methods** |
| `runSoupX()` | SoupX | `installOptionalDeps("qc")` |
| `runDecontX()` | celda | `installOptionalDeps("qc")` |
| `runPerCellQC()` | ✅ Core (always available) | - |
| `runDropletQC()` | ✅ Core (always available) | - |
| **Trajectory Analysis** |
| `runTSCAN()` | TSCAN | `installOptionalDeps("trajectory")` |
| `plotTSCAN*()` | TSCAN | `installOptionalDeps("trajectory")` |
| **Data Import** |
| `importCellRanger*()` | ✅ Core (always available) | - |
| `importSTARsolo()` | ✅ Core (always available) | - |
| `importAlevin()` | tximport | `installOptionalDeps("import_export")` |
| `importExampleData()` | TENxPBMCData or scRNAseq | `installOptionalDeps("examples")` |
| **Data Export** |
| `exportSCE()` | ✅ Core (always available) | - |
| `exportSCEtoAnnData()` | zellkonverter, anndata | `installOptionalDeps("import_export")` |
| **Reports** |
| `reportCellQC()` | rmarkdown | `installOptionalDeps("reports")` |
| `reportDropletQC()` | rmarkdown | `installOptionalDeps("reports")` |
| `reportDiffExp()` | rmarkdown | `installOptionalDeps("reports")` |
| All `report*()` functions | rmarkdown | `installOptionalDeps("reports")` |

---

## Feature-to-Package Mapping

### 🎨 Interactive GUI

**Features:**
- Full Shiny web interface
- Point-and-click analysis
- Interactive data tables
- Color pickers and widgets

**Required Packages:**
- shiny
- shinyjs
- shinyalert
- shinycssloaders
- colourpicker
- DT

**Install:**
```r
singleCellTK::installOptionalDeps("shiny")
```

---

### 🔬 Batch Correction

**Features:**
- FastMNN integration
- MNN Correct
- scMerge
- ComBat-Seq
- ZINB-WaVE batch correction

**Required Packages:**
- batchelor (FastMNN, MNN)
- scMerge
- sva (ComBat-Seq)
- zinbwave

**Install:**
```r
singleCellTK::installOptionalDeps("batch")
```

**Note:** Harmony and Limma batch correction remain in core package.

---

### 👥 Doublet Detection

**Features:**
- DoubletFinder method
- CXDS method
- BCDS method
- Hybrid CXDS-BCDS
- scDblFinder method

**Required Packages:**
- ROCR, KernSmooth, fields (for DoubletFinder)
- scds (for CXDS, BCDS, Hybrid)
- scDblFinder

**Install:**
```r
singleCellTK::installOptionalDeps("doublet")
```

**Note:** Scrublet (via Scanpy) has separate requirements.

---

### 🧬 Pathway & Gene Set Analysis

**Features:**
- Online enrichment via enrichR
- VAM gene set scoring
- MSigDB gene set import

**Required Packages:**
- enrichR
- VAM
- msigdbr

**Install:**
```r
singleCellTK::installOptionalDeps("pathway")
```

**Note:** GSVA is in core package and always available.

---

### 🏷️ Cell Type Annotation

**Features:**
- Automated annotation via SingleR
- Built-in reference datasets (celldex)
- Reference-based cell typing

**Required Packages:**
- SingleR
- celldex (for built-in references)

**Install:**
```r
singleCellTK::installOptionalDeps("annotation")
```

---

### ✅ Additional QC Methods

**Features:**
- SoupX ambient RNA removal
- DecontX contamination removal (celda)

**Required Packages:**
- SoupX
- celda

**Install:**
```r
singleCellTK::installOptionalDeps("qc")
```

**Note:** Core QC metrics (runPerCellQC, runDropletQC) are always available.

---

### 📈 Trajectory Analysis

**Features:**
- TSCAN pseudotime inference
- Trajectory plotting
- Lineage analysis

**Required Packages:**
- TSCAN
- TrajectoryUtils

**Install:**
```r
singleCellTK::installOptionalDeps("trajectory")
```

---

### 📊 Example Datasets

**Features:**
- Load PBMC datasets (3k, 4k, 6k, 8k, 33k, 68k)
- Load published scRNA-seq data
- Practice datasets for learning

**Required Packages:**
- TENxPBMCData
- scRNAseq
- AnnotationHub
- ExperimentHub
- ensembldb

**Install:**
```r
singleCellTK::installOptionalDeps("examples")
```

---

### 📥 Import/Export

**Features:**
- Alevin data import
- AnnData export for Scanpy/Python
- Special format conversion

**Required Packages:**
- tximport (for Alevin)
- zellkonverter (for AnnData)
- anndata (for AnnData)
- R.utils (for compression)

**Install:**
```r
singleCellTK::installOptionalDeps("import_export")
```

**Note:** Most import formats (CellRanger, STARsolo, etc.) are in core.

---

### 📊 Enhanced Plotting

**Features:**
- Interactive plotly visualizations
- Enhanced heatmap colors
- Advanced plot layouts

**Required Packages:**
- plotly
- ggplotify
- circlize
- gridExtra

**Install:**
```r
singleCellTK::installOptionalDeps("plotting")
```

**Note:** All basic plots (ggplot2) are in core package.

---

### 📄 HTML Reports

**Features:**
- Comprehensive HTML reports
- Reproducible analysis documentation
- Shareable results

**Required Packages:**
- rmarkdown
- yaml

**Install:**
```r
singleCellTK::installOptionalDeps("reports")
```

---

## Core Package Features (Always Available)

### ✅ No Additional Installation Required

**Data Import:**
- CellRanger (v2, v3)
- STARsolo
- BUStools
- Optimus
- DropEst
- From files (matrix, h5)

**Quality Control:**
- Per-cell QC metrics
- Per-gene QC metrics
- Droplet QC
- Outlier detection
- Filtering

**Normalization:**
- Log normalization
- CPM
- scran normalization
- Scaling

**Dimensionality Reduction:**
- PCA
- t-SNE (Rtsne)
- UMAP (via scater)

**Clustering:**
- k-means
- Hierarchical
- Graph-based (Seurat, scran)

**Differential Expression:**
- limma
- DESeq2
- MAST
- Wilcoxon
- ANOVA

**Visualization:**
- All ggplot2-based plots
- Heatmaps (ComplexHeatmap)
- Scatter plots
- Violin plots
- Bar plots
- Density plots

**Pathway Analysis:**
- GSVA
- Gene set import from GMT

**Batch Correction:**
- Limma batch correction
- Harmony (if installed)

**Data Structures:**
- SingleCellExperiment manipulation
- Data subsetting
- Combining datasets
- Metadata management

---

## Package Categories Summary

| Category | Packages | Install Time | Size |
|----------|----------|--------------|------|
| **Core** | 40 packages | ~15 min | ~150 MB |
| **shiny** | 6 packages | ~2 min | ~20 MB |
| **batch** | 4 packages | ~5 min | ~30 MB |
| **doublet** | 5 packages | ~3 min | ~20 MB |
| **pathway** | 3 packages | ~2 min | ~15 MB |
| **annotation** | 2 packages | ~3 min | ~25 MB |
| **qc** | 2 packages | ~2 min | ~15 MB |
| **trajectory** | 2 packages | ~2 min | ~15 MB |
| **examples** | 5 packages | ~5 min | ~40 MB |
| **import_export** | 4 packages | ~3 min | ~20 MB |
| **plotting** | 4 packages | ~2 min | ~10 MB |
| **reports** | 2 packages | ~1 min | ~5 MB |
| **ALL optional** | 45 packages | ~20 min | ~150 MB |
| **TOTAL (all)** | 85 packages | ~35 min | ~300 MB |

*Times and sizes are approximate and vary by system*

---

## Workflow-Based Recommendations

### Minimal QC Workflow

**What you need:**
- Core package ✅
- Doublet detection: `installOptionalDeps("doublet")`

**Total:** ~18 minutes, ~170 MB

---

### Integration Workflow

**What you need:**
- Core package ✅
- Batch correction: `installOptionalDeps("batch")`
- QC methods: `installOptionalDeps("qc")`
- Doublet detection: `installOptionalDeps("doublet")`

**Total:** ~25 minutes, ~215 MB

---

### Cell Type Analysis Workflow

**What you need:**
- Core package ✅
- Annotation: `installOptionalDeps("annotation")`
- Pathway: `installOptionalDeps("pathway")`

**Total:** ~22 minutes, ~190 MB

---

### Comprehensive Analysis Workflow

**What you need:**
- Everything: `installOptionalDeps("all")`

**Total:** ~35 minutes, ~300 MB

---

### Teaching/Workshop Setup

**What you need:**
- Core package ✅
- GUI: `installOptionalDeps("shiny")`
- Examples: `installOptionalDeps("examples")`
- Reports: `installOptionalDeps("reports")`

**Total:** ~23 minutes, ~215 MB

---

## Quick Troubleshooting

### Error: "Package 'X' is required"

**Solution:** The error message tells you exactly what to install!

```r
# Error shows:
Error: The enrichR package is required for this function.
Install with: BiocManager::install('enrichR')
Or use: singleCellTK::installOptionalDeps('pathway')

# Do what it says:
singleCellTK::installOptionalDeps('pathway')
```

---

### Check if a Package is Available

```r
# Returns TRUE if installed, FALSE otherwise
requireNamespace("enrichR", quietly = TRUE)

# Or check all optional packages for a category
# (after running installOptionalDeps)
```

---

### List All Installed Packages

```r
# See everything installed
installed.packages()[, "Package"]

# Check specific package
"enrichR" %in% rownames(installed.packages())
```

---

## Manual Installation

If you prefer to install packages individually:

### Bioconductor Packages

```r
BiocManager::install("packagename")

# Examples:
BiocManager::install("enrichR")
BiocManager::install("scds")
BiocManager::install("SingleR")
```

### CRAN Packages

```r
install.packages("packagename")

# Examples:
install.packages("shiny")
install.packages("ROCR")
install.packages("plotly")
```

---

## Related Documentation

- **INSTALLATION_GUIDE.md** - Detailed installation instructions
- **USER_MIGRATION_GUIDE.md** - Upgrading from previous versions
- **DEPENDENCY_FEATURE_MAP.md** - Complete technical reference

---

## Summary

### Core Philosophy

**Core Package:**
- Essential functionality that most users need
- Fast installation
- Minimal dependencies

**Optional Packages:**
- Specialized methods
- Install on demand
- Use what you need

### Remember

- ✅ Error messages tell you what to install
- ✅ installOptionalDeps() makes it easy
- ✅ Install by category or individually
- ✅ No functionality is lost, just optional

---

**Last updated:** 2025-11-14
**For:** singleCellTK v2.18.0+
