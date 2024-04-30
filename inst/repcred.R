#!/usr/bin/env Rscript
# Credibility of a repertoire
#
# Author:  Susanna Marquez
# Date:    2019.12.27
#
# Arguments:
#   -r  Repertoire file, in AIRR (TSV) format.
#   -o  Output directory. Will be created if it does not exist.
#       Defaults to tempdir().
#   -f  Output format: html, pdf, all
#   -h  Display help.

# Imports
suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library("repcred"))

# Defaults

REP <- NULL
OUTDIR <- tempdir()
DOWN <- TRUE
GERM <- NULL
FORMAT <- "html"

# Define commmandline arguments
opt_list <- list(make_option(c("-r", "--rep"), dest="REP", default=REP,
                             help="Repertoire file, in AIRR (TSV) format."),
                 make_option(c("-d", "--down"), dest="DOWN", default=DOWN,
                             help="Downsample."),
                 make_option(c("-g", "--germline"), dest="GERM", default=GERM,
                             help="Comma separated germline reference files in fasta format."),
                 make_option(c("-o", "--outdir"), dest="OUTDIR", default=OUTDIR,
                             help=paste("Output directory. Will be created if it does not exist.",
                                        "\n\t\tDefaults to the current working directory.")),
                 make_option(c("-f", "--format"), dest="FORMAT", default=FORMAT,
                             help="Output format: html, pdf, all")
)
# Parse arguments
opt <- parse_args(OptionParser(option_list=opt_list))

# Check input file
if (!("REP" %in% names(opt))) {
    stop("You must provide Repertoire data with using the -r option.")
} else {
    if (!(file.exists(opt$REP))) {
        stop(paste("File ", opt$REP, " doesn't exist." ))
    } else {
        opt$REP <- normalizePath(opt$REP)
    }
}

# Check reference germline
if ("GERM" %in% names(opt)) {
    opt$GERM <- strsplit(opt$GERM, ",")[[1]]
    opt$GERM <- sapply(opt$GERM, function(x) {
        if (!(file.exists(x))) {
            stop(paste("File ", x, " doesn't exist." ))
        } else {
            normalizePath(x)
        }
    }, USE.NAMES = F)
}

# Check format
if (!(any(opt$FORMAT %in% c("html", "pdf", "all"))) | length(opt$FORMAT)>1) {
    stop("Output format (-f/--format) must be one of: html, pdf, all")
} 

opt$OUTDIR <- normalizePath(opt$OUTDIR)
dir.create(opt$OUTDIR, recursive = T)

message("\nRunning repcred")
message("|- Repertoire:\n",  paste("| ", normalizePath(opt$REP)))
message("|- Reference germline(s):\n", paste("| ",opt$GERM, collapse="\n"))
message("|- Downsample:\n",  paste("| ", opt$DOWN))
message("|- Output dir:\n",  paste("| ", normalizePath(opt$OUTDIR)))
message("|- Output format:\n",  paste("| ", opt$FORMAT,"\n"))

sink(file(file.path(opt$OUTDIR,"message.log"),"wt"), type="message")
sink(file(file.path(opt$OUTDIR,"output.log"),"wt"), type="output")

tryCatch(
    report <- render_report(rep=opt$REP, outdir=opt$OUTDIR, genome = opt$GERM, downsample = opt$DOWN, format=opt$FORMAT),
    error = function(e) {
        stop(safeError(e))
    }
)

report