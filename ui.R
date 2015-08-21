table <- read.table("http://sebastien.ledien.free.fr/unofficial_factominer/livreR/decathlon.csv",sep=";",row.names=1, dec=".", header = TRUE)
shinyUI(pageWithSidebar(
        headerPanel("Decathlon Analysis"),
        sidebarPanel(
                radioButtons("id1","Competition type :",
                             list("Olympic Games" ="Olympic Games",
                                  "Decastar" ="Decastar",
                                  "All" = "All")),
                br(),
                selectInput("quateg", "Choose a combined event:", 
                            choices = c("Running", "Jumping", "Throwing", "middle-distance race",  "Pole vault" )),
                
                
                
                sliderInput('svalue', 'Performance',value = 1, min = 1, max = nrow(subset(table, table$Competition == "id1")), step = 1),
                verbatimTextOutput("name")
        ),
        mainPanel(
                
                tabsetPanel(
                        tabPanel("Graph View", plotOutput("plotv")), 
                        tabPanel("Table data view", dataTableOutput("tablev")),
                        tabPanel("Become a champion", verbatimTextOutput("champion")),
                        tabPanel("Documentation", a("Link to documentation on Rpubs", href="http://rpubs.com/asdp38/102472"))
                )
        )
)
)

