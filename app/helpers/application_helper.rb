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

  # Return the image tag for the logo
  def logo
    image_tag("logo.png", :alt => "Learning RoR", :class => "round")
  end

  # Format a link so that if it points to the current page, it's inactive
  def link_away(text, path, attr = {})
    if (@title == text) || (@title == attr[:title])
      text
    else
      link_to text, path
    end
  end

end
