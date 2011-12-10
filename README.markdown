Stuff to do:
  - add Users
  - add Microposts
  - limit posts to 140 bytes
  - connect users and posts


Workflow

 1. initialize project (rails new <appname> [-T])

 1. edit Gemfile
    bundle install

 1. rails generate rspec:install

 1. git init
    git add .
    git commit -m 'Starting up'

 1. Update README

 1. Set up github repo (optional)
    git remote add original git@github.com:<username>/<appname>.git
    git push origin master

 1. heroku create (optional)
    git push heroku master

 1. git checkout [-b] branchname
    [add feature]
    [test feature locally]
    git commit -a
    
 1. git checkout master
    git merge branchname
    git push
    git push heroku
    [test feature at heroku]

 1. go to step 8