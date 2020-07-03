import pandas as pd
import numpy as np
from textblob import TextBlob
from wordcloud import WordCloud, STOPWORDS
import plotly.plotly as py
import plotly.graph_objs as go
from plotly.offline import iplot
import regex as re
#import cufflinks
#cufflinks.go_offline()
#cufflinks.set_config_file(world_readable=True, theme='pearl', offline=True)


#clean data
def clean_tweet(tweet):
    print("cleaning done")
    return ' '.join(re.sub('(@[A-Za-z0-9]+)|([^0-9A-Za-z \t])|(\w+:\/\/\S+)', ' ', tweet).split())

#textblob data
def analyze_sentiment(tweet):
    analysis = TextBlob(tweet)
    print("in sentiment")
    if analysis.sentiment.polarity > 0:
        return 'Positive'
    elif analysis.sentiment.polarity ==0:
        return 'Neutral'
    else:
        return 'Negative'



if __name__ == '__main__':
    swt_df = pd.DataFrame()
    swt_df=pd.read_csv('spiritselc_attr.csv')
    length = len(swt_df)
    print(length)
    clean_text= []
    tweet_sentiment = []
    for x in range(0,length):
        plaintext= swt_df['text'][x]
        cleantext = clean_tweet(plaintext)
        sentiment = analyze_sentiment(cleantext)
        clean_text.append(cleantext)
        tweet_sentiment.append(sentiment)
    swt_df['cleaned_tweet']= clean_text
    swt_df['sentiment'] =tweet_sentiment
    swt_df.to_csv('spiritsentiment.csv', sep=',')



