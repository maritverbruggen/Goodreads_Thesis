library(haven)
library(readr)
library(tidyr)
library(dplyr)
library(tidyverse)
library(scales)

rm(list=ls())
author <- read.csv("../Datasets/author_df.csv")
book_info <- read.csv("../Datasets/book_df_cleanPublisher.csv")
reviews <- read.csv("../Datasets/reviews_thesis_text.csv")
ratings <- read.csv("../Datasets/reviews_thesis_notext.csv")
giveaways <- read.csv("../Datasets/giveaways_thesis.csv")
View(ratings)
View(reviews)

#clean author en book information file 
author <- subset(author, select=-c(author_role,author_link, author_ratings_count, author_reviews_count))
book_info <- subset(book_info, select=c(id, book_publication_date, title,average_rating, num_pages, ratings_count, text_reviews_count))
ratings <- subset(ratings, select =c(book_id, review_id, new_review_id, ratings, time))
giveaways <- subset(giveaways, select=c(giveaway_id, book_id, copy_n, request_n, giveaway_start_date, giveaway_end_date))


