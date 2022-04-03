#import packages 
library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)

#load data 
reviews <- read.csv("../../Datasets/reviews_thesis_notext.csv")

#check whether NAs included 
sum(is.na(review$ratings))

#distribution of ratings
table(review$ratings)

#min and max rating
min(review$ratings)
max(review$ratings)

#create sample for easier calculations 
review <- reviews[sample(nrow(reviews), 1000), ]
ggplot(review, aes(x = ratings)) +
  geom_bar() + 
  xlab("Rating Score") + ylab("Number of Ratings") +
  geom_text(stat="count", aes(label=..count..), vjust=0) +
  geom_text(stat="count", aes(label = scales::percent((..count..)/sum(..count..))),
            color="white", vjust=5)+ 
  theme_minimal()

#cumulative amount of ratings over time 
#create new column to be able to perform cumsum for amount of ratings
for (i in seq(1,length(review$ratings))){
  if (is.na(review$ratings[i]) == FALSE){
    review$ratings_counter[i] <- "1"
  }else{
    review$ratings_counter[i] <- "0"
  }
}

#reformat time variable
review$time <- str_replace(review$time, ",","")
review$time <- str_replace(review$time, " ", "/")
review$time <- str_replace(review$time, " ", "/")
review$time_form <- as.Date(review$time, format="%b/%d/%Y")
review <- review[order(review$time_form),]
review$cumsum <- cumsum(review$ratings_counter)
ggplot(review, aes(x=time_form, y=(cumsum))) + geom_line()

#Calculate and Visualize amount of Ratings per Month 
review$ratings_counter <- as.numeric(review$ratings_counter)
review_month <- review %>% 
  group_by(month = lubridate::floor_date(time_form, "month")) %>%
  summarize(summary_variable = sum(ratings_counter))
review_month$cumsum <- cumsum(review_month$summary_variable)

ggplot(review_month, aes(x=month, y=summary_variable)) + geom_line() +
  scale_x_date(date_breaks = "1 year",
               labels=date_format("%Y"),
               limits = as.Date(c('2013-01-01','2022-01-01'))) + 
  ylab("Amount of Ratings per Month") + xlab("Year")

#Calculate and Visualize amount of Ratings per Day
review$ratings_counter <- as.numeric(review$ratings_counter)
review_week <- review %>% 
  group_by(week = lubridate::floor_date(time_form, "week")) %>%
  summarize(summary_variable = sum(ratings_counter))
review_week$cumsum <- cumsum(review_week$summary_variable)

ggplot(review_week, aes(x=week, y=summary_variable)) + geom_line() +
  scale_x_date(date_breaks = "1 year",
               labels=date_format("%Y"),
               limits = as.Date(c('2017-01-01','2021-06-01'))) + 
  ylab("Amount of Ratings per Week") + xlab("Year")
View(review_week)

ggplot(review_week, aes(x=week, y=cumsum)) + geom_line() + 
  scale_x_date(date_breaks = "1 year",
               labels = date_format("%Y"),
               limit = as.Date(c('2017-01-01','2021-06-01')))+
  ylab("Cumulative Ratings") + xlab("Year")

#average rating over time 
mean()

