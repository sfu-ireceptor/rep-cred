server <- function(input, output) {
   
   original_help_text = "Repcred is an R program that allows you to see visually statistics and information about your repertoire."
   output$help_info <- renderText({paste("<h2>Repcred</h2>\n",original_help_text)})
   
   
   dataValues <- reactiveValues(
      repcred_report_path=NULL
   )
   


   observe({
      
      val= input$input_chk
      
      if(val==TRUE){
       output$condInput <- renderUI({ fileInput("genome", "Choose germline reference FASTA File",
                                              multiple = FALSE,
                                               accept = c("text/tab-separated-values",".fasta",".fna",".ffn",".frn",".fa","text/plain"))
      })  
      }
      
      if(val==FALSE){
         output$condInput <- renderUI({})  
      }
      
      
   })
   
   help_text="The repertoire file should contain the speficied rows as set out by the AIRR guidelines.Please be aware some stats will be unable to be run if there is missing data in some columns. This is mainly the sumrep stats , if there are specific stats you need makesure the related columns that are required are filled."
   help_text2 = "Many of the statistics can be run without a genome file but the genome file does allow missing genes to be pin pointed and gene usage to be analysed."
   
   observeEvent(input$help, {
      output$help_info <- renderText({paste("<h2>Repertoire File</h2>\n",help_text,"\n<h2> Genome File </h2>\n",help_text2)})
      
      
   })
   
   observeEvent(input$go, {
      output$openResultsBtn <- renderUI({
      
      #req(input$file1)
      withProgress(
         tryCatch(
            {
               dataValues$repcred_report_path <- repcred_report(input$file1$datapath,genome_file=input$genome$datapath,sumrep = input$sumrep)
               
            },
            error = function(e) {
               stop(e)
            }
         ),
         message="Analyzing repertoire..."
      )

      if (!is.null(dataValues$repcred_report_path)) {
         repcred::replaceChapterClassType(dataValues$repcred_report_path)
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