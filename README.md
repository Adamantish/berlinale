##Berlinale Now

### Which Berlinale film tickets are available online right now?

#### A website which lives [here](http://nowberlinale.herokuapp.com)

The official berlinale.de website is a bit annoying. If you don't know exactly what you're after you have to click through 28 pages scrutinising tiny little icons to see if they're grey (good) or white (not good).

This site just automates that process. :)

This project has a shelflife of probably just a week but in the evening since it was launched it's looking pretty popular. PRs very welcome! Top issues are:

- You can't narrow down by date
- Contains none of the supporting the information / photo to help decide if you want to click.

Take a look at the issues page and speak up if you're going to start work on something.

#### Tests

```
rspec
```
Only covers the backend import process right now. Could do with at least a controller test.

#### Deployment

Heroku automatically deploys the github master.
Migrations need running separately though so point them out in any PR.

Using one "Hobby" size dyno right now.
