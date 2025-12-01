# server.R

source("globals.R")

server <- function(input, output, session) {

  # Reactive: collect all inputs into a 1-row data.table
  user_inputs <- reactive({
    # PER_TYP ------------------------------------------------------
    PER_TYP <- if (input$personType == "Pedestrian (No Vehicle)") {
      "All Other Non-motorist"
    } else {
      input$personType
    }
    
    # POS_FRONT_BACK ------------------------------------------------------
    POS_FRONT_BACK <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else if (input$personType == "Driver (Moving Vehicle)") {
      "Front"
    } else if (isTRUE(input$positionFrontBack)) {
      "Front"
    } else {
      "Back"
    }
    
    # POS_SIDE ------------------------------------------------------------
    POS_SIDE <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else if (input$personType == "Driver (Moving Vehicle)") {
      "Driver Side"
    } else {
      input$positionSide
    }
    
    # REST_USE ------------------------------------------------------------
    REST_USE <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Missing"
    } else if (isTRUE(input$restraintUse) && input$bodyType != "Motorcycles & Other Recreational Vehicles") {
      "Used- Restraint"
    } else if (isTRUE(input$restraintUse)) {
      "Used- Helmet"
    } else {
      "Not Used or Improperly Used"
    }
    
    # AIR_BAG -------------------------------------------------------------
    AIR_BAG <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Non-motorist"
    } else if (isTRUE(input$airbagDeployed)) {
      "Deployed"
    } else {
      "Not Deployed"
    }
    
    # EJECTION ------------------------------------------------------------
    EJECTION <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Ejection Not Possible"
    } else if (isTRUE(input$ejection)) {
      "Ejected"
    } else {
      "Not Ejected"
    }
    
    # EXTRICAT ------------------------------------------------------------
    EXTRICAT <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Not Extricated/Not Applicable"
    } else if (isTRUE(input$extricated)) {
      "Extricated"
    } else {
      "Not Extricated/Not Applicable"
    }
    
    # NUMOCCS ------------------------------------------------------------
    NUMOCCS <- if (input$personType == "Pedestrian (No Vehicle)") {
      NA
    } else {
      input$numOccs
    }
    
    # HIT_RUN ------------------------------------------------------------
    HIT_RUN <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else if (isTRUE(input$hitRun)) {
      "Hit-and-Run"
    } else {
      "No Hit-and-Run"
    }
    
    
    # State ------------------------------------------------------------
    STATE_GROUP <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else if (input$state %in% c("Arizona", "California", "District of Columbia", "Hawaii", "New Jersey", "New York")) {
      "Fatality prop quintile 1"
    } else if (input$state %in% c("Florida", "Indiana", "Illinois", "North Carolina", "Maryland", "Alaska", "Utah", "Nevada", "Delaware")) {
      "Fatality prop quintile 2"
    } else if (input$state %in% c("Colorado", "Georgia", "Massachusetts", "Michigan", "Rhode Island", "Texas")) {
      "Fatality prop quintile 3"
    } else if (input$state %in% c("Connecticut", "Idaho", "Louisiana", "Minnesota", "Missouri", "New Mexico", "Ohio", "Oklahoma", "Oregon", "South Carolina", "Tennessee", "Washington")) {
      "Fatality prop quintile 4"
    } else if (input$state %in% c("Alabama", "Arkansas", "Iowa", "Kansas", "Kentucky", "Maine", "Mississippi", "Montana", "Nebraska", "New Hampshire", "North Dakota", "Pennsylvania", "South Dakota", "Vermont", "Virginia", "West Virginia", "Wisconsin", "Wyoming")) {
      "Fatality prop quintile 5"
    } else if (input$state == "No Registration") {
      "No Registration"
    } else {
      "Other Special Registration"
    }
    
    # OWNER ------------------------------------------------------------
    OWNER <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else {
      input$owner
    }
    
    # MOD_YEAR ------------------------------------------------------------
    MOD_YEAR <- if (input$personType == "Pedestrian (No Vehicle)") {
      NA
    } else {
      input$modelYear
    }
    
    # BODY_TYP ------------------------------------------------------------
    BODY_TYP <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else {
      input$bodyType
    }
    
    # TOW_VEH ------------------------------------------------------------
    TOW_VEH <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else if (isTRUE(input$trailer)) {
      "Trailing Unit"
    } else {
      "No Trailing Units"
    }
    
    # TRAV_SP ------------------------------------------------------------
    TRAV_SP <- if (input$personType == "Pedestrian (No Vehicle)") {
      NA
    } else {
      input$travelSpeed
    }
    
    # IMPACT1 ------------------------------------------------------------
    IMPACT1 <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else {
      as.character(input$impact)
    }
    
    # DEFORMED ------------------------------------------------------------
    DEFORMED <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else {
      input$deformed
    }
    
    # FIRE_EXP ------------------------------------------------------------
    FIRE_EXP <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else if (isTRUE(input$fire)) {
      "Fire"
    } else {
      "No Fire"
    }
    
    # SPEEDREL ------------------------------------------------------------
    SPEEDREL <- if (input$personType == "Pedestrian (No Vehicle)") {
      "Pedestrian (No Vehicle)"
    } else if (isTRUE(input$fire)) {
      "Yes"
    } else {
      "No"
    }
    
    # NHS ------------------------------------------------------------
    NHS <- if (isTRUE(input$nhs)) {
      "In NHS"
    } else {
      "Not in NHS"
    }
    
    # Numeric processing ---------------------------------------------
    new_numeric <- data.frame(
      AGE              = input$age,
      NUMOCCS          = NUMOCCS,
      TRAV_SP          = TRAV_SP,
      VE_FORMS         = input$vehicles,
      MOD_YEAR         = MOD_YEAR,
      HOUR             = input$hour
    )
    new_numeric_imputed <- predict(pp_median, newdata = new_numeric)
    new_numeric_yeoj <- predict(pp_yeoj, newdata = new_numeric_imputed)
    
    # categorical processing -----------------------------------------
    new_qualitative <- data.frame(
      SEX              = input$sex,
      PER_TYP          = PER_TYP,
      POS_FRONT_BACK   = POS_FRONT_BACK,
      POS_SIDE         = POS_SIDE,
      REST_USE         = REST_USE,
      AIR_BAG          = AIR_BAG,
      EJECTION         = EJECTION,
      EXTRICAT         = EXTRICAT,
      HIT_RUN          = HIT_RUN,
      rate_quint_group = STATE_GROUP,
      OWNER            = OWNER,
      BODY_TYP         = BODY_TYP,
      TOW_VEH          = TOW_VEH,
      IMPACT1          = IMPACT1,
      DEFORMED         = DEFORMED,
      FIRE_EXP         = FIRE_EXP,
      SPEEDREL         = SPEEDREL,
      NHS              = NHS,
      LGT_COND         = input$lgtCond,
      WEATHER          = input$weather
    )
    new_qualitative <- predict(pp_qual, newdata = new_qualitative)
    ped_level <- "Pedestrian (No Vehicle)"
    ped_cols <- grep(ped_level, colnames(new_qualitative), fixed=TRUE)
    is_pedestrian <- as.integer(rowSums(new_qualitative[, ped_cols, drop=FALSE]) > 0)
    new_qualitative <- new_qualitative[, -ped_cols, drop = FALSE]
    new_qualitative <- cbind(new_qualitative, is_pedestrian = is_pedestrian)
    
    x_num <- as.matrix(new_numeric_yeoj)
    x_qual <- as.matrix(new_qualitative)
    
    X_new <- cbind(x_num, x_qual)
      list(
        X_new = X_new,
        display_row = as.data.table(cbind(new_numeric_yeoj, new_qualitative)) # for debugging later
  )
  })

  pred_prob <- reactive({
    X_new <- user_inputs()$X_new
    
    # adjust "1" / "Yes" / event level to whatever your model uses
    probs <- predict(model, newdata = X_new, type = "prob")
    # assume the positive class is the second column (common for caret)
    as.numeric(probs[, 2])
    
  })
  
  output$pred_box <- shinydashboard::renderValueBox({
    p <- pred_prob()
    valueBox(
      paste0(sprintf("%.1f", 100 * p), "%"),
      subtitle = "Estimated fatality probability",
      icon = icon("heartbeat"),
      color = "red"
    )
  })
}