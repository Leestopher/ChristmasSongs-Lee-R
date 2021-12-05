library(dplyr)
library(tidyverse)
library(sf)
library(jsonlite)
library(USAboundaries)
library(leaflet)
library(tibbletime)
library(ggthemes)
library(scales)
library(ggplot2)

httpgd::hgd()
httpgd::hgd_browse()

dat <- read.csv("data/ChristmasSongs.csv")

dat$Date <- as.Date(dat$Date, "%Y-%m-%d")

glimpse(dat)

dat20 <- dat %>% filter(Date >= ("2020-01-01")) %>%
    mutate(Streams = as.numeric(gsub(",", "", Streams)))

glimpse(dat20)

dat20g <- dat20 %>% group_by(Date, Christmas) %>%
    tally() %>%
    mutate(percent = n / sum(n))

glimpse(dat20g)

dat20g %>% ggplot(aes(x = Date, y = n, fill = Christmas)) +
    geom_bar(stat = "identity", position = "fill") +
    geom_text(aes(label = paste0(sprintf("%1.1f", percent * 100), "%")),
    position = position_fill(vjust = 0.5), colour = "white", size = 1)

dat20 %>% group_by(Singer) %>%
    summarise(TotalStreams = sum(Streams)) %>%
    arrange(desc(TotalStreams))

dat20 %>% group_by(Christmas, Date) %>%
    summarise(TotalStreams = sum(Streams)) %>%
    arrange(desc(TotalStreams))

dat20 %>% group_by(Date) %>%
    summarise(TotalStreams = sum(Streams)) %>%
    arrange(desc(TotalStreams)) %>%
    geom_point(aes(x = Date, y = TotalStreams))

dat20 %>%
    filter(Rank ==1) %>%
    count(Song.Title, Singer, sort = TRUE)

dat20 %>%
    filter(Christmas == 'Y', Rank == 1) %>%
    count(Song.Title, Singer, sort = TRUE)

dat20 %>% group_by(Singer) %>%
    summarise(appearances = n(),
        num1_appearances = sum(Rank ==1),
        distinctsongson100 = n_distinct(Song.Title)) %>%
    arrange(desc(num1_appearances))

dat20 %>% group_by(Singer) %>%
    summarise(Christmas = Christmas,
    appearances = n()
    ) %>%
    distinct()

#Test

dat20 %>% group_by(Singer) %>%
    count(Song.Title, Singer, sort = TRUE) %>%
    distinct()

dat20 %>% group_by(Singer) %>%
    summarise(appearances = n(),
        num1_appearances = sum(Rank ==1),
        distinctsongson100 = n_distinct(Song.Title),
        Christmasartist = Christmas) %>%
        distinct() %>%
    arrange(desc(appearances))