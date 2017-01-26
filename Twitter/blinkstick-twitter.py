from Bstick import Bstick
import tweepy
import sys

# Read values from access.txt to use with accessing Twitter stream
access = dict()
with open('access.txt', 'r') as fp:
    for line in fp:
        y = line.split('=')
        access[y[0].strip()] = y[1].strip()

API_KEY = access['consumer_key']
API_KEY_SECRET = access['consumer_key_secret']
ACCESS_TOKEN = access['access_token']
ACCESS_TOKEN_SECRET = access['access_token_secret']

HASHTAG = access['hashtag']

bstick = Bstick.Stick(r_led_count=32, max_rgb_value=255)
if not bstick.connect():
    print "no Blinkstick found"
    sys.exit()
else:
    print "Found Blinkstick"

class MyStreamListener(tweepy.StreamListener):
    def on_status(self, status):  # When a status has been posted with certain keywords
        print status.text

        str = status.text  # The text from the tweet

        index_of_hashtag = str.find(HASHTAG)  # finding the index of the hashtag

        str = str[index_of_hashtag:len(str)]  # slicing the string to only use the hashtag and what comes next
        str = str.split()  # split the string

        if len(str) == 1:
            print 'no color specified'
            return

        # Check for RGB values
        if len(str) >= 4 and str[1].isdigit() and str[2].isdigit() and str[3].isdigit():
            red = int(str[1])
            green = int(str[2])
            blue = int(str[3])
            colors = [red, green, blue]
            bstick.change_led_color(colors)
            return

        color = str[1].strip()  # setting the color name to the argument coming after the hashtag
        print color

        if color == "random":  # this is a bad fix for random, the issue is probably because of char and strings
            bstick.change_led_random()
        elif color[0] == '#': # When using hex numbers for colors, issue might be if someone writes another hashtag after the one we're listening for
            bstick.change_color_hex(color)
        else:
            bstick.change_color_name(color)

    def on_error(self, status_code):
        print status_code
        if status_code == 420:
            myStream.disconnect()
            test_stream()
        elif status_code == 401:
            myStream.disconnect()
            test_stream()


# To use twitter Api you need to create an app at apps.twitter.com
auth = tweepy.OAuthHandler(consumer_key=API_KEY, consumer_secret=API_KEY_SECRET)
auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

api = tweepy.API(auth)  # Connect to API

myStreamListener = MyStreamListener()  # Create a listener from previously created class

myStream = tweepy.Stream(auth=api.auth, listener=myStreamListener)  # Start a stream


def test_stream():
    myStream.filter(track=[HASHTAG])  # Here we filter out what we want to mine from


if __name__ == '__main__':
    test_stream()
