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

dat20 %>%
    group_by(Date) %>%
    filter(Christmas == "Y") %>%
    summarise(TopRank = min(Rank), Date = Date) %>%
    ggplot(aes(Date, reorder(TopRank, desc(TopRank)))) +
    geom_point() +
    theme_bw() +
    labs(title = "Highest Christmas Song Rank",
        x = "Date", y = "Rank")

ggsave("documents/xmasrank.png", plot = last_plot())

dat20 %>%
    group_by(Date) %>%
    filter(Christmas == "Y", Singer == "Mariah Carey") %>%
    summarise(TopRank = min(Rank), Date = Date) %>%
    ggplot(aes(Date, reorder(TopRank, desc(TopRank)))) +
    geom_point() +
    theme_bw() +
    labs(title = "Highest Mariah Carey Song Rank",
        x = "Date", y = "Rank")

ggsave("documents/mariahrank.png", plot = last_plot())


dat20g %>% ggplot(aes(x = Date, y = n, fill = Christmas)) +
    geom_bar(stat = "identity", position = "fill") +
    scale_y_continuous(labels = scales::percent) +
    scale_fill_manual(values = c("#d1b5b5", "#438b70")) +
    labs(title = "Percent of Christmas songs in top 200", x = "Date", y = "% of Top 200 Songs", fill = "Christmas Song")

ggsave("documents/xmaspercentot.png", plot = last_plot())


dat20 %>% group_by(Singer) %>%
    summarise(TotalStreams = sum(Streams)) %>%
    arrange(desc(TotalStreams))

dat20 %>% group_by(Christmas, Date) %>%
    summarise(TotalStreams = sum(Streams)) %>%
    arrange(desc(TotalStreams))

dat20 %>% group_by(Date) %>%
    summarise(TotalStreams = sum(Streams)) %>%
    arrange(desc(TotalStreams)) %>%
    ggplot() +
    geom_point(aes(x = Date, y = TotalStreams))

dat20 %>%
    filter(Rank ==1) %>%
    count(Song.Title, Singer, sort = TRUE)

dat20 %>%
    filter(Christmas == "Y", Rank == 1) %>%
    count(Song.Title, Singer, sort = TRUE)

dat20 %>% group_by(Singer) %>%
    summarise(appearances = n(),
        num1_appearances = sum(Rank ==1),
        distinctsongson100 = n_distinct(Song.Title)) %>%
    arrange(desc(num1_appearances))

dat20 %>% group_by(Singer) %>%
    summarise(Christmas = Christmas,
    appearances = n()) %>%
    distinct()

#Test

dat20 %>% group_by(Singer) %>%
    count(Song.Title, Singer, sort = TRUE) %>%
    distinct()

dat20 %>% group_by(Singer) %>%
    summarise(appearances = n(),
        num1_appearances = sum(Rank ==1),
        distinctsongson100 = n_distinct(Song.Title),
        TotalStreams = sum(Streams),
        Christmasartist = max(Christmas)) %>%
        distinct() %>%
    arrange(desc(TotalStreams)) %>%
    slice(1:10) %>%
    ggplot(aes(x = reorder(Singer, -TotalStreams, sum), y = TotalStreams, fill = Christmasartist)) +
    geom_col() +
    scale_y_continuous(labels = label_number(suffix = " Mil", scale = 1e-6)) +
    scale_fill_manual(values = c("#811d1d", "#17503a")) +
    labs(title = "Top 10 Streamed Artists", x = "Artist", y = "Total Streams", fill = "Christmas Artist")

ggsave("documents/top10streamed.png", plot = last_plot())


