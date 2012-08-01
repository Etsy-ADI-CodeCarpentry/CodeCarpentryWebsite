# CodeCarpentry Website

The website for the Code Carpentry project.

## Repo Setup
* To do once...
    * [Install RVM](http://beginrescueend.com/rvm/install/).
    * [Install homebrew](https://github.com/mxcl/homebrew/wiki/installation).
    * Install the database: `brew install mongodb`
    * Clone this repo!
    * cd into this repo and say "yes"
    * Install bundler: `gem install bundler --pre --no-rdoc --no-ri`
    * Install all the gems: `bundle`
    * Setup connection to production: `heroku git:remote -a codecarpentry`

* To do frequently...
    * Install all the gems: `bundle`
    * Start the various systems: `rake dev:start`
    * Start the server: `rails s`
    * [Deploy code](https://devcenter.heroku.com/articles/git): `git push origin heroku`
    * Open your browser on `localhost:3000`. Win.
