---
name: Feature Request - DEG Plot Regulation Filter
about: Add ability to filter DEG plots by up/down regulation direction
title: '[FEATURE] Add regulation direction filter to plotDEGViolin and plotDEGRegression'
labels: enhancement, visualization
assignees: ''
---

## Feature Request

### Summary
Add the ability to filter differential expression gene (DEG) plots by regulation direction (up/down-regulated genes).

### Motivation
Currently, `plotDEGViolin()` and `plotDEGRegression()` display all significant DEGs together. Users often want to focus specifically on upregulated or downregulated genes for:
- Clearer visualization when many DEGs exist
- Pathway-specific analysis (e.g., activation vs. suppression pathways)
- Presentation purposes (showing specific gene sets)
- Reducing plot complexity with large gene sets

### Proposed Solution

Add a `regulation` parameter to both functions:

```r
plotDEGViolin(inSCE, useResult, regulation = c("all", "up", "down"), ...)
plotDEGRegression(inSCE, useResult, regulation = c("all", "up", "down"), ...)
```

**Implementation details:**
- `regulation = "all"` (default): Current behavior, show all significant genes
- `regulation = "up"`: Filter to genes with `Log2_FC > 0`
- `regulation = "down"`: Filter to genes with `Log2_FC < 0`
- Update plot title to indicate filtered view
- Throw informative error if no genes pass filter

### Example Usage

```r
# Current usage (unchanged)
plotDEGViolin(sce, "analysis1")

# New: Show only upregulated genes
plotDEGViolin(sce, "analysis1", regulation = "up")

# New: Show only downregulated genes
plotDEGViolin(sce, "analysis1", regulation = "down")
```

### Alternative Approaches Considered

**Option A: Faceted Plot (rejected)**
- Show up/down in separate panels automatically
- Pro: Complete view
- Con: Complex for large gene sets, harder to customize

**Option B: Return List (rejected)**
- Return separate plots for up/down
- Pro: Maximum flexibility
- Con: Breaking change to return type, inconsistent API

**Option C: Filter Parameter (recommended)**
- Simple parameter to filter genes
- Pro: Simple, backward compatible, user control
- Con: Users must make multiple calls for both views

### Impact

**Files to modify:**
- `R/plotDEAnalysis.R` (lines 67-152: plotDEGViolin)
- `R/plotDEAnalysis.R` (lines 185-292: plotDEGRegression)
- Documentation (add examples)
- Tests (test-plotDEAnalysis.R or similar)

**Backward compatibility:**
- ✅ Fully backward compatible (new parameter with default)
- ✅ No breaking changes
- ✅ Existing code works unchanged

### Additional Context

This enhancement was identified during code quality review. The functions currently have a NOTE comment indicating this as a future enhancement:
```r
# NOTE: Future enhancement could split plots by up/down regulation direction
```

Reference: R/plotDEAnalysis.R lines 70, 188

### Implementation Checklist

If accepted, implementation would include:
- [ ] Add `regulation` parameter to both functions
- [ ] Add parameter validation (`match.arg()`)
- [ ] Filter DEG table by Log2_FC direction
- [ ] Handle edge case: no genes after filtering (informative error)
- [ ] Update plot titles to reflect filter
- [ ] Add roxygen documentation for parameter
- [ ] Add examples to documentation
- [ ] Add unit tests for all three regulation values
- [ ] Add integration test with real DEG data
- [ ] Update vignettes if applicable

### Related Issues

None currently.

### Priority

**Nice to have** - Current functionality is complete. This is a quality-of-life enhancement.

