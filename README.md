# What is Fallow?

FallowFollow is a web application that facilitates following and unfollowing 
other users on twitter for a specified duration. 

# Is it running someplace?

Nope, FallowFollow has been shut down. It was a fun project but ultimately not 
that useful given the abilities of full featured Twitter clients.

# Setting it up

The last version of FallowFollow that run in production used the following:

* heroku
* heroku scheduler add-on (for DelayedJob)
* heroku sendgrid add-on

To make FallowFollow work with Twitter you'll need to register the application 
with twitter and add the consumer key and secret to the heroku environment 
variables. The keys should be `twitter_consumer_key` and 
`twitter_consumer_secret`.
