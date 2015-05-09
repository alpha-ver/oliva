module ApplicationHelper

  def collapse(name)
    if name.class == Array
      a=false
      name.each do |n|
        if params[:controller].split('/')[0] == n
          a=true
        end
      end

      if a
        "collapse in"
      else
        "collapse"
      end

    else
      if params[:controller].split('/')[0] == name
        "collapse in"
      else
        "collapse"
      end
    end

  end

end