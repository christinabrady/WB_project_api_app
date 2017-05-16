# This script pulls is a wrapper for the
# World Bank project API
# Christina Brady (christina.brady@gmail.com)

options(stringsAsFactors = FALSE)
library(XML)
library(httr)

## base call: "http://search.worldbank.org/api/v2/projects?format=xml&source=IBRD&id=P124109&kw=N"

getDocs <- function(projDocs){
  ### takes the document section of api in list format (tmp$project$projectdocs)
  ### extracts document name, type and date from the document section of project API
  ### returns a data frame

  do.call(rbind, lapply(projDocs, function(px)
    return(data.frame(doc_type_name = px$DocTypeDesc,
                      doc_type = px$DocType,
                      doc_date = as.Date(px$DocDate, format = "%d-%b-%Y"))
  )))
}

pullApi <- function(pids){
  pullSingle <- function(tmp){
    docs <- getDocs(tmp$project$projectdocs)
    docs <- docs[order(docs$doc_date, decreasing = TRUE), ]
    ret <- data.frame(project_id = tmp$project$id[1],
      project_name = tmp$project$project_name[1],
      country = tmp$project$countryshortname[1],
      commitment_amt = tmp$project$totalamt[1],
      last_published_doc = docs$doc_type_name[1],
      last_published_date = docs$doc_date[1],
      last_isr =  docs[which(docs$doc_type == "ISRR"), "doc_date"][1]
      )
    ret
  }
  if(length(pids) ==1){
    tmp <- xmlToList(xmlParse(sprintf("http://search.worldbank.org/api/v2/projects?format=xml&source=IBRD&id=%s&kw=N", pids)))
    return(pullSingle(tmp))
  }else if(length(pids) > 1){
    mtmp <- lapply(pids, function(pid) return(xmlToList(xmlParse(sprintf("http://search.worldbank.org/api/v2/projects?format=xml&source=IBRD&id=%s&kw=N", pid)))))
    return(do.call(rbind, lapply(mtmp, pullSingle)))
  }else{
  cat("Please enter a project id")
  }

}


### test pullApi(c("P124109", "P149522"))
