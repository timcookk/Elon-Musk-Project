# ElonTweetsTeslaStock
If you follow technology, entrepreneurship, or space exploration, you more recently may have been introduced to Tesla or its CEO Elon Musk. Following Musk in the news, you might have noticed the pioneering capitalist tweets out whatever comes to his mind at a given moment, regarding his own companies, geo-politics, cryptocurrencies, and the occasional witty meme. Some of these tweets have come back to bite him in the form of large sellouts of Tesla shares. A fortune.com article shared that one single tweet from Musk on November 6, 2021, about selling a portion of his Tesla shares sent Tesla stock price plummeting by 7.3% in one day (Vercoe, 2021). 

## Table of Contents
* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Screenshots](#screenshots)
* [Usage](#usage)
* [Contact](#contact)
* [Conclusion](#Conclusion)
<!-- * [License](#license) -->


## General Information
- For our analysis, we began focusing towards attempting to build a relationship between the number of tweets Musk had on a specific day, or what exactly Elon tweeted, and Tesla’s stock price. 
- We want to know if there is a specific relationship between Elon’s tweets and the stock price of his company.
- Research Question: Is there a correlation between Elon Musk’s tweets and Tesla stock price? 

## Technologies Used
- R - v2022.02.2+485
- RStudio - v2022.02.2+485

## Screenshots
We created these visualzations in R in order to see if there could be any correlations <br/>
<br/>
![Screenshot 2022-05-05 180159](https://user-images.githubusercontent.com/90923213/167041005-55d82575-7868-4768-89b6-fed7b977b327.png)
![Screenshot 2022-05-05 180257](https://user-images.githubusercontent.com/90923213/167041006-7363458b-69f5-4674-950d-98f19c3703bb.png)
![Screenshot 2022-05-05 180240](https://user-images.githubusercontent.com/90923213/167041008-da385c8d-16e1-4271-b6bc-0de18c93bb4b.png)
![Screenshot 2022-05-05 180228](https://user-images.githubusercontent.com/90923213/167041009-eeafd5bd-2787-473f-b806-edaac6d7016a.png)
![Screenshot 2022-05-05 180216](https://user-images.githubusercontent.com/90923213/167041010-2824beac-2e93-49a8-b267-975af0fab4f9.png)


<!-- If you have screenshots you'd like to share, include them here. -->

## Interpretation
After analyzing the graphs and looking at the summary statistics comparing when he tweeted above average, it is hard to tell if there is a correlation between his tweets and stock return with the data that we have. The above average tweets per day showed there could be a possible positive correlation between tweets per day and price of stock because the average stock return was higher than normal, but for the above average number of retweets and likes, there was a below average stock return correlated with this. In the graphs, the data points show no definitive correlation, and the scatter plot has no correlation.  
## Usage
See 'ElonMuskProject.R' in 'Code' to see our entire R file with comments on usage 

## Conclusion  
We believe that the key to improving our project is more data, the Twitter API only let us pull up to 700 tweets, which did not give us a full year of data to work with. We had to include retweets in order to get more data, but we believe retweets are not as important as his tweets. We also believe that it would be worthwhile to do a more in-depth analysis of the texts that he uses in his tweets, because we are unable to categorize his tweets with positive or negative connotations and there could be both positive and negative correlations with the stock return. We believe that if we could get more data and look further back into time that we could build a stronger case, but with the data that we had we would answer that we were not able to find a correlation between the number of tweets Elon has and the Tesla stock return.  




## Contact
Created by [@cadekeenan] <br>
Created by [@immcsorley] <br>
Created by [@timcookk] <br>
