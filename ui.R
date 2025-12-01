# ui.R
source("./globals.R")

dashboardPage(
  dashboardHeader(
    title = "Fatal Accidents Study Dashboard"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Enter Information",
        tabName = "enterInfo",
        icon = icon("clipboard")
      ),
      menuItem(
        "Predicted Probability of Fatality",
        tabName = "predProb",
        icon = icon("table")
      )
    )
  ),
  dashboardBody(
    tabItems(

      # --- Enter Information tab -----------------------------------------
      tabItem(
        tabName = "enterInfo",
        
        # ACCIDENT box -----------------------------------------------------
        fluidRow(box(
          title = "Fill out all information about the ACCIDENT.",
          width = 12,
          
          # row with drop-down inputs
          fluidRow(
            column(
              width = 6,
              selectInput(
                "weather",
                "Weather at time of accident:",
                choices = WEATHER_CHOICES
              )
            ),
            column(
              width = 6,
              selectInput(
                "lgtCond",
                "Lighting conditions at time of accident:",
                choices = LGT_COND_CHOICES
              )
            )
          ),
          
          # row with slider inputs
          fluidRow(
            column(
              width = 6,
              sliderInput(
                "hour",
                "Hour the accident took place (0 = midnight, 11 = 11am, 23 = 11pm):",
                min   = 0,
                max   = 23,
                value = 11
              )
            ),
            column(
              width = 6,
              sliderInput(
                "vehicles",
                "Number of Vehicles involved:",
                min   = 1,
                max   = 50,
                value = 2
              )
            )
          ),
          
          # row with checkbox inputs
          fluidRow(
            checkboxInput(
              "nhs",
              "Accident took place on US Highway or Interstate",
              value = FALSE
            )
          ),
        )),
        
        # PERSON box -------------------------------------------------------
        fluidRow(box(
          title = "Fill out all information about the PERSON.",
          width = 12,
          
          # row with slider inputs
          sliderInput(
            "age",
            "How old was the person at the time of the accident?",
            min   = 0,
            max   = 99,
            value = 25
          ),
          
          # row with drop-down inputs
          fluidRow(
            column(
              width = 6,
              selectInput(
                "sex",
                "The person's biological sex is:",
                choices = SEX_CHOICES
              )
            ),
            column(
              width = 6,
              selectInput(
                "personType",
                "The person's role in the accident was:",
                choices = PERSON_TYPE_CHOICES
              )
            )
          ),
          
          # row with drop-down inputs
          conditionalPanel(
            condition = "input.personType !== 'Pedestrian (No Vehicle)' && 
                   input.personType !== 'Driver (Moving Vehicle)'",
            fluidRow(
              column(
                width = 6,
                checkboxInput(
                  "positionFrontBack",
                  "The passenger/occupant was seated in a front row seat.",
                  value = FALSE
                )
              ),
              column(
                width = 6,
                selectInput(
                  "positionSide",
                  "The passenger/occupant was seated from side to side:",
                  choices = POSITION_SIDE_CHOICES
                )
              )
            )
          ),
          
          conditionalPanel(
            condition = "input.personType !== 'Pedestrian (No Vehicle)'",
            fluidRow(
              column(
                width = 3,
                checkboxInput(
                  "restraintUse",
                  "Person properly used restraints.",
                  value = TRUE
                )
              ),
              column(
                width = 3,
                checkboxInput(
                  "airbagDeployed",
                  "The airbag closest to the person deployed.",
                  value = FALSE
                )
              ),
              column(
                width = 3,
                checkboxInput(
                  "ejection",
                  "The person was ejected from the vehicle.",
                  value = FALSE
                )
              ),
              column(
                width = 3,
                checkboxInput(
                  "extricated",
                  "The person was extricated by emergency crews from the vehicle.",
                  value = FALSE
                )
              )
            )
          )
        )),
        
        # VEHICLE box (conditional) ----------------------------------------
        fluidRow(conditionalPanel(
          condition = "input.personType !== 'Pedestrian (No Vehicle)'",
          box(
            title = "Fill out all information about the VEHICLE the person was riding in.",
            width = 12,
            
            # Sliders row
            fluidRow(
              column(
                width = 3,
                sliderInput(
                  "numOccs",
                  "Number of Occupants in the vehicle (including the person):",
                  min   = 1,
                  max   = 50,
                  value = 2
                )
              ),
              column(
                width = 3,
                sliderInput(
                  "modelYear",
                  "Model Year of the vehicle:",
                  min   = 1914,
                  max   = 2025,
                  value = 2015
                )
              ),
              column(
                width = 3,
                sliderInput(
                  "travelSpeed",
                  "The vehicle was traveling about this fast (mph):",
                  min   = 0,
                  max   = 150,
                  value = 60
                )
              ),
              column(
                width = 3,
                sliderInput(
                  "impact",
                  "Where was the vehicle impacted (clock-face directions, 12 = head-on, 6 = rear-ended)",
                  min   = 1,
                  max   = 12,
                  value = 9
                )
              )
            ),
            
            # Boolean flags row
            fluidRow(
              column(
                width = 3,
                checkboxInput("hitRun",
                              "The vehicle hit and ran.",
                              FALSE)
              ),
              column(
                width = 3,
                checkboxInput("trailer",     
                              "The vehicle was towing a trailer.",
                              FALSE)
              ),
              column(
                width = 3,
                checkboxInput("fire",
                              "The vehicle caught on fire.",
                              FALSE)
              ),
              column(
                width = 3,
                checkboxInput("speedRelated",
                              "The vehicle was speeding and it contributed to the accident.", 
                              FALSE)
              )
            ),
            
            # Categorical selects row
            fluidRow(
              column(
                width = 3,
                selectInput(
                  "state",
                  "The vehicle was registered in state:",
                  choices = REG_STATE_CHOICE
                )
              ),
              column(
                width = 3,
                selectInput(
                  "owner",
                  "Was the driver the owner of the vehicle?",
                  choices = OWNER_CHOICES
                )
              ),
              column(
                width = 3,
                selectInput(
                  "bodyType",
                  "The vehicle's body type was:",
                  choices = BODY_TYP_CHOICES
                )
              ),
              column(
                width = 3,
                selectInput(
                  "deformed",
                  "The level of damage to the vehicle as:",
                  choices = DEFORMED_CHOICES
                )
              )
            )
          )
        )
      )),

      # --- Predicted Probability tab ---------------------------------------------------
      tabItem(
        tabName = "predProb",
        fluidRow(
          valueBoxOutput("pred_box", width = 4)
        )
      )
    )
  )
)
