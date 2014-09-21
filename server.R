#The server code for my NYC collisions app.
#Allow large dataset
options(shiny.maxRequestSize=72*1024^2)
#Include packages
require(devtools)
library(shiny)
library(googleVis)
require(googleVis)

#The collisions data was downloaded from 
#https://data.cityofnewyork.us/NYC-BigApps/NYPD-Motor-Vehicle-Collisions/h9gi-nx95
#That website is updated regularly with new data, but this app currently only uses the data through
#September 7, 2014.  You can download a more recent data set with
#fileUrl<-"https://data.cityofnewyork.us/api/views/h9gi-nx95/rows.csv?accessType=DOWNLOAD"
#download.file(fileUrl, destfile="collisions.csv", method="curl")
collisions<-read.csv("collisions.csv", sep=",")

#cleaning the file so that it is useable below
names(collisions)<-tolower(names(collisions))
collisions$location<-as.character(collisions$location)
collisions$location<-gsub(",\\ ", ":", collisions$location)
collisions$location<-gsub("\\(", "", collisions$location)
collisions$location<-gsub("\\)", "", collisions$location)

#cleaning and organizing the zipcodes
allzipcode<-collisions$zip.code
zipcode<-allzipcode[!is.na(allzipcode)]
zip<-unique(zipcode)
zip<-zip[order(zip)]
zip<-as.list(zip)
names(zip)<-as.character(zip)

#cleaning and organizing the dates
alldates<-as.Date(collisions$date, "%m/%d/%Y")
dates<-unique(alldates)
dates<-dates[order(dates)]


shinyServer(
  function(input, output){
    #print selected zip codes
    output$inputValue1<-renderPrint({input$zipinput})
    
    #get indices for rows corresponding to selected dates and zip codes
    inzip<-reactive({allzipcode %in% input$zipinput})
    daterange<-reactive({seq(input$date[1], input$date[2], by="day")})
    indates<-reactive({alldates %in% daterange()})
    datesandzip<-reactive({indates()&inzip()})
    
    #count number of zip codes listed as na in selected date range
    nas<-reactive({sum(is.na(allzipcode[indates()]))})
    
    #print number of collisions in specified zip codes
    output$totalinzip<-renderPrint({
      sum(inzip())})
    
    #print number of collisions in specified date range
    output$totalindates<-renderPrint({
     sum(indates()) 
    })
    
    #print number of collisions in selected zip codes and date range
    output$totalinzipdates<-renderPrint({
      sum(datesandzip()) 
    })
    
    #print number of zips listed as nas in selected date range
    output$nacount<-renderPrint(
      {nas()}
      )
    
    #creating a map showing the accidents and times they occurred 
    output$map<-renderGvis({
      df<-collisions[datesandzip(),]
      gvisMap(df, "location", "time", options=list(showTip=TRUE, useMapTypeControl=TRUE, 
                                                   enableScrollWheel=TRUE)) 
    })                                                     
  }  
)