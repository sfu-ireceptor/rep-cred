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
             titlePanel("Repcred"),
             # Input
             fileInput("file1", "Choose TSV File",
                       multiple = FALSE,
                       accept = c("text/tab-separated-values",
                                  ".tsv", "text/plain")),
            #Genome file upload
            
            checkboxInput("input_chk", "Upload", value = FALSE ),
            
            
            #test
            
            
            
            
            
            
            #Checkbox for tests    
            checkboxGroupInput("rb", "Choose which tests to run:",
                       choiceNames = list("SumRep" , "Basic Checks" , "All Checks"),
                       choiceValues = list(
                          "sumrep", "simple checks", "all"
           )),
           
           actionButton("go", "Test Repertoire"),
             
            # Output
            uiOutput("openResultsBtn")
      )
   ),
   
   
   
)

