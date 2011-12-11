class PagesController < ApplicationController
  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

  def help
    @title = "Help"
  end

  def home
    @title = "Home"
  end

end

# def link_away(text, path, attr = {})
#   if (@title == text) || (@title == attr[:title])
#     text
#   else
#     link_to text, path
#   end
# end
