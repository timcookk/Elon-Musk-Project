# Elon Musk Tweets vs Tesla Stock Return Project
# Isaac McSorley, Tim Cook, Tyler Concialdi, Cade Keenan

rm(list=ls())

#Sys.setenv(BEARER_TOKEN= 'AAAAAAAAAAAAAAAAAAAAAP%2FybAEAAAAAgTaXRyY2%2Fgdmxk4o%2BLOcr4ba7TI%3DgAeYLwqGaq3Z39Yz2o4Bk1wqF1LOHHJWzMkpdZO4VzdFQFfQTk')
library(httr)
library(jsonlite)
library(dplyr)
library(readxl)
#library(twitteR)
tesla<-read_excel('TSLA2.xls')
tesla$created <- as.Date(tesla$Date,
                       format = "%m-%d-%Y")

tesla$StockReturn<-((tesla$Close-tesla$Open)/tesla$Open)*100

# We used the following code to scrape elon's tweets, then we put the tweets into a dataframe 
# and saved it as a .csv file to use later

  #?userTimeline # Return timeline of user's tweets, retweets, and replies
  #musk_tweets<-userTimeline('elonmusk', 
                         # n=3200,# Max number to return
                          #includeRts=TRUE, # Include retweets?
                         # excludeReplies=FALSE) # Exclude replies?
  #musk_df<-twListToDF(musk_tweets)
  #write.csv(musk_df, 'musk_df.csv') #Writing to csv to save and use later

#Now using the dataframe we saved
#setwd('~/downloads')
musk_df<-read.csv('musk_df.csv')
musk_df$created<-as.Date(musk_df$created) # need to make sure this column is in the same form 
                                          # as the stock data
tweets_summary<-musk_df %>% group_by(created) %>% tally() #total tweets on each day (including retweets)

retweets_summary<-musk_df %>% group_by(created) %>% tally(retweetCount) #total retweets from those tweets above

favorites_summary<-musk_df %>% group_by(created) %>% tally(favoriteCount) #Total favorites from those tweets above


#### Now merging the above summaries
tweets_retweets<-merge(tweets_summary,retweets_summary,all.x=T,by='created') #merging tweets and retweets

tweets_retweets_favorites<-merge(tweets_retweets,favorites_summary,all.x=T,by='created') #merging tweets/retweets and favorites

twittertesla<-merge(tweets_retweets_favorites,tesla,all.x=T,by='created') #merging all with stock data


# Change columns names
names(twittertesla)[names(twittertesla) == "n.x"] <- "TweetCount"
names(twittertesla)[names(twittertesla) == "n.y"] <- "RetweetCount"
names(twittertesla)[names(twittertesla) == "n"] <- "LikeCount"

# Graph of tesla stock return and price over the data
library(ggplot2)
ggplot( data = tesla, aes( Date, StockReturn ),na.rm=T) + geom_line() + labs(y= "Tesla Return", x = "Date")

ggplot( data = tesla, aes( Date, Close ),na.rm=T) + geom_line() + labs(y= "Tesla Stock Price", x = "Date")

# Summary table for top 5 returns by date

data_new <- twittertesla[order(twittertesla$StockReturn, decreasing = TRUE), ]

y<-head(data_new, 5,na.rm=T) 
y

top5returns<-sort(table(y$StockReturn),decreasing=TRUE)[5:1]
top5returns

summarytable<-summarize(data_new,
                        Date = y$Date,
                        Count = row.names(top5returns))

names(summarytable)[names(summarytable) == "Count"] <- "Tesla Returns"

summarytable #shows the date of the biggest returns 

# Top 5 Retweets and Corresponding Dates
# install.packages('plyr')
library(plyr)

data_new1 <- twittertesla[order(twittertesla$RetweetCount, decreasing = TRUE), ]

x<-head(data_new1, 5,na.rm=T)
x # top 5 retweet count in decreaseing order

library(ggplot2)
x |> 
  filter(!is.na(x$Date)) |> 
  group_by(x$Date) |> 
  summarize(retweets = RetweetCount) |> 
  ggplot(aes(x = retweets, y = as.factor(x$Date))) +
  geom_bar(position="stack",stat = "identity") + 
  coord_flip() +
  geom_text(aes(label = retweets), size = 3, hjust = 0.5, vjust = 3, position="stack") +
  labs(y= "Date", x = "Retweets") # visualize it with a graph of dates and top 5 retweets


#### Summary statistic averages of tweet, retweet, and like count and comparing to stock price when he has more  
###  than average number of tweets, retweets, or likes 
clean<-na.omit(data_new)
clean<-subset(clean, select=c(Date, TweetCount,RetweetCount,LikeCount, StockReturn))
summary(clean$TweetCount) # Averages 10 tweets per day
summary(clean$RetweetCount) # Averages 91782 retweets per day
summary(clean$LikeCount) # Averages 939792 likes per day
summary(clean$StockReturn) #Average -.2 percent change per day


#Above average number of tweets vs stock return
aboveAverageTweets<-subset(clean, clean$TweetCount>10)  #subsetting to look at days where he tweeted more than average 
summary(aboveAverageTweets$StockReturn) # -.1, this is a slight increase meaning there could be a correlation between if Elon tweets more the stock price does not decrease as much

#Above average number of retweets vs stock return
aboveAverageRetweets<-subset(clean, clean$RetweetCount>91782)
summary(aboveAverageRetweets$StockReturn) # -4.3, this does not prove a positive correlation between above average retweet count and stock return, 
                                          # but could be negative tweets that made people sell more tesla stock that day


#Above average number of Likes vs stock return
aboveAverageLikes<-subset(clean, clean$LikeCount>939792)
summary(aboveAverageLikes$StockReturn) # -3.4,  this does not prove a positive correlation between above average retweet count and stock return, 
                                                #but could be negative tweets that made people sell more tesla stock that day


# Number of tweets vs stock return visualization
ggplot(clean, aes(x=TweetCount, y=StockReturn)) + geom_point() + labs(y= "Tesla Return", x = "Tweets")

# Number of retweets vs stock return visualization

ggplot(clean, aes(x=RetweetCount, y=StockReturn)) + geom_point() + labs(y= "Tesla Return", x = "Retweets")

# Number of likes vs stock return visualization

ggplot(clean, aes(x=LikeCount, y=StockReturn)) + geom_point() + labs(y= "Tesla Return", x = "Likes")


## CONCLUSION

  # After analyzing the graphs and the summary statistics, we cannot prove any correlation between
  # number of tweets, likes, or retweets and the Tesla stock price


## Limitations
  # We were only able to get tweets back to July of 2021 because the twitter api
  # only allowed us 700 tweets and we believe if we would have been able to get more data
  # that we could have had a better opportunity to find a correlation. 
