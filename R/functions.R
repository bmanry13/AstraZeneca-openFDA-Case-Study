#==============================================================================================================#
#
#
#
#
#==============================================================================================================#

# ========= LIBRARY DEPENDENCIES =========#
library(httr)
library(jsonlite)
library(ggplot2)

# ========= FUNCTIONS =========#
createQuery = function(queryItemList, rootURL = 'https://api.fda.gov/drug/event.json?'){
  #============================================#'
  # Description:
  # Inputs: Named list
  # Outputs:
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

getResults = function(q, excludeMeta = TRUE, verbose = FALSE, renameCount = NULL){
  #============================================#'
  # Description:
  # Inputs: 
  # Outputs:
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
  # Description:
  # Inputs: 
  # Outputs:
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
  # Description:
  # Inputs: 
  # Outputs:
  #============================================#'
  valueMap = loadCategoryMap(mapName = n)
  grab_names = names(df)
  df = merge(df, valueMap, by = "term")[ , -1]
  names(df)[ncol(df)] = "term"
  return(df[grab_names])
}


countPlot = function(plotData, axis_label, plot_title = NULL, mapCategories = NULL){
  #============================================#'
  # Description:
  # Inputs: 
  # Outputs:
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
