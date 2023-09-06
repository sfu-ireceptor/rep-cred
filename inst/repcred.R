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
#   -h  Display help.

# Imports
suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library("repcred"))

# Defaults

REP <- NULL
OUTDIR <- tempdir()
DOWN <- TRUE

# Define commmandline arguments
opt_list <- list(make_option(c("-r", "--rep"), dest="REP", default=REP,
                             help="Repertoire file, in AIRR (TSV) format."),
                 make_option(c("-d", "--down"), dest="DOWN", default=DOWN,
                             help="Downsample."),
                 make_option(c("-o", "--outdir"), dest="OUTDIR", default=OUTDIR,
                             help=paste("Output directory. Will be created if it does not exist.",
                                        "\n\t\tDefaults to the current working directory."))
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

opt$OUTDIR <- normalizePath(opt$OUTDIR)
dir.create(opt$OUTDIR, recursive = T)

message("\nRunning repcred")
message("|- Repertoire:\n", normalizePath(opt$REP))
message("|- Downsample:\n", opt$DOWN)
message("|- Output dir:\n", normalizePath(opt$OUTDIR),"\n")

sink(file(file.path(opt$OUTDIR,"message.log"),"wt"), type="message")
sink(file(file.path(opt$OUTDIR,"output.log"),"wt"), type="output")

tryCatch(
    report <- render_report(rep=opt$REP, outdir=opt$OUTDIR, downsample = opt$DOWN),
    error = function(e) {
        stop(safeError(e))
    }
)

report