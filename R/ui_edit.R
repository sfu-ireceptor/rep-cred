 addTrafficLighting <- function(vector_of_colours){
   css_file = file("results/repcred.css")
   
   div_main_css = "#div-main {
    position:fixed;
    top: calc(35%);
    left: calc(35%);
    }"
   
   shiny_notif_css = ".shiny-notification {
    position:fixed;
    top: calc(55%);
    left: calc(35%);
    width: 300px;
}"
   line_list <- vector("character" , length(vector_of_colours)+2)
   line_list[1] = div_main_css
   line_list[2] = shiny_notif_css
   i=1
   
   for(color in vector_of_colours){
    single_element_css = paste("li.chapter",as.character(i),"{",
                       "background:",as.character(color),";",
                       "}"
                       ,sep="")
    
    line_list[i+2] = single_element_css
    i=i+1
    
   }
   writeLines(line_list,css_file)
   close(css_file)
   
 }

#'
#'
#'
#' @export
replaceChapterClassType<-function(file_path){
  all_html_files <- list.files(gsub(" ", "", paste(getwd(),"/results/")),".html")
  for(single_file in all_html_files ){
    
  html_file=file(gsub(" ","",paste("results/",single_file)))
  file_data <- readLines(con = html_file,n=-1)
  i=73
  chap_num=1
  while(file_data[i] != "</ul>"){
    file_data[i] = gsub("chapter",gsub(" ", "", paste("chapter", chap_num)),file_data[i],fixed = TRUE)
    i=i+1
    chap_num = chap_num+1  
  }
  writeLines(file_data,html_file)
  close(html_file) 
    
  }
  
   return(file_data)
}

