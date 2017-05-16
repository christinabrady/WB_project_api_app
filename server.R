function(session, input, output){
  observeEvent(input$spid, {
    dat <- pullApi(input$pid)
    colnames(dat) <- c("Project ID", "Project Name", "Country",
      "Commitment Amount", "Last Published Document", "Last Published Document (date published)", "Last Archived ISR")
    ft <- vanilla.table(t(dat), add.rownames = TRUE)
    output$singleproj <- renderFlexTable(ft)
    })

    observeEvent(input$mpid, {
      pids <- trimws(unlist(strsplit(input$pids, ",")))
      mdat <- pullApi(pids)
      mdat <- mdat[order(mdat[, orderby[input$ord]]), ]
      colnames(mdat) <- c("Project ID", "Project Name", "Country",
        "Commitment Amount", "Last Published Document", "Last Published Document (date published)", "Last Archived ISR")
      mft <- vanilla.table(t(mdat), add.rownames = TRUE)
      output$mprojs <- renderFlexTable(mft)
      })

}
