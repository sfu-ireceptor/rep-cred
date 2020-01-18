library(shiny)
dir <- system.file('shiny-app', package = 'repcred')
setwd(dir)
shiny::shinyAppDir('.')