# Define UI
options(shiny.maxRequestSize = 0)
ui <- fluidPage(
   
   tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "repcred.css")
   ),
   
   # Sidebar layout
   fluidRow(
      id="div-main",
      column(12,
             align="center",
             # App title
             titlePanel("repcred"),
             # Input
             fileInput("file1", "Choose TSV File",
                       multiple = FALSE,
                       accept = c("text/tab-separated-values",
                                  ".tsv", "text/plain")),
            # Output
            uiOutput("openResultsBtn")
      )
   )
)