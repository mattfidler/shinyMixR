# The widget scripts are set-up to include at least a function that defines the UI using
# the tagList function. Furthermore specific server functions could be included. In general
# these functions typically has one or multiple of the following arguments (any other specific
# arguments are documented above the function itself):
# - projlst; project object with model information
# - inp; list with input elements from the shiny application (available in server as 'input')
# - session; the session object passed to the function given to shinyServer
# naming of the UI function is done by postfixing UI to the name of the widget
# naming of server function is done using camelCase to have the same style as the shiny functions
#------------------------------------------ runUI ------------------------------------------
#' @export
runUI <- function() {
  tagList(
    selectInput("runLst","Model(s)",names(proj_obj)[names(proj_obj)!="meta"],multiple=TRUE,selectize = TRUE),
    actionButton("runMdl", "Run Model(s)",icon=icon("play")),
    actionButton("showIt", "Show progress",icon=icon("spinner")),
    br(),br(),
    verbatimTextOutput("progrTxt"),
    tags$head(tags$style("#progrTxt{overflow-y:scroll; max-height: 600px;}"))
  )
}
#------------------------------------------ runMod ------------------------------------------
#' @export
# Function to run one or multiple models async (to avoid freezing of app)
# templog: location where the temporary log files or progress files are stored
runMod <- function(projlst,inp,session,templog="./shinyMixR/temp"){
  unlink(list.files(templog,pattern="run.*prog\\.txt$",full.names = TRUE))
  if(!is.null(inp$runLst)) lapply(inp$runLst,function(mods) run_nmx(mods,projlst))
}
#------------------------------------------ modProgr ------------------------------------------
#' @export
# Function to read in and show the temporary log file for one or multiple runs
# templog: location where the temporary log files or progress files are stored
modProgr <- function(templog="./shinyMixR/temp"){
  progFn   <- list.files(templog,pattern="prog\\.txt$",full.names = TRUE)
  progFnr  <- unlist(lapply(progFn,function(x) c(paste0("\n ***************",x,"***************"),readLines(x))))
  cat(progFnr,sep="\n")
}
