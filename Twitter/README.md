Blinkstick + Twitter Readme



In order to be able to use this application you need to create an app on apps.twitter.com with your twitter account. 
Replace these value in access.txt that you get from apps.twitter.com:
consumer_key
consumer_key_secret
access_token
access_token_secret
hashtag (either a normal hashtag or a person, don't forget # or @)

You also need to install the libraries blinkstick and tweepy using python pip:
sudo pip install blinkstick
sudo pip install tweepy


To change the value of the blinkstick you send a tweet containing the hashtag and the color afterwards. Works with both hashtag and people reference.
#hashtag color
@person color

E.g:
#cybercomgbgblinkstick green
@cybercomgbgblinkstick green

Also works with hex color.
E.g:
#cybercomgbgblinkstick #00ff00
@cybercomgbgblinkstick #00ff00
