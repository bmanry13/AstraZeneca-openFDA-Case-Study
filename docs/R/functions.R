#==============================================================================================================#
# This file contains the general functions for used for generating queries, interacting with openFDA, and 
#   creating the various plots and tables in the report
#
# Note: given the time limitations these are still very much a WIP
#==============================================================================================================#

# ========= LIBRARY DEPENDENCIES =========#
library(httr)
library(jsonlite)
library(ggplot2)

# ========= FUNCTIONS =========#
createQuery = function(queryItemList, rootURL = 'https://api.fda.gov/drug/event.json?'){
  #============================================#'
  # Description:creates a query string using named elements in a list
  # Inputs: queryItemList: Named list of query items available for openFDA
  #         rootURL: root URL for openFDA query (default is FAERS)
  # Outputs: character string URL
  #============================================#'
  stopifnot(class(queryItemList) == "list")
  #TODO: add check for valid query terms e.g., search, count, limit, skip
  queryItems = c()
  for(item in names(queryItemList)){
    if(is.null(queryItemList[[item]])) next
    queryItems = c(queryItems, paste(item, queryItemList[[item]], sep="="))
  }
  # Combine into single url string
  url = paste0(rootURL, paste0(queryItems, collapse = "&"))
  return(url)
}

getResults = function(q, excludeMeta = TRUE, verbose = FALSE){
  #============================================#'
  # Description: Submits request to openFDA and returns the results
  # Inputs: q
  #         excludeMeta (boolean): If true only results portion of JSON will be returned 
  #         verbose (boolean): prints additional information while running
  # Outputs: list object created by jsonlite from returned openFDA JSON
  #============================================#'
  if(!class(q) %in% c("list", "character")){
    stop("Query must be character or list")
  } else if(class(q) == "list"){
    q = createQuery(q)
  } 
  # Added this to show progress when stiching together queries using skip
  if(verbose){
    cat('\n\n')
    cat(q)
  }
  request = GET(q)
  #TODO: error handling if status code != 200 e.g, request failed
  if(request$status_code == 200 & verbose) cat("\n SUCCESS!!!")
  response = content(request, as = "text")
  response = jsonlite::fromJSON(response)
  if(excludeMeta) response = response$results
  return(response)
}

loadCategoryMap = function(mapName, dir = "./data/category_maps"){
  #============================================#'
  # Description: Some openFDA fields use numeric values for categorical fields. 
  #               This function allows for the creation of lookup files to map
  #               values to text descriptions
  # Inputs: mapName (character): name of field with categorical values
  #         dir (character): path to directory with lookup csv files
  # Outputs: data.frame 
  #============================================#'
  
  #check if category name is available and make sure there is only one
  matchedFiles = list.files(dir, pattern = mapName)
  #Load table if only one if not throw error
  if(length(matchedFiles) == 1) return(read.csv(file.path(dir, matchedFiles), colClasses = c("numeric", "character")))
  if(length(matchedFiles) == 0) stop("No Matching Category Map Found!")
  stop("Multiple Matches Found Please Be More Specific!")
}

mapCategoryValues = function(df, n){
  #============================================#'
  # Description: Merges category mapping to data.frame
  # Inputs: df (data.frame): usually the result of a "count" query. Must have "term" as a field
  #         n (character): name of field with categorical values
  # Outputs: data frame
  #============================================#'
  valueMap = loadCategoryMap(mapName = n)
  grab_names = names(df)
  df = merge(df, valueMap, by = "term")[ , -1]
  names(df)[ncol(df)] = "term"
  return(df[grab_names])
}

countPlot = function(plotData, axis_label, plot_title = NULL, mapCategories = NULL){
  #============================================#'
  # Description: Creates a horizontal bar plot for openFDA count query results
  # Inputs: 
  # Outputs: ggplot2 plot
  #============================================#'
  
  if(!is.null(mapCategories)) plotData = mapCategoryValues(plotData, mapCategories)
  plotData$term = toupper(plotData$term)
  if("compare" %in% names(plotData)){
    p = ggplot(plotData, aes(reorder(term, count), count, fill = compare)) 
  } else {
    p = ggplot(plotData, aes(reorder(term, count), count))
  }
  p = p +
    geom_bar(stat = "Identity", position = 'dodge') +
    xlab(axis_label) +
    coord_flip() 
  if(!is.null(plot_title)) p = p + ggtitle(plot_title)
  plot(p)
}
