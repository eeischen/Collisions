#The user interface for my NYC collisions app.

shinyUI(
  #Make a page with a sidebar
  pageWithSidebar(
    #Application title
    headerPanel(
    h1("Collisions in New York City",align="center")
    ),
    #Use variants on html commands to design sidebar panel
    sidebarPanel(
      h3("Enter zip code(s) and a range of dates."),
      selectInput('zipinput', 'ZIP Code: Select as many New York City zip codes as you wish.', choices=list("10025"=10025, "10000"=10000), selected=10025, multiple=TRUE),
      dateRangeInput('date', 'Date Range: Select a start date and an end date between July 1, 2012 and September 7, 2014.', 
                     min="2012-07-01", max="2014-09-07", start="2012-07-01", end="2014-09-07"),
      h3('Documentation'),
      p('This app computes the number of collisions in specified New York City (NYC) zip codes
        during specified date ranges.  The user selects the zip codes and a range of dates
        between July 1, 2012 and September 7, 2014.  The app also includes an interactive map showing the
        locations of these collisions.  Note that it might take a few moments for the app to load.  The data was downloaded from'),
       a(href="https://data.cityofnewyork.us/NYC-BigApps/NYPD-Motor-Vehicle-Collisions/h9gi-nx95",
        "https://data.cityofnewyork.us/NYC-BigApps/NYPD-Motor-Vehicle-Collisions/h9gi-nx95"),
      p('While that website is updated regularly with new data, this app currently uses
        only the data through September 7, 2014.')
    ),
    #Use variants on html commands to create main panel
    mainPanel(
      h3('Collisions in selected zip code(s) and date range'),
      h4('The ZIP code(s) you entered:'),
      verbatimTextOutput("inputValue1"),
      h4('The total number of collisions between July 1, 2012 and September 7, 2014 in NYC in the selected zip code(s):'),
      verbatimTextOutput("totalinzip"),
      h4('The total number of collisions (across all NYC zip codes) in the selected date range:'),
      verbatimTextOutput("totalindates"),
      h4('The total number of collisions in the selected zip codes in the selected date range:'),
      verbatimTextOutput("totalinzipdates"),
      h4('Here is a map of all collisions occurring in the selected zip codes in the selected date range.  
         Mouse over each item to find out the time of day that the collision occurred.  
         You can use the wheel on your mouse to zoom in and out.  You can also use your mouse to move around
         the map.'),
      htmlOutput('map'),
      p('Note: For the following number of collisions in your selected date range, 
          no zip code was provided in the data set.'),
      verbatimTextOutput("nacount")
    )
  )  
)