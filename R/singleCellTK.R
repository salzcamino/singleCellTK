#' Run the single cell analysis app
#'
#' Use this function to run the single cell analysis app.
#'
#' @param inSCE Input \linkS4class{SingleCellExperiment} object.
#' @param includeVersion Include the version number in the SCTK header. The
#' default is TRUE.
#' @param theme The bootswatch theme to use for the singleCellTK UI. The default
#' is 'flatly'.
#'
#' @import Biobase DelayedArray
#' @details
#' The Shiny GUI requires additional packages that are optional dependencies.
#' These will be automatically checked when launching the GUI.
#'
#' @return The shiny app will open
#' @export
#' @examples
#' \dontrun{
#' #Upload data through the app
#' singleCellTK()
#'
#' # Load the app with a SingleCellExperiment object
#' data("mouseBrainSubsetSCE")
#' singleCellTK(mouseBrainSubsetSCE)
#' }
singleCellTK <- function(inSCE=NULL, includeVersion=TRUE, theme='yeti') {
  # Check for Shiny dependencies
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("The Shiny GUI requires additional packages. ",
         "Install with: install.packages(c('shiny', 'shinyjs', ",
         "'shinyalert', 'shinycssloaders', 'colourpicker', 'DT'))\n",
         "Or use the helper: singleCellTK::installOptionalDeps('shiny')",
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
