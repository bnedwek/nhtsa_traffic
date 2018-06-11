library(dplyr)

# Read datasets #
accidents <- read.csv('data/FARS2016NationalCSV/accident.csv', stringsAsFactors=F)
names(accidents) <- tolower(names(accidents))

persons <- read.csv('data/FARS2016NationalCSV/person.csv', stringsAsFactors=F)
names(persons) <- tolower(names(persons))

vehicles <- read.csv('data/FARS2016NationalCSV/vehicle.csv', stringsAsFactors=F)
names(vehicles) <- tolower(names(vehicles))

accidents %>%
  group_by(rur_urb) %>%
  summarize(mean_f = mean(fatals))