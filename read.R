library(dplyr)
library(ggplot2)
library(ggmap)
library(rjags)

# Read datasets #
#---------------#

accidents <- read.csv('data/FARS2016NationalCSV/accident.csv', stringsAsFactors=F)
names(accidents) <- tolower(names(accidents))

# Recode hour-minute of accident into minute-of-day, removing "unknown" values
accidents$time <- ifelse(accidents$hour == 99 | accidents$minute == 99, NA, accidents$hour * 60 + accidents$minute)
accidents$time <- accidents$time + 1

# JAGS #
#------#

jags <- jags.model('model.bug',
                   data = list('time' = accidents$time,
                               'N' = length(accidents$time)),
                   n.chains = 4,
                   n.adapt = 100)

jags.samples(jags, c('a', 'b'), 1000)






persons <- read.csv('data/FARS2016NationalCSV/person.csv', stringsAsFactors=F)
names(persons) <- tolower(names(persons))

vehicles <- read.csv('data/FARS2016NationalCSV/vehicle.csv', stringsAsFactors=F)
names(vehicles) <- tolower(names(vehicles))

accidents %>%
  group_by(rur_urb) %>%
  summarize(mean_f = mean(fatals))

# Get drivers who died
drivers <- persons[persons$seat_pos == 11 & persons$inj_sev %in% c(4,6),]
driver.ages <- drivers %>% filter(age < 998) %>% group_by(harm_ev) %>% summarize(count=n(), avg.age=mean(age))


# Mailboxes
map.data <- accidents[accidents$harm_ev == 53,]

# Boulder
map.data <- accidents[accidents$harm_ev == 17,]

# Fell/jumped from vehicle
map.data <- accidents[accidents$harm_ev == 5,]


map.data <- accidents[accidents$weather <= 12, c("latitude", "longitud", "weather")]

map.data <- accidents[accidents$st_case == 370104,]

map <- get_map(location='United States',
               maptype="terrain",
               zoom=4)

ggmap(map) + 
  geom_point(data=map.data, aes(x=longitud, y=latitude), alpha=0.5)
