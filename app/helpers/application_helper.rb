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

end
