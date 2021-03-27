# Kevin Lawver's Silly Little Messaging APIs

This is very much not done, but I think it shows where I was heading when I ran out of the 3 hour time box I put myself in.

I am pretty happy with the Message model and the threading stuff I was able to pull together in a very short amount of time.

## Initial Setup

* You need postgresql for this since I'm using array columns in a couple of places, so that should be running.
* Run `bundle`
* Run `rake db:create`
* Run `rake db:seed`
* `rails s` should work fine and you can fetch messages all you want!

## API

* `/messages`: It's self-documented in `app/controllers/messages` and is the only controller that actually does anything (I ran out of time to do the others, but this is the important one).

## Tests

There are controller tests for the messages controller that should cover the basics.  I tried to get [rspec_api_documentation](https://github.com/zipmark/rspec_api_documentation) but it was being difficult so I bailed so I could get _some_ tests done.  `rspec spec/controllers` should give you a bunch of little green dots.

## Things Left Undone

* API Documentation
* The message tickets and users controllers
* Some more validations and other fun things.
