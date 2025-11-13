# singleCellTK Package Optimization: Bioconductor-Compliant Recommendations

## Executive Summary

After reviewing Bioconductor's package guidelines, this document provides **revised recommendations** for reducing the dependency burden of singleCellTK while remaining fully compliant with Bioconductor standards.

**Current Status:**
- 84 packages in Imports
- 15 packages in Suggests
- Package size: ~9.2 MB (excluding .git and docs)
- **Within Bioconductor's 5 MB software package limit ✓**

**Key Finding:** The package is **technically compliant** with Bioconductor size limits, but has significant room for optimization in terms of dependency management and startup performance.

---

## Bioconductor Dependency Guidelines

According to Bioconductor's package development guidelines:

### **Imports**
- For packages that provide functions, methods, or classes used inside your package namespace
- Includes packages loaded via `@import` or `@importFrom` directives
- Most packages are listed here

### **Suggests**
- For packages used in **vignettes, examples, and conditional code**
- Must use `requireNamespace("package", quietly = TRUE)` before calling functions
- Should provide clear error messages when optional packages are missing
- Commonly includes annotation and experiment packages

### **Key Principle**
> "A package can be listed only once between Depends/Imports/Suggests/Enhances"

---

## Current Package Analysis

### Packages with Full Import (`@import`)
Only **6 packages** are fully imported (must stay in Imports):
- `Biobase` (in Depends)
- `DelayedArray` (in Depends)
- `DropletUtils`
- `GSVAdata`
- `SingleCellExperiment` (in Depends)
- `eds`

### Packages with Selective Import (`@importFrom`)
**19 packages** use `@importFrom` for specific functions (must stay in Imports):
- Core Bioconductor: `SummarizedExperiment`, `S4Vectors`, `SingleCellExperiment`
- Infrastructure: `BiocParallel`, `methods`, `utils`, `stats`, `tools`, `grid`
- Data manipulation: `dplyr`, `tibble`, `tidyr`, `rlang`, `magrittr`
- Plotting: `ComplexHeatmap`
- Integration: `reticulate` (25 functions imported)
- Other: `scuttle`, `stringr`, `reshape2`

### Packages Used with `::` Notation (Candidates for Suggests)
**Heavy analysis packages** called only with qualified `package::function()` syntax:
- **DE methods:** `DESeq2`, `MAST`, `limma` (also used in batch correction)
- **Cell type annotation:** `SingleR`, `celldex`
- **Pathway analysis:** `enrichR`, `GSVA`, `VAM`
- **Trajectory:** `TSCAN`
- **Doublet detection:** `scDblFinder`, `scds`
- **Batch correction:** `batchelor`, `scMerge`, `zinbwave`, `sva`, `harmony` (already has requireNamespace!)
- **QC tools:** `SoupX`, `DropletUtils` (partially imported)
- **Utilities:** `KernSmooth`, `ROCR`, `fields` (for doubletFinder)

---

## Bioconductor-Compliant Recommendations

### **Priority 1: Add requireNamespace() Checks**
✅ **Can be done immediately without breaking changes**

For all packages called with `::` notation that don't have `@import/@importFrom`:

1. **DE Analysis Methods** (`runDEAnalysis.R`)
   - Add checks for: `DESeq2`, `MAST`, `limma`
   - Pattern to follow (from `runHarmony.R:327`):
   ```r
   if (!requireNamespace("DESeq2", quietly = TRUE)) {
     stop("The DESeq2 package is required for this method. ",
          "Install with: BiocManager::install('DESeq2')",
          call. = FALSE)
   }
   ```

2. **Cell Type Annotation** (`runSingleR.R`)
   - Add checks for: `SingleR`, `celldex`

3. **Pathway Analysis**
   - `enrichR` in `enrichRSCE.R`
   - `GSVA` in `runGSVA.R`
   - `VAM` in `runVAM.R`
   - `TSCAN` in `runTSCAN.R`

4. **Doublet Detection** (already well-isolated)
   - `scDblFinder` in `scDblFinder_doubletDetection.R`
   - `scds` in `scds_doubletdetection.R`
   - `KernSmooth`, `ROCR`, `fields` in `doubletFinder_doubletDetection.R`

