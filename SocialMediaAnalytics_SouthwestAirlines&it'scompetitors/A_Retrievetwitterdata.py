import pandas as pd
import tweepy
import jsonpickle

##setting credentials to authorize and access twitter

# Consume:
CONSUMER_KEY    = "*******************************"
CONSUMER_SECRET = "*******************************************"

# Access:
ACCESS_TOKEN  = "********************************************************"
ACCESS_SECRET = "*************************************"

# Setup access API
def connect_to_twitter_OAuth():
    auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
    auth.set_access_token(ACCESS_TOKEN, ACCESS_SECRET)

    api = tweepy.API(auth, wait_on_rate_limit=True)
    return api

def get_save_tweets(filepath, api, query, max_tweets=10000, lang='en'):

    tweetCount = 0
    #query = query
    #lang = lang

    #Open file and save tweets
    with open(filepath, 'a') as f:

        # Send the query
        for tweet in tweepy.Cursor(api.search,q=query,since ='2019-02-10',until='2019-04-26',lang=lang).items(max_tweets):

            #Convert to JSON format
            f.write(jsonpickle.encode(tweet._json, unpicklable='false') + '\n')
            tweetCount += 1

        #Display how many tweets we have collected
        print("Downloaded {0} tweets".format(tweetCount))



if __name__ == '__main__':
    # Create API object
    api = connect_to_twitter_OAuth()
    query = "#Spirit"
    # Get those tweets
    get_save_tweets('spiritAirlines_tweets.json', api, query)
    query = "#southwest"
    get_save_tweets('southwest_tweets.json', api, query)
    #similar for any other interested topics
