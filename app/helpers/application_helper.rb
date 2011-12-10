module ApplicationHelper

  # Return a page-specific title if @title defined, else generic title
  def title
    base_title = "Learning Ruby on Rails"
    if @title.nil?
      return base_title
    else
      return "#{base_title} | #{@title}"
    end
  end

  # Return navigator line with current page unlinked
  def navigator
    links = Array.new
    links = ['About', 'Contact', 'Home', 'Help']
    nav = ""
    sep = ""
    for link in links
      if link == @title
        nav += sep + link
      else
        nav += sep + '<a href="' + link.downcase + '">' + link + '</a>'
      end
      sep = " | "
    end
    return nav
  end

end
