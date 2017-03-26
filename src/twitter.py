import signal
import sys
#Import the necessary methods from tweepy library
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream
import json
import pandas as pd

#Variables that contains the user credentials to access Twitter API
access_token = "2861823458-cdJnVX9CDj3EBljjHkyCSE6BESjvaBYyIOV1zvc"
access_token_secret = "aKNNpJHz9Om1L9kykRDxmlAT2oihWKlUxbg7duf8tpW96"
consumer_key = "QLtCUIQZuflDeP3JE2TZBBFqH"
consumer_secret = "Fziz4yUJVD6dJ6C0Js0Mxa4zmlB0UhpVzws8qbXXvdwPURoWLt"


#This is a basic listener that just prints received tweets to stdout.
class StdOutListener(StreamListener):
    tweetspath = "data/twitter_data.txt"
    tweets = []
    tweettexts = []

    def __init__(self):
        open(self.tweetspath, 'w').close()
        fd = open(self.tweetspath, 'w')
        def signal_handler(signal, frame):
            for t in self.tweets:
                try:
                    fd.write(t['text'])
                except Exception:
                    pass
            print (len(self.tweets), end='')
            print (" Tweets Read")
            sys.exit(0)

        signal.signal(signal.SIGINT, signal_handler)

    def on_data(self, data):
        tweet = json.loads(data)
        self.tweets.append(tweet)
        return True

    def on_error(self, status):
        print (status)

    
if __name__ == '__main__':
    term = input("Input:")
#This handles Twitter authetification and the connection to Twitter Streaming API
    l = StdOutListener()
    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    stream = Stream(auth, l)

    #This line filter Twitter Streams to capture data by the keywords: 'python', 'javascript', 'ruby'
    stream.filter(track=term.split())


