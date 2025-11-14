# Dependency Reduction Project - Documentation Index

This directory contains comprehensive documentation for reducing singleCellTK's dependencies from 84 to 37 imports (56% reduction).

---

## 📚 Documentation Files

### 1. **MIGRATION_SUMMARY.md** ⭐ START HERE
Quick reference guide with:
- Overview of changes
- Key action items
- Package categories
- Before/after examples
- Success metrics

**When to use:** Quick lookup, executive summary

---

### 2. **DEPENDENCY_MIGRATION_PLAN.md** 📋 DETAILED PLAN
Comprehensive migration plan with:
- Phase-by-phase implementation guide
- Specific code changes for each package
- Testing strategy
- Documentation requirements
- Timeline estimates
- Rollback plan

**When to use:** Implementation planning, detailed reference

---

### 3. **IMPLEMENTATION_CHECKLIST.md** ✅ ACTION ITEMS
File-by-file modification guide with:
- Exact code changes needed
- Line-by-line diff examples
- Complete new file (checkDependencies.R)
- Testing commands
- Priority ordering

**When to use:** During implementation, as you modify each file

---

### 4. **DEPENDENCY_FEATURE_MAP.md** 👥 USER GUIDE
User-facing documentation about:
- What features require which packages
- Installation strategies
- Quick reference tables
- Function-to-package mapping
- FAQs

**When to use:** Creating user documentation, answering user questions

---

### 5. **DEPENDENCY_REDUCTION_README.md** 📖 THIS FILE
Index and overview of all documentation

---

## 🎯 Quick Start Guide

### If you want to...

#### **Understand the big picture**
→ Read **MIGRATION_SUMMARY.md**

#### **Plan the implementation**
→ Read **DEPENDENCY_MIGRATION_PLAN.md**

#### **Start coding**
→ Use **IMPLEMENTATION_CHECKLIST.md**

#### **Write user documentation**
→ Reference **DEPENDENCY_FEATURE_MAP.md**

#### **See exact code changes**
→ Check **IMPLEMENTATION_CHECKLIST.md** sections

---

## 📊 Project Overview

### Goals
- ✅ Reduce required dependencies from 84 to 37 (56% reduction)
- ✅ Faster installation (70% faster for minimal use)
- ✅ Fewer dependency conflicts
- ✅ Modular installation (install only what you need)
- ✅ No loss of functionality (all features still available)

### Strategy
- Remove 2 completely unused packages
- Move 45 packages from Imports to Suggests
- Add conditional checks with helpful error messages
- Create helper function for easy installation
- Maintain backward compatibility

### Impact
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Imports | 84 | 37 | -56% |
| Minimal install time | 50 min | 15 min | -70% |
| Minimal install size | 350 MB | 150 MB | -57% |
| User flexibility | None | High | +++++ |

---

## 🔄 Implementation Workflow

```
1. READ: MIGRATION_SUMMARY.md
   ↓
2. REVIEW: DEPENDENCY_MIGRATION_PLAN.md
   ↓
3. CREATE: Feature branch
   ↓
4. IMPLEMENT: Using IMPLEMENTATION_CHECKLIST.md
   ↓
   Phase 1: DESCRIPTION + Core helpers
   ↓
   Phase 2: Workflow methods
   ↓
   Phase 3: Supporting features
   ↓
5. TEST: Each phase thoroughly
   ↓
6. DOCUMENT: Using DEPENDENCY_FEATURE_MAP.md
   ↓
7. REVIEW: All changes
   ↓
8. MERGE: To main branch
```

---

## 📦 Package Categories

### Removed (2)
- eds, GSVAdata

### Moved to Suggests (45)
Organized by category:
- **GUI:** shiny, shinyjs, shinyalert, shinycssloaders, colourpicker, DT (6)
- **Examples:** TENxPBMCData, scRNAseq, AnnotationHub, ExperimentHub, ensembldb (5)
- **Batch:** batchelor, scMerge, sva, zinbwave (4)
- **Doublet:** scds, scDblFinder, ROCR, KernSmooth, fields (5)
- **Pathway:** enrichR, VAM, msigdbr (3)
- **Annotation:** SingleR, celldex (2)
- **QC:** SoupX (1)
- **Trajectory:** TSCAN, TrajectoryUtils (2)
- **Workflow:** celda, zellkonverter (2)
- **Reports:** rmarkdown, yaml (2)
- **Import/Export:** tximport, R.utils (2)
- **Plotting:** plotly, ggplotify, circlize, gridExtra (4)
- **Testing:** ape, ggtree, cluster (3)
- **Python:** anndata (1)

### Remaining in Imports (37)
Core packages used across multiple features

---

## 🛠️ Key Components

### 1. Helper Function: `installOptionalDeps()`
```r
# Install by category
singleCellTK::installOptionalDeps("shiny")
singleCellTK::installOptionalDeps("batch")
singleCellTK::installOptionalDeps("all")
```

### 2. Consistent Error Messages
```r
if (!requireNamespace("package", quietly = TRUE)) {
  stop("The package package is required for this function. ",
       "Install with: BiocManager::install('package')",
       call. = FALSE)
}
```

### 3. Updated Function Documentation
```r
#' @details
#' This function requires the enrichR package.
#' Install with: \code{BiocManager::install('enrichR')}
```

