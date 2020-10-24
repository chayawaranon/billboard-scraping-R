library(dplyr)
library(taskscheduleR)    #library for do automatic script
library(rvest)            #library for web scarping
library(googlesheets4)    #library for read and create google sheets from R

#get all html element
bilboard <- read_html("https://www.billboard.com/charts/hot-100")

#get list of song
song_list <- bilboard %>% html_nodes(".text--truncate.color--primary") %>% html_text()

#get list of artist
artist <- bilboard %>% html_nodes(".text--truncate.color--secondary") %>% html_text()

#create dataframe
dataframe <- data.frame(song_list,artist,stringsAsFactors = FALSE)

sheet_name <- "Billboard-Hot-100"
isCreated <- FALSE

#check sheet is already exist or not
for (i in gs4_find()$name) {
  if(i == sheet_name) {
    isCreated <- TRUE
    break
  }
}

if(!isCreated) {
  #create sheet
  gs4_create(sheet_name, sheets = as.character(Sys.Date()))
}

#get sheet ID
sheet_id <- gs4_find(sheet_name)$id

#write data to sheet
sheet_write(dataframe, sheet_id, sheet = as.character(format(Sys.Date(), "%Y-%V")))

