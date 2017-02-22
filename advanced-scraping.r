library('RSelenium')
library('rvest')

remDr <- remoteDriver(browserName="firefox", port=4444)
remDr$open()

# create a data frame to hold the results 
scrapedViolations <- data.frame(address=character(), censusTract=character(), buildingClassification=character(), violationNumber=character(), violationType=character(), violationFileDate=character(), violationCategory=character(), violationTypeDetail=character(), violationDevice=character())

remDr$navigate("http://a810-bisweb.nyc.gov/bisweb/bispi00.jsp")
Sys.sleep(2)


# enter search inputs and run the search

boroselect <- remDr$findElement("css selector", "#boro1")
boroselect$clickElement()

Sys.sleep(1)
manhattan <- remDr$findElement("css selector", "#boro1 > option:nth-child(2)")
manhattan$clickElement()

housenumber <- remDr$findElement("css selector", 'body > div > table:nth-child(2) > tbody > tr:nth-child(3) > td > table > tbody > tr > td:nth-child(3) > input[type="text"]')
housenumber$sendKeysToElement(list("150"))

street <- remDr$findElement("css selector", 'body > div > table:nth-child(2) > tbody > tr:nth-child(3) > td > table > tbody > tr > td:nth-child(4) > input[type="text"]')
street$sendKeysToElement(list("e 57th st"))
street$sendKeysToElement(list(key = 'enter'))

Sys.sleep(2)


# **** TO COLLECT THE DATA WE WILL USE A SERIES OF NESTED LOOPS ****


# grab building-level data (this data will be repeated in each row of the data frame)
address <- remDr$findElement("css selector", 'td.maininfo:nth-child(1)')$getElementText()[[1]]
buildingClassification <- remDr$findElement("css selector", 'body > center:nth-child(1) > table:nth-child(7) > tbody:nth-child(1) > tr:nth-child(5) > td:nth-child(2)')$getElementText()[[1]]
censusTract <- remDr$findElement("css selector", 'body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(3) > td:nth-child(6)')$getElementText()[[1]]


# click the "Violations-DOB" link 
violationslink <- remDr$findElement("css selector", 'body > center:nth-child(1) > table:nth-child(8) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(3) > td:nth-child(1) > b:nth-child(1) > a:nth-child(1)')
violationslink$clickElement()

Sys.sleep(2)




# **** PATTERN 1: TO LOOP THROUGH MULTIPLE PAGES OF SEARCH RESULTS, USE A WHILE LOOP
#                 AT THE END OF THE LOOP TEST WHETHER THERE IS A "NEXT PAGE" LINK
#                 IF SO, CLICK IT. IF NOT, EXIT THE LOOP.

morepages <- TRUE # when it's time to exit the loop, set this variable to false

#loop through the pages
while(morepages == TRUE) {
  
  

  # **** PATTERN 2: TO LOOP THROUGH A LIST / TABLE, USE A FOR LOOP
  #              SINCE WE KNOW THE NUMBER OF ITEMS BEFOREHAND, THIS LOOP IS SIMPLER

  # select the table rows
  tablerows <- remDr$findElements("css selector", 'body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr')
  
  # loop through the rows one-by-one (row 1 is the header, so we start with row 2)
  for (i in 2:length(tablerows)){
    
    # extract the row's html...
    tableRowHTML <- tablerows[[ i ]]$getElementAttribute("outerHTML")[[1]]
    # ...and hand it off to rvest
    tableRowRvest <- read_html(tableRowHTML)
    
    # split the row into an array of cells
    tableCells <- tableRowRvest %>% html_nodes("td")
    
    # grab the data (and remove line breaks where needed)
    violationNumber <- html_text(tableCells[1])
    violationNumber <- gsub("[\r\n]", "", violationNumber)
    violationType <- html_text(tableCells[3])
    violationFileDate <- html_text(tableCells[4])
    
    
    # is there a link with more details?
    detailsLink <- tableRowRvest %>% html_nodes("a")
    if (length(detailsLink) > 0) {
      # if so, go to the details page
      
      # extract the link's URL and navigate there in the browser 
      linkURL <- html_attr(detailsLink[1], 'href')
      fullURL <- paste('http://a810-bisweb.nyc.gov/bisweb/', linkURL, sep="")
      remDr$navigate(fullURL)

      # grab the details
      violationCategory <- remDr$findElement("css selector",'body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(2) > td:nth-child(4)')$getElementText()[[1]]
      violationTypeDetail <- remDr$findElement("css selector",'body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(3) > td:nth-child(2)')$getElementText()[[1]]
      violationDevice <- remDr$findElement("css selector",'body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(4) > td:nth-child(4)')$getElementText()[[1]]
      
      # and go back
      remDr$goBack()
      
      Sys.sleep(1)
      
    } else {
      # if there is no link, set the fields to NA
      violationCategory <- "NA"
      violationTypeDetail <- "NA"
      violationDevice <- "NA"
    }
    
    
    
    # now we have all the data for this violation. Append a row to the data frame.
    violationRow <- data.frame(address, censusTract, buildingClassification, violationNumber, violationType, violationFileDate, violationCategory, violationTypeDetail, violationDevice)
    scrapedViolations <- rbind(scrapedViolations, violationRow)
    
  }
  


  # is there a 'next' link?
  nextpagelink <- remDr$findElements("css selector",'body > center:nth-child(1) > table:nth-child(6) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(3) > form:nth-child(1) > input:nth-child(1)')
  if (length(nextpagelink) > 0) {
    #if so, click it
    nextpagelink[[1]]$clickElement()
    
    Sys.sleep(2)
    
  } else {
    #if not, exit the loop
    morepages <- FALSE
  }

  
}


write.csv(scrapedViolations, file = "d:/scrapedViolations.csv")
