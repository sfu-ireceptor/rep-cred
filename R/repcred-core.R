#' Start the shiny app 
#' @export
repcredWeb <- function(appDir=system.file("shiny-app", 
                                          package = "repcred"), 
                            port=3838,...) {
    if (appDir == "") {
        stop("Could not find app dir.", call. = FALSE)
    }
    shiny::runApp(appDir, port=port, display.mode = "normal", launch.browser = T,...)
}


#' Generate Repertoire Credibility report
#' 
#' This funcion reads the repertoire file specified by \code{rep}
#' and runs a set of sets to evaluate the credibility of the repertoire.
#' 
#' @param  rep Path to the repertoire file.
#' @return Path to the credibility report. 
#' 
#' @examples
#' 
#' rep_file <- system.file(package="repcred", "extdata", "ExampleDb.tsv")
#' repcred_report(rep_file, tempdir())
#' @export
repcred_report <- function(rep, outdir=NULL,genome_file,sumrep) {
    
    if (file.exists(rep)) {
        if (is.null(outdir)) {
            outdir <- dirname(rep)
        }
    } else {
        stop(rep, "doesn't exist.")
    }
    
    tryCatch(
        {
            report_path <- render_report(rep, outdir,genome_file,sumrep)
        },
        error = function(e) {
            stop(safeError(e))
        }
    )
    report_path
}


#' Get percentage color
#' 
#' 
getPercColor <- function(total_num,single_val){
    perc = (single_val/total_num)*100
    color="green"
    if(perc > 25){
        color="red"
    }
    if(perc >10 & perc < 25){
        color="orange"
    }
    return(color)
}


getNormalSeqNumColor <- function(total_num,normal_num){
    perc = (normal_num/total_num)*100
    color="green"
    if(perc<70){
        color="orange"
    }
    if(perc<30){
        color="red"
    }
    return(color)
}

getCoreStats <- function(data){
    data = na.omit(data)
    min <- range(data)[1]
    max <- range(data)[2]
    mean <- mean(data)
    median <- median(data)
    standard_dev <- sd(data)
    perc5_quant <- quantile(data,probs=c(0.05,0.95))[1]
    perc95_quant <- quantile(data,probs=c(0.05,0.95))[2]
    vals <-data.table(min=as.double(min),max=as.double(max),mean=as.double(mean),median= as.double(median), percentile_5 = as.double(perc5_quant),percentile_95=as.double(perc95_quant), standard_dev = as.double(standard_dev)) 
    return(vals)
}

#' Render credibility report
#' 
#' @param rep Path to repertoire 
#' @param outdir Directory where the report will be generated
render_report <- function(rep, outdir,genome,sumrep) {
    path = "../rstudio/templates/project/project_files/"
    if (!dir.exists(outdir)) {
        dir.create(outdir, recursive = T)
    }

    outdir <- normalizePath(outdir)

    # Create project in outdir
    invisible(repcred_project(outdir))
    
    setwd("../rstudio/templates/project/project_files/")
    
    
    # render
    book <- bookdown::render_book(
        input = ".",
        output_format='bookdown::gitbook',
        config_file ="_bookdown.yml",
        clean=FALSE,
        new_session=FALSE, clean_envir=FALSE,
        params=list("rep"=rep, outdir=outdir,"genome_file"=genome,full_or_basic=sumrep))

    book
}


#' Create a Repertoire Credibility Project
#' 
#' From RStudio, use the New Project wizard: File > New Project >
#' New Directory > then select  Repertoire Credibility Project
#' to create the skeleton of a Repertoire Credibility Project
#' @param  path path to the directorye where the project will be created
repcred_project <- function(path,...) {
    skeleton_dir <- file.path(system.file(package="repcred"),"rstudio", "templates", "project", "project_files")
    project_dir <- path
    dir.create(project_dir, recursive = TRUE, showWarnings = FALSE)
    project_files <- list.files(skeleton_dir,full.names = T)
    file.copy(project_files, project_dir, recursive=TRUE)
} 