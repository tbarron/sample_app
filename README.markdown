Stuff to do:
  - add Users
  - add Microposts
  - limit posts to 140 bytes
  - connect users and posts
  - figure out how to get markdown to format more nicely
  - figure out how to get the navigator helper to render properly and
    use it

Setup

 1. initialize project (rails new <appname> [-T])

 1. edit Gemfile<br>
	bundle install

 1. rails generate rspec:install

 1. git init<br>
	git add .<br>
	git commit -m 'Starting up'

 1. Update README

 1. Set up github repo (optional)<br>
	git remote add original git@github.com:<username>/<appname>.git<br>
	git push origin master

 1. heroku create (optional)<br>
	git push heroku master

Workflow

 1. git checkout [-b] devel

 1. write a test

 1. work on code until all tests pass

 1. git commit -a
    
 1. git checkout master
    git merge branchname
    git push
    git push heroku
    [test feature at heroku]

 1. git checkout devel

 1. back to step 2