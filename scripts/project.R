library(dplyr)
library(tidyverse)
library(sf)
library(jsonlite)
library(USAboundaries)
library(leaflet)
library(tibbletime)
library(ggthemes)
library(scales)

httpgd::hgd()
httpgd::hgd_browse()

dat <- read.csv("data/ChristmasSongs.csv")

dat$Date <- as.Date(dat$Date, "%Y-%m-%d")

glimpse(dat)

dat20 <- dat %>% filter(Date >= ("2020-01-01"))

glimpse(dat20)

dat20 %>% ggplot(aes(x = Date, fill = Christmas)) +
    geom_bar(stat = "count", position = "fill")
