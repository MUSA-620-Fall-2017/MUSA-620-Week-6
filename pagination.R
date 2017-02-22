
#  *****PATTERN 1: LOOPING THROUGH PAGES OF SEARCH RESULTS

morepages <- TRUE
while(morepages == TRUE) {

  
  # ***************** SCRAPING CODE GOES HERE
  
  
  nextpagelink <- remDr$findElements("css selector",'body > center:nth-child(1) > table:nth-child(6) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(3) > form:nth-child(1) > input:nth-child(1)')
  if (length(nextpagelink) > 0) {
    nextpagelink[[1]]$clickElement()
  } else {
    morepages <- FALSE
  }
}
