#' @export
repcredWeb <- function(appDir=system.file("shiny-app", 
                                          package = "repcred"), 
                            port=3838,...) {
    if (appDir == "") {
        stop("Could not find app dir.", call. = FALSE)
    }
    shiny::runApp(appDir, port=port, display.mode = "normal", launch.browser = T,...)
}

#' @export
repcred_report <- function(rep, outdir=NULL) {
    
    if (file.exists(rep)) {
        if (is.null(outdir)) {
            outdir <- dirname(rep)
        }
    } else {
        stop(rep, "doesn't exist.")
    }
    
    tryCatch(
        {
            report_path <- render_report(rep, outdir)
        },
        error = function(e) {
            stop(safeError(e))
        }
    )
    report_path
}

#' @export
render_report <- function(rep, outdir) {

    if (!dir.exists(outdir)) {
        dir.create(outdir, recursive = T)
    }

    outdir <- normalizePath(outdir)

    # Create project in outdir
    invisible(repcred_project(outdir))
    
    # render
    xfun::in_dir(
        outdir,
        book <- bookdown::render_book(
            "index.Rmd",
            output_format='bookdown::gitbook',
            config_file = "_bookdown.yml",
            clean=FALSE,
            new_session=FALSE, clean_envir=FALSE,
            params=list("rep"=rep, outdir=outdir))
    )
    book
}


#' Create a repcred project
#' From RStudio, use the New Project wizard: File > New Project >
#' New Directory > then select  Repertoire Credibility Project
repcred_project <- function(path,...) {
    skeleton_dir <- file.path(system.file(package="repcred"),"rstudio", "templates", "project", "project_files")
    project_dir <- path
    dir.create(project_dir, recursive = TRUE, showWarnings = FALSE)
    project_files <- list.files(skeleton_dir,full.names = T)
    file.copy(project_files, project_dir, recursive=TRUE)
} 