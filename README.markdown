Stuff to do:
  + add Users  
  + enable Users to register  
  + enable Users to sign in  
  - enable Users to sign out
  - add Microposts  
  - limit posts to 140 bytes  
  - connect users and posts  
  + figure out how to get markdown to format more nicely  
  + figure out how to get the navigator helper to render properly and  
    use it

Setup

 1. initialize project (rails new <appname> [-T])

 1. edit Gemfile  
    bundle install

 1. rails generate rspec:install

 1. git init  
    git add .  
    git commit -m 'Starting up'

 1. Update README

 1. Set up github repo (optional)  
    git remote add origin git@github.com:<username>/<appname>.git  
    git push origin master

 1. heroku create (optional)  
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

Floating Bookmarks

Either as an evolution of this project or as a new project, I want to
build a site that provides floating bookmarks. It will support user
login and management like Michael's sample app. However, I'd like to
turn the microposts into bookmarks. A bookmark will need the following
fields:

  - bookmark id (number)
  - name (short text)
  - url (text)
  - mr_click (date/time) -- "most recent click"
  - notes (long text)
  - group (number) -- may be empty, meaning this bookmark is in the  
    user's default group
  - group_order (number)

Users can create groups to organize their bookmarks. Groups need the
following fields:

  - group id (number)
  - name (short text)
  - type (short text)
  - owner (number - user id)

Group type can take on a limited number of values indicating how the
group behaves.

  - "float" groups have bookmarks that rise to the top of the group
    when clicked. This puts the most frequently used bookmarks near
    the top of the group list.
  - "sink" groups have bookmarks that sink to the bottom of the group
    when clicked. This allows the user to visit each book mark in the
    list conveniently and see when all the bookmarks have been visited.
  - "static" groups don't change their order when bookmarks are
    clicked. Rather the user controls the order of the bookmarks
    directly.
