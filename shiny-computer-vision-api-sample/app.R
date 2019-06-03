library(shiny)

# define the UI
ui <- fluidPage(
  # give it a title
  titlePanel("Shiny & Computer Vision API sample"),
  
  sidebarLayout(
    # input panel on the left
    sidebarPanel(
      # region
      selectInput(
        "region",
        "Region",
        choices = c(
          "West US" = "westus",
          "West US 2" = "westus2",
          "East US" = "eastus",
          "East US 2" = "eastus2",
          "West Central US" = "westcentralus",
          "South Central US" = "southcentralus",
          "West Europe" = "westeurope",
          "North Europe" = "northeurope",
          "Southeast Asia" = "southeastasia",
          "East Asia" = "eastasia",
          "Australia East" = "australiaeast",
          "Brazil South" = "brazilsouth",
          "Canada Central" = "canadacentral",
          "Central India" = "centralindia",
          "UK South" = "uksouth",
          "Japan East" = "japaneast"
        ),
        selected = "northeurope"
      ),
      
      # Computer Vision API key
      textInput("api_key", label = "Computer Vision API Key", value = "Enter your API key here..."),
      
      # mode radio buttons
      radioButtons(
        "mode",
        "Mode",
        choices = c("Printed" = "Printed", "Handwritten" = "Handwritten"),
        selected = "Printed"
      ),
      
      # file selector
      fileInput(
        "image_file",
        "Image to analyze",
        multiple = FALSE,
        accept = c('image/jpeg', 'image/png', 'image/bmp')
      )
    ),
    
    # main panel
    mainPanel(verbatimTextOutput("contents"))
  )
)

# define the server
server <- function(input, output) {
  # recognizes text in an image
  recognizeText <-
    function(file, region, computer_vision_key, mode) {
      require(httr)
      require(jsonlite)
      
      # pass the image for text recognition
      recognize_text_endpoint = paste0("https://",
                                       region,
                                       ".api.cognitive.microsoft.com/vision/v2.0/recognizeText")
      upload_response <- POST(
        url = paste0(recognize_text_endpoint, "?mode=", mode),
        add_headers(
          .headers = c(
            'Ocp-Apim-Subscription-Key' = computer_vision_key,
            'Content-Type' = 'application/octet-stream'
          )
        ),
        body = upload_file(file)
      )
      
      # ensure we did not get a 401 - Unauthorized
      # -> if we did, the provided key for the Computer Vision service is wrong
      if (upload_response$status_code == 401) {
        stop(
          "Could not authenticate against the Computer Vision service. Ensure that the provided key is correct and that you created it in the selected Azure region."
        )
      }
      
      # wait until the recognition has succeeded
      while ({
        status_response = GET(url = toString(upload_response$headers["operation-location"]),
                              add_headers(
                                .headers = c('Ocp-Apim-Subscription-Key' = computer_vision_key)
                              ))
        status_response_content = content(status_response, as = "parsed")
        status_response_content$status != "Succeeded"
      }) {
        Sys.sleep(1)
      }
      
      # extract text
      lines = c()
      for (line in status_response_content$recognitionResult$lines) {
        lines = c(lines, line$text)
      }
      return(paste0(lines, collapse = "\n"))
    }
  
  output$contents <- renderText({
    req(input$image_file)
    tryCatch({
      recognizeText(input$image_file$datapath,
                    input$region,
                    input$api_key,
                    input$mode)
    },
    error = function(e) {
      stop(safeError(e))
    })
  })
}

shinyApp(ui, server)
