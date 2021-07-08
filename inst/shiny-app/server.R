server <- function(input, output) {
   
   dataValues <- reactiveValues(
      repcred_report_path=NULL
   )
   
   
   
   observeEvent(input$go, {
      output$openResultsBtn <- renderUI({
      
      #req(input$file1)
      withProgress(
         tryCatch(
            {
               dataValues$repcred_report_path <- repcred_report(input$file1$datapath)
            },
            error = function(e) {
               stop(safeError(e))
            }
         ),
         message="Analyzing repertoire..."
      )

      if (!is.null(dataValues$repcred_report_path)) {
         
         shiny::addResourcePath(basename(dirname(dataValues$repcred_report_path)),dirname(dataValues$repcred_report_path))
         actionButton(inputId='openResultsBtn',
                      label= 'Open analysis results',
                      icon = icon("link"),
                      style="color: #fff; background-color: #f39c12; border-color: #f39c12",
                      onclick =paste0("window.open('",file.path(".",basename(dirname(dataValues$repcred_report_path)),basename(dataValues$repcred_report_path)),"', '_blank')")
         )
      }
   })
      })
   
   
}