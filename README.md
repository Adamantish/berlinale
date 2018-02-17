## Berlinale Now

### Which Berlinale film tickets are available online right now? Which ones should I buy tomorrow?

#### It lives [here](http://nowberlinale.herokuapp.com)

The official berlinale.de website is a bit annoying. If you don't know exactly what you're after you have to click through 28 pages scrutinising tiny little icons to see if they're grey (good) or white (not good).

This Ruby on Rails site just automates that process. :)

This project has a shelflife of probably just a week or two but in the evening since it was launched it's looking pretty popular. PRs very welcome! Top issues are:

Take a look at the issues page and speak up if you're going to start work on something.

#### Tests

Have fallen behind with maintaining the tests but there are a bunch for part of the backend import process
```
rspec
```

#### Deployment

Heroku automatically deploys the github master.
Migrations need running separately though so point them out in any PR.

Using one "Hobby" size dyno right now.
