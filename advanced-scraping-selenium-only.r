library('RSelenium')
library('rvest')

remDr <- remoteDriver(browserName="firefox", port=4444)
remDr$open()

# create a data frame to hold the results 
scrapedViolations <- data.frame(address=character(), censusTract=character(), buildingClassification=character(), violationNumber=character(), violationType=character(), violationFileDate=character())

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



# grab building-level data (this data will be repeated in each row of the data frame)
address <- remDr$findElement("css selector", 'td.maininfo:nth-child(1)')$getElementText()[[1]]
buildingClassification <- remDr$findElement("css selector", 'body > center:nth-child(1) > table:nth-child(7) > tbody:nth-child(1) > tr:nth-child(5) > td:nth-child(2)')$getElementText()[[1]]
censusTract <- remDr$findElement("css selector", 'body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(3) > td:nth-child(6)')$getElementText()[[1]]


# click the "Violations-DOB" link 
violationslink <- remDr$findElement("css selector", 'body > center:nth-child(1) > table:nth-child(8) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(3) > td:nth-child(1) > b:nth-child(1) > a:nth-child(1)')
violationslink$clickElement()

Sys.sleep(2)


morepages <- TRUE
while(morepages == TRUE) {
  
  
  
  tablerows <- remDr$findElements("css selector", 'body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr')
  
  for (i in 2:length(tablerows)){
  
    
    cell1selector <- paste("body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(", i, ") > td:nth-child(1)") 
    cell2selector <- paste("body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(", i, ") > td:nth-child(3)") 
    cell3selector <- paste("body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr:nth-child(", i, ") > td:nth-child(4)") 
    
    violationNumber <- remDr$findElement("css selector", cell1selector)$getElementText()[[1]]
    violationType <- remDr$findElement("css selector", cell2selector)$getElementText()[[1]]
    violationFileDate <- remDr$findElement("css selector", cell3selector)$getElementText()[[1]]
    
    
    
    violationRow <- data.frame(address, censusTract, buildingClassification, violationNumber, violationType, violationFileDate)
    scrapedViolations <- rbind(scrapedViolations, violationRow)
    
    
  }
  
  
  nextpagelink <- remDr$findElements("css selector",'body > center:nth-child(1) > table:nth-child(6) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(3) > form:nth-child(1) > input:nth-child(1)')
  if (length(nextpagelink) > 0) {
    nextpagelink[[1]]$clickElement()
    Sys.sleep(2)
  } else {
    morepages <- FALSE
  }
}


