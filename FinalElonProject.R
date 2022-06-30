# Elon Musk Tesla Stock Project
# Isaac McSorley, Tim Cook, Tyler Concialdi, Cade Keenan

rm(list=ls())
#Sys.setenv(BEARER_TOKEN= 'AAAAAAAAAAAAAAAAAAAAAP%2FybAEAAAAAgTaXRyY2%2Fgdmxk4o%2BLOcr4ba7TI%3DgAeYLwqGaq3Z39Yz2o4Bk1wqF1LOHHJWzMkpdZO4VzdFQFfQTk')
library(httr)
library(jsonlite)
library(dplyr)
library(readxl)
#library(twitteR)
tesla<-read_excel('TSLA2.xls')
View(tesla)
tesla$created <- as.Date(tesla$Date,
                       format = "%m-%d-%Y")

tesla$StockReturn<-(tesla$Close-tesla$Open)/tesla$Open
# We used the following code to scrape elon's tweets, then we put the tweets into a dataframe 
# and saved it as a .csv file to use later

  #appname<-"Elon v3"
  #key<-'1I6DdpphjUlAEDT3B4RN3qmYQ'
  #secret<-'ri127qTOCggRdWuEEOYgiF1qb2toDt5pglCIStz8q3yhSYShqW'
  #access_token<-'1169664618639319041-vcyxyLZRaxntq5CngKreGVE6rWOh1m'
  #access_secret<-'bsWqdKFm1n7IFVP33TB9lD3irdfIFWuX07ukTLKfJQTPY'
  #setup_twitter_oauth(key, secret, access_token, access_secret)


  #?userTimeline # Return timeline of user's tweets, retweets, and replies
  #musk_tweets<-userTimeline('elonmusk', 
                         # n=3200,# Max number to return
                          #includeRts=TRUE, # Include retweets?
                         # excludeReplies=FALSE) # Exclude replies?
  #musk_df<-twListToDF(musk_tweets)
  #write.csv(musk_df, 'musk_df.csv') #Writing to csv to save and use later

#Now using the dataframe we wrote

musk_df<-read.csv('musk_df.csv')
musk_df$created<-as.Date(musk_df$created) # need to make sure this column is in the same form 
                                          # as the stock data
View(musk_df)
tweets_summary<-musk_df %>% group_by(created) %>% tally() #total tweets on each day (including retweets)
tweets_summary

retweets_summary<-musk_df %>% group_by(created) %>% tally(retweetCount) #total retweets from those tweets above
retweets_summary

favorites_summary<-musk_df %>% group_by(created) %>% tally(favoriteCount) #Total favorites from those tweets above
favorites_summary

tweets_retweets<-merge(tweets_summary,retweets_summary,all.x=T,by='created') #merging tweets and retweets

tweets_retweets_favorites<-merge(tweets_retweets,favorites_summary,all.x=T,by='created') #merging tweets/retweets and favorites

twittertesla<-merge(tweets_retweets_favorites,tesla,all.x=T,by='created') #merging all with stock data

View(twittertesla)

# Change columns names
names(twittertesla)[names(twittertesla) == "n.x"] <- "TweetCount"
names(twittertesla)[names(twittertesla) == "n.y"] <- "RetweetCount"
names(twittertesla)[names(twittertesla) == "n"] <- "LikeCount"

# Summary table for top 5 returns by date
data_new <- twittertesla[order(twittertesla$StockReturn, decreasing = TRUE), ]
View(data_new)

y<-head(data_new, 5,na.rm=T)
View(y)

top5returns<-sort(table(y$StockReturn),decreasing=TRUE)[5:1]
View(top5returns)


summarytable<-summarize(data_new,
                        Date = y$Date,
                        Count = row.names(top5returns))
View(summarytable)

# Graph of tesla stock return over the data
tesla$StockReturn<-(tesla$Close-tesla$Open)/tesla$Open

ggplot( data = tesla, aes( Date, StockReturn ),na.rm=T) + geom_line() 


# Top 5 Retweets and Corresponding Dates
install.packages('plyr')
library(plyr)

data_new1 <- twittertesla[order(twittertesla$RetweetCount, decreasing = TRUE), ]
View(data_new1)

x<-head(data_new1, 5,na.rm=T)
View(x)

library(ggplot2)
x |> 
  filter(!is.na(x$Date)) |> 
  group_by(x$Date) |> 
  summarize(retweets = RetweetCount) |> 
  ggplot(aes(x = retweets, y = as.factor(x$Date))) +
  geom_bar(position="stack",stat = "identity") + 
  coord_flip() +
  geom_text(aes(label = retweets), size = 3, hjust = 0.5, vjust = 3, position="stack")