---

## ✅ Testing Strategy

### Per Function
- [ ] Test without package → expect clear error
- [ ] Test with package → expect normal operation
- [ ] Verify error message helpful

### Overall
- [ ] R CMD check
- [ ] BiocCheck
- [ ] All unit tests pass
- [ ] Clean environment install test
- [ ] Workflow integration tests

---

## 📝 Documentation Checklist

- [ ] Update function documentation (@details)
- [ ] Update README.md (installation section)
- [ ] Update vignettes (note optional packages)
- [ ] Create user migration guide
- [ ] Update NEWS.md
- [ ] Update DESCRIPTION file properly

---

## 🎓 Key Concepts

### requireNamespace vs library
```r
# Good - check for availability
if (!requireNamespace("pkg", quietly = TRUE)) {
  stop("...")
}

# Bad - loads package even for check
if (!require("pkg")) {
  stop("...")
}
```

### Imports vs Suggests
- **Imports:** Required for package to work
- **Suggests:** Optional enhancements, specific features

### call. = FALSE
Always use in stop() to avoid confusing stack traces:
```r
stop("Message", call. = FALSE)  # Good
stop("Message")                  # Bad - shows call stack
```

---

## 🚀 Implementation Timeline

### Recommended Approach: Phased
**Week 1:**
- Days 1-2: Phase 1 (DESCRIPTION, core helpers)
- Days 3-4: Phase 2 (workflow methods)
- Day 5: Testing Phase 1-2

**Week 2:**
- Days 1-2: Phase 3 (supporting features)
- Days 3-4: Comprehensive testing
- Day 5: Documentation updates

**Week 3:**
- Days 1-2: Review & revisions
- Days 3-4: User testing
- Day 5: Final checks & merge

### Alternative: All at Once
**Total:** 10-14 days concentrated effort

---

## ⚠️ Potential Issues & Solutions

### Issue: User complaints about "missing package"
**Solution:** Clear error messages with install instructions

### Issue: Test failures
**Solution:** Each test should install optional deps it needs

### Issue: Vignette build failures
**Solution:** Add packages to VignetteBuilder or use eval=FALSE

### Issue: Examples fail on CRAN
**Solution:** Wrap examples in \dontrun{} or check package availability

---

## 🔍 Verification

After implementation, verify:
```r
# Check package loads
library(singleCellTK)

# Check core functions work
sce <- importExampleData("pbmc3k")  # Should fail with clear message
# Then install: BiocManager::install("TENxPBMCData")
sce <- importExampleData("pbmc3k")  # Should work

# Check error messages
try(runEnrichR(sce, genes, "test"))  # Should show helpful error

# Check helper
installOptionalDeps("pathway")  # Should install enrichR, VAM, msigdbr
```

---

## 📞 Support

### For Implementation Questions
- Refer to specific sections in DEPENDENCY_MIGRATION_PLAN.md
- Check IMPLEMENTATION_CHECKLIST.md for exact code

### For User Questions
- Use DEPENDENCY_FEATURE_MAP.md as reference
- Point users to installOptionalDeps() helper

### For Testing Issues
- See testing sections in DEPENDENCY_MIGRATION_PLAN.md
- Check phase-specific testing in IMPLEMENTATION_CHECKLIST.md

---

## 🎯 Success Criteria

Implementation complete when:
- [x] All 4 documentation files created
- [ ] DESCRIPTION file updated
- [ ] All 25+ R files modified with checks
- [ ] checkDependencies.R created
- [ ] R CMD check passes
- [ ] BiocCheck passes
- [ ] All tests pass
- [ ] User documentation updated
- [ ] Installation time improved >60%
- [ ] No loss of functionality

---

## 📈 Metrics to Track

Before and after:
1. **Installation time** (minimal config)
2. **Installation time** (full config)
3. **Download size** (minimal)
4. **Download size** (full)
5. **Number of dependency conflicts** (during updates)
6. **Build time**
7. **Test suite run time**
8. **Docker image size**

---

## 🔄 Maintenance

After merge:
1. **Monitor** GitHub issues for dependency problems
2. **Update** documentation if new optional packages added
3. **Review** annually if more packages can move to Suggests
4. **Consider** splitting into companion packages if grows too large

---

## 💡 Future Enhancements

Potential follow-ups:
1. Create separate `singleCellTK.gui` package for Shiny
2. Create `singleCellTK.workflows` for specific pipelines
3. Add `checkOptionalDeps()` to show what's installed
4. Startup message showing available features
5. Move Seurat to Suggests in future release
6. Create installation "profiles" (minimal, standard, full)

---

## 📚 Additional Resources

- [Writing R Extensions - Package Dependencies](https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Package-Dependencies)
- [R Packages Book - Dependencies](https://r-pkgs.org/dependencies.html)
- [Bioconductor Package Guidelines](https://bioconductor.org/developers/package-guidelines/)

---

## Summary

This dependency reduction project will:
- ✅ Make singleCellTK faster and easier to install
- ✅ Reduce dependency conflicts
- ✅ Give users flexibility in what they install
- ✅ Maintain all existing functionality
- ✅ Improve package maintainability

**Total effort:** 10-16 days
**Impact:** Major improvement in user experience

---

*Created: 2025-11-14*
*Status: Planning Complete - Ready for Implementation*
