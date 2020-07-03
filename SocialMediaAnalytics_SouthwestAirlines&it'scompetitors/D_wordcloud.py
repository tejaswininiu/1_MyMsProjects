import pandas as pd
import numpy as np
import nltk
from nltk.corpus import stopwords
import string
from wordcloud import WordCloud
import matplotlib.pyplot as plt

#import cufflinks
#cufflinks.go_offline()
#cufflinks.set_config_file(world_readable=True, theme='pearl', offline=True)
#Models menu -> select punckt -> click download
#You need to do this step once
#nltk.download_gui()
df = pd.DataFrame()
df = pd.read_csv('unitedpostivetweets.csv')
tweets= []
tweetList = []
tokenList = []
totaltweet = " "
maxfav = np.max(df['fav_count'])
maxrt = np.max(df['retweet_count'])
print("maximum likes are", maxfav)
print("maximum retweet count is", maxrt)
fav=df[df['fav_count']==maxfav]
rtw = df[df.retweet_count==maxrt]
fav.to_csv('spiritmaxfav.csv', sep=',')
rtw.to_csv('spiritmaxrtw.csv', sep=',')

stops = set(stopwords.words("english"))
stemmer = nltk.stem.SnowballStemmer('english')
lemmatizer = nltk.wordnet.WordNetLemmatizer()
for x in range(0,len(df)):
    sentence = df['text'][x]
    totaltweet = totaltweet + sentence
#print(totaltweet)
processedTweet = totaltweet.strip()
processedTweet = processedTweet.translate(str.maketrans('','',string.punctuation))
tokens = nltk.word_tokenize(processedTweet)
for token in tokens:
    if token in stops:
        tokens.remove(token)
for token in tokens:
    oldToken = token
    tokens.remove(token)
    oldToken = lemmatizer.lemmatize(oldToken)
    tokens.append(oldToken)
#print(tokens)

#Word frequency distribution
print("@@@@Give me word frequency distribution@@@@")
print(tokens)
wordfreqdist = nltk.FreqDist(tokens)
print(wordfreqdist)
mostcommon = wordfreqdist.most_common(500)
newdf=pd.DataFrame()
newdf['mostcommon']=mostcommon
newdf.to_csv('spiritpos_wordcloud.csv',sep=',')
print(mostcommon)
wordcloud = WordCloud().generate(totaltweet)
plt.imshow(wordcloud)
plt.axis("off")
plt.show()
