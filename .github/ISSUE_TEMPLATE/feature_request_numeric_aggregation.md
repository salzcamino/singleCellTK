---
name: Feature Request - Numeric Variable Aggregation in Heatmaps
about: Support aggregating numeric variables in plotSCEHeatmap
title: '[FEATURE] Add numeric variable aggregation support in plotSCEHeatmap'
labels: enhancement, visualization, upstream-dependency
assignees: ''
---

## Feature Request

### Summary
Add support for aggregating numeric variables (e.g., age, scores) when using `aggregateCol` parameter in `plotSCEHeatmap()`.

### Motivation
Currently, `plotSCEHeatmap()` with `aggregateCol` works well for categorical variables (cell types, conditions), but numeric metadata (age, quality scores, expression levels) are not properly aggregated.

**Use cases:**
- Aggregate cells by cell type AND show mean age per type
- Show median quality score per cluster
- Display average expression of marker genes per condition
- Combine categorical and numeric metadata in heatmap annotations

### Current Behavior

```r
# Aggregates cells by cellType (categorical)
plotSCEHeatmap(sce, aggregateCol = "cellType", ...)

# But if we have numeric variables in colData (age, score, etc.),
# they are not aggregated with customizable methods
```

**Current limitation:** Uses default aggregation which may not be appropriate for numeric variables.

### Proposed Solution

Add `aggregateNumeric` parameter to specify aggregation methods:

```r
plotSCEHeatmap(sce,
               aggregateCol = "cellType",
               aggregateNumeric = list(
                 age = "mean",
                 quality_score = "median",
                 doublet_score = "max"
               ),
               ...)
```

**Methods:**
- `"mean"`: Average value
- `"median"`: Median value
- `"sum"`: Total
- `"min"` / `"max"`: Min/max value
- `"sd"`: Standard deviation

### Technical Details

**Dependency Issue:**
This feature requires enhancement in the upstream `scuttle` package's `aggregateAcrossCells()` function. Current implementation:

```r
# Line 285-287 in R/plotSCEHeatmap.R
SCE <- aggregateAcrossCells(SCE, ids = colIDS,
                            use.assay.type = useData,
                            store.number = NULL, statistics = "mean")
```

The `scuttle::aggregateAcrossCells()` function handles assay aggregation well but has limited support for numeric colData aggregation.

**Options:**

**Option A: Contribute to scuttle (recommended)**
1. Propose enhancement to `scuttle::aggregateAcrossCells()`
2. Add `coldata.merge` or similar parameter
3. Wait for scuttle release
4. Integrate into singleCellTK

**Option B: Workaround in singleCellTK**
1. Aggregate assays with scuttle
2. Manually aggregate numeric colData after
3. More code but no upstream dependency

**Option C: Defer**
- Current workaround (lines 288-299) handles most cases
- Wait for user demand before implementing

### Example Usage

```r
# Example 1: Simple numeric aggregation
plotSCEHeatmap(sce,
               aggregateCol = c("cellType", "treatment"),
               aggregateNumeric = list(age = "mean"),
               ...)

# Example 2: Multiple numeric variables
plotSCEHeatmap(sce,
               aggregateCol = "cluster",
               aggregateNumeric = list(
                 age = "mean",
                 doublet_score = "max",
                 n_genes = "median"
               ),
               ...)
```

### Impact

**Files to modify:**
- `R/plotSCEHeatmap.R` (around line 281)
- Potentially upstream: scuttle package
- Documentation
- Tests

**Backward compatibility:**
- ✅ Fully backward compatible (new optional parameter)
- ✅ Default behavior unchanged
- ✅ No breaking changes

### Additional Context

This enhancement was identified during code quality review. Current NOTE comment:
```r
# NOTE: Future enhancement could support aggregating numeric variables
# via coldata.merge parameter in aggregate function
```

Reference: R/plotSCEHeatmap.R line 281

**Current workaround exists:** Lines 288-299 clean up duplicated colData variables, which partially addresses the issue for simple cases.

### Dependencies

- Potentially requires enhancement in: `scuttle::aggregateAcrossCells()`
- Alternative: Implement custom aggregation in singleCellTK

### Related Packages

- scuttle: https://bioconductor.org/packages/scuttle/
- Issue tracker: https://github.com/LTLA/scuttle/issues

### Priority

**Low priority** - Current workaround handles most common use cases (90%+). This would be a nice enhancement for advanced users.

### Implementation Checklist

If accepted (depending on approach):

**If Option A (upstream):**
- [ ] Open issue in scuttle repository
- [ ] Propose API design
- [ ] Wait for scuttle implementation
- [ ] Integrate into singleCellTK after release
- [ ] Add tests and documentation

**If Option B (workaround):**
- [ ] Add `aggregateNumeric` parameter
- [ ] Implement manual aggregation after `aggregateAcrossCells()`
- [ ] Support mean, median, sum, min, max, sd
- [ ] Handle edge cases (missing data, etc.)
- [ ] Add comprehensive tests
- [ ] Update documentation

**If Option C (defer):**
- [ ] Monitor user feedback
- [ ] Revisit if demand increases
- [ ] Document limitation clearly

### User Feedback Needed

Before implementing, gather feedback on:
1. Is this feature needed? (usage scenarios)
2. Which aggregation methods are most important?
3. Should this be in scuttle or singleCellTK?
4. What should the API look like?

