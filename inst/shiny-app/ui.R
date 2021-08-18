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
            
            checkboxInput("input_chk", "Upload genome file?", value = FALSE ),
            
            
            uiOutput("conditionalInput"),
            
            
            
            
            
            #Checkbox for tests    
            selectInput("rb", "Choose which tests to run:",
                       choices = list("SumRep" , "Basic Checks" , "All Checks"),
                       multiple = TRUE  )),
      
            #Checks for chimeric sequences : 
            selectInput("rb", "Choose which chimeric test you would like to run:",
                        choices = list("Basic chimera check", "Thorough Chimera check") ,
                        multiple = FALSE  )),
           
           actionButton("go", "Test Repertoire"),
             
            # Output
            uiOutput("openResultsBtn")
      )
   
   
   
   