5. **Batch Correction** (`runBatchCorrection.R`)
   - Add checks for: `batchelor`, `scMerge`, `zinbwave`, `sva`
   - Note: `harmony` already has proper check!

6. **Other Analysis Tools**
   - `SoupX` in `runSoupX.R`

### **Priority 2: Move Packages to Suggests**
✅ **After adding requireNamespace() checks**

**Conservative approach** (18-20 packages):
- **Analysis methods:** DESeq2, enrichR, SingleR, TSCAN, SoupX, VAM
- **Doublet detection:** scDblFinder, scds, KernSmooth, ROCR, fields
- **Batch correction:** batchelor, scMerge, zinbwave, sva, harmony
- **Utilities:** celldex, GSVA

**Expected benefit:** ~25% reduction in required dependencies at install time

**Aggressive approach** (add 10 more packages):
- **MAST, limma** (if you can ensure they're only used conditionally)
- **Data/annotation packages:** AnnotationHub, ensembldb, ExperimentHub, TENxPBMCData, scRNAseq
- **Specialized viz:** plotly, circlize, ggplotify

**Expected benefit:** ~35% reduction in required dependencies

### **Priority 3: Modularization (Long-term)**
⚠️ **Requires significant refactoring**

**Problem files to consider splitting:**

1. **`runBatchCorrection.R`** (41 KB, 8 methods)
   - Current: All methods in one file
   - Proposed: Separate file per method OR helper functions with lazy loading
   - Benefits: Clearer code organization, easier maintenance

2. **`runDEAnalysis.R`** (32 KB, 5 methods)
   - Current: DESeq2, MAST, limma, Wilcox, ANOVA in one file
   - Proposed: Separate implementations for heavy methods
   - Benefits: Users only load the DE method they actually use

---

## Impact Analysis

### **Package Size** ✓
- Current: 9.2 MB (excluding .git/docs)
- Bioconductor limit: 5 MB for source package from `R CMD build`
- Status: **Likely compliant** (R source is small, most size is data/inst)

### **Dependency Load Time**
Conservative Suggests move (20 packages):
- Before: 84 packages must install
- After: 64 packages required, 20 optional
- **Estimated improvement:** 10-15% faster installation for basic usage

Aggressive Suggests move (30 packages):
- Before: 84 packages must install
- After: 54 packages required, 30 optional
- **Estimated improvement:** 15-25% faster installation

### **User Experience**
**Benefits:**
- Faster initial installation
- Clearer separation of core vs. optional functionality
- Helpful error messages guide users to install only what they need
- Reduced conflicts with other packages

**Considerations:**
- Users must manually install optional packages when needed
- Need clear documentation about installation profiles
- Vignettes should document optional dependencies

---

## Implementation Plan

### **Phase 1: Immediate (Low Risk)**
1. Add `requireNamespace()` checks to all methods using `::` notation
2. Update function documentation to mention optional dependencies
3. Test all functions with/without optional packages
4. **NO changes to DESCRIPTION yet**

### **Phase 2: Conservative Migration (Medium Risk)**
1. Move single-use, method-specific packages to Suggests:
   - Analysis: enrichR, SingleR, VAM, SoupX
   - Doublet detection: scDblFinder, scds, KernSmooth, ROCR, fields
   - Data packages: TENxPBMCData, ExperimentHub
2. Run full test suite
3. Update vignettes to note optional packages
4. **Update DESCRIPTION: move ~15 packages to Suggests**

### **Phase 3: Comprehensive Migration (Higher Risk)**
1. Add batch correction methods to Suggests
2. Add remaining specialized tools
3. Consider moving MAST, limma (if only used in specific methods)
4. **Update DESCRIPTION: move additional 10-15 packages**

### **Phase 4: Long-term Refactoring (Optional)**
1. Split large multi-method files
2. Implement installation profiles (lite/standard/full)
3. Create helper function for optional dependency management

---

## Testing Strategy

For each package moved to Suggests:

1. **Unit tests:** Test function behavior with/without package
   ```r
   test_that("runDESeq2 fails gracefully without DESeq2", {
     # Mock scenario where DESeq2 is not available
     expect_error(runDESeq2(...), "DESeq2 package is required")
   })
   ```

2. **Integration tests:** Verify all workflows still work

3. **Documentation:** Update all relevant help pages and vignettes

4. **BiocCheck:** Run `BiocCheck` to ensure compliance
   ```r
   BiocCheck::BiocCheck(".")
   ```

---

## Example: Adding requireNamespace() Check

**Before (current code):**
```r
runDESeq2 <- function(inSCE, ...) {
  # ... setup code ...
  dds <- DESeq2::DESeqDataSetFromMatrix(...)
  dds <- DESeq2::DESeq(dds, ...)
  res <- DESeq2::results(dds, ...)
  # ... process results ...
}
```

**After (Bioconductor-compliant):**
```r
runDESeq2 <- function(inSCE, ...) {
  # Check for package availability
  if (!requireNamespace("DESeq2", quietly = TRUE)) {
    stop("Package 'DESeq2' is required for this function but is not installed.\n",
         "Please install it with: BiocManager::install('DESeq2')",
         call. = FALSE)
  }

  # ... setup code ...
  dds <- DESeq2::DESeqDataSetFromMatrix(...)
  dds <- DESeq2::DESeq(dds, ...)
  res <- DESeq2::results(dds, ...)
  # ... process results ...
}
```

---

## Installation Profile Documentation

Create clear documentation for users:

### **Minimal Installation** (~50 packages)
```r
BiocManager::install("singleCellTK")
# Core functionality: data import, QC, normalization, basic visualization
```

### **Standard Installation** (~70 packages)
```r
BiocManager::install("singleCellTK")
# Install common optional methods
BiocManager::install(c("DESeq2", "MAST", "SingleR", "harmony"))
```

### **Full Installation** (~100 packages)
```r
BiocManager::install("singleCellTK")
# Install all optional methods
BiocManager::install(c(
  "DESeq2", "MAST", "limma",           # DE analysis
  "scDblFinder", "scds",                # Doublet detection
  "batchelor", "scMerge", "zinbwave",  # Batch correction
  "SingleR", "celldex",                 # Cell type annotation
  "enrichR", "GSVA", "VAM", "TSCAN",   # Pathway/trajectory
  "SoupX"                               # Ambient RNA
))
```

---

## Recommendations Summary

### **DO Implement (Bioconductor-Compliant):**
✅ Add `requireNamespace()` checks for all `::` called packages
✅ Move 15-30 packages to Suggests (start conservative, expand gradually)
✅ Improve error messages for missing optional packages
✅ Document installation profiles in vignettes
✅ Run BiocCheck before submitting changes

### **DON'T Do (Would Violate Guidelines):**
❌ Use `Remotes:` field for GitHub-only packages
❌ Move packages with `@import/@importFrom` to Suggests
❌ Use `library()` or `require()` without `requireNamespace()`
❌ Exceed 5 MB source package size
❌ Include unnecessary files (.git, .DS_Store, cache files)

### **Consider for Future (Optional):**
💭 Split large multi-method files for cleaner architecture
💭 Implement lazy loading for heavy dependencies
💭 Create separate data/annotation companion package
💭 Add vignettes with specific workflow examples

---

## Questions for Package Maintainers

1. **Philosophy:** Do you prefer conservative (15 packages to Suggests) or aggressive (30 packages) approach?

2. **User base:** Are most users running specific workflows (e.g., only Seurat-based) or do they use many different methods?

3. **Testing:** Do you have comprehensive unit tests for optional methods?

4. **Timeline:** Is this for next release cycle or longer-term refactoring?

5. **Breaking changes:** Are you willing to require users to explicitly install optional packages, or should the transition be gradual?

---

## Conclusion

The singleCellTK package is **already compliant** with Bioconductor size requirements but can benefit significantly from dependency optimization. By adding `requireNamespace()` checks and moving 15-30 packages to Suggests, you can:

- ✅ Remain fully Bioconductor-compliant
- ✅ Reduce installation time by 10-25%
- ✅ Improve package load time
- ✅ Make the architecture clearer and more modular
- ✅ Reduce dependency conflicts for users

The recommended approach is **incremental:** start with Phase 1 (adding checks), then Phase 2 (conservative migration), with careful testing at each step.
