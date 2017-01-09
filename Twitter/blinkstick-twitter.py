from blinkstick import blinkstick
import tweepy

# These keys and tokens are from an app I created plus my personal account
API_KEY = 'value'
API_KEY_SECRET = 'value'
ACCESS_TOKEN = 'value'
ACCESS_TOKEN_SECRET = 'value'

HASHTAG = "#cybercomgbgblinkstick"

bsticks = blinkstick.find_all()


class MyStreamListener(tweepy.StreamListener):
    def on_status(self, status):  # When a status has been posted with certain keywords
        print status.text

        str = status.text  # The text from the tweet

        index_of_hashtag = str.find(HASHTAG)  # finding the index of the hashtag

        str = str[index_of_hashtag:len(str)]  # slicing the string to only use the hashtag and what comes next
        str = str.split()  # split the string

        # TODO fix list index out of range when just using the hashtag
        color = str[1]  # setting the color name to the argument coming after the hashtag
        print color

        if color == "random":  # this is a bad fix for random, the issue is probably because of char and strings
            for bstick in bsticks:
                for x in range(0, 32):
                    bstick.set_color(channel=0, index=x, name="random")
        elif color[0] == '#':
            for bstick in bsticks:
                for x in range(0, 32):
                    bstick.set_color(channel=0, index=x, hex=color)
        else:
            for bstick in bsticks:
                for x in range(0, 32):
                    bstick.set_color(channel=0, index=x, name=color)

    def on_error(self, status_code):
        print status_code
        if status_code == 420:
            myStream.disconnect()
            return False


# To use twitter Api you need to create an app at apps.twitter.com
auth = tweepy.OAuthHandler(consumer_key=API_KEY, consumer_secret=API_KEY_SECRET)
auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

api = tweepy.API(auth)  # Connect to API

myStreamListener = MyStreamListener()  # Create a listener from previously created class

myStream = tweepy.Stream(auth=api.auth, listener=MyStreamListener())  # Start a stream


def test_stream():
    myStream.filter(track=[HASHTAG])  # Here we filter out what we want to mine from


if __name__ == '__main__':
    test_stream()
