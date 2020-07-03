import nltk
from nltk.corpus import stopwords
import string
import gensim
from gensim import corpora
import csv
tweetList=[]
stops = set(stopwords.words("english"))
stemmer = nltk.stem.SnowballStemmer('english')
lemmatizer = nltk.wordnet.WordNetLemmatizer()

with open('spiritpositivetweets.csv',mode='r', encoding="utf8") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter =',')
    line_count = 0
    for row in csv_reader:
        rawTweet = row[1]
       # print(rawTweet)
        processedTweet = rawTweet.strip()
        processedTweet = processedTweet.translate(str.maketrans('','',string.punctuation))
        tweetTokens = nltk.word_tokenize(processedTweet)

        for token in tweetTokens:
            if token in stops:
                tweetTokens.remove(token)

        for token in tweetTokens:
            oldToken = token
            tweetTokens.remove(token)
            oldToken = lemmatizer.lemmatize(oldToken)
            tweetTokens.append(oldToken)

        processedTweet = ' '.join(tweetTokens)
        #print(processedTweet)

        if len(tweetTokens) > 3:
            tweetList.append(processedTweet)
        #print(tweetList)

    texts = [[text for text in doc.split()] for doc in tweetList]
    #print(texts)
    dictionary = corpora.Dictionary(texts)
    doc_term_matrix = [dictionary.doc2bow(doc.split()) for doc in tweetList]
    #print(doc_term_matrix)
    ldaObject = gensim.models.ldamodel.LdaModel
    ldaModel = ldaObject(doc_term_matrix,num_topics=3,id2word=dictionary,passes=15)
    topics = ldaModel.print_topics(num_topics=3, num_words=10)
    print("topics are")
    print(topics)
    print("LDA analysis complete")
    with open('sprittopics.csv', mode='a') as topic_file1:
        topic_writer1 = csv.writer(topic_file1, delimiter=',')
        topic_writer1.writerow(topics)
