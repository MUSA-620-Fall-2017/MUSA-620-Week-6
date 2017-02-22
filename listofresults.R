
#  *****PATTERN 2: LOOPING THROUGH A LIST/TABLE OF ITEMS


tablerows <- remDr$findElements("css selector", 'body > center:nth-child(1) > table:nth-child(3) > tbody:nth-child(1) > tr')

for (i in 2:length(tablerows)){
  
  
  # ***************** SCRAPING CODE GOES HERE
  
  
  violationRow <- data.frame(address, censusTract, buildingClassification, violationNumber, violationType, violationFileDate, violationCategory, violationTypeDetail, violationDevice)
  scrapedViolations <- rbind(scrapedViolations, violationRow)
  
}


