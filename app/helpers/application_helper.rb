module ApplicationHelper

  def collapse(name)
    if params[:controller].split('/')[0] == name
      "collapse in"
    else
      "collapse"
    end
  end
end
