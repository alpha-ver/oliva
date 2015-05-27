class Parser

  def initialize(task, proxy=nil)
    @agent = Mechanize.new()
    @task  = task
  end

  def links
    page_links = @agent.get @task.base_url
    links = page_links.search(@task.x_link).map { |e| 
      unless e.attr('href').nil?
        e.attr('href').gsub(%r[#{@task.r_link}], "")
      end
    }.compact

    ##########
    links
  end


  def post(url)
    h={}
    uri = URI.parse(url)
    if uri.host.nil?
      base_uri   = URI.parse(@task.base_url)
      uri.host   = base_uri.host
      uri.scheme = base_uri.scheme
    end

    page_post = @agent.get uri.to_s
    h[:url]   = url
    h[:title] = page_post.search(@task.x_title).text
    h[:body]  = page_post.search(@task.x_body).text
    
    unless page_post.search(@task.x_img).blank?
      h[:img]  = page_post.search(@task.x_img)[0].attr("src")

      uri = URI.parse(h[:img])
      if uri.host.nil?
        base_uri   = URI.parse(@task.base_url)
        uri.host   = base_uri.host
        uri.scheme = base_uri.scheme
        h[:img]    = uri.to_s
      end

    end
    h
  end 

end