
class AvitoParser

  # init proxy class
  def initialize(timeout=5, keep_alive=false, json=true)
    @proxies    = ProxyList.all.map{|i| i.attributes}
    @used_proxy = Setting.s('used_proxy')
    @json       = json

    if json
      require "open-uri"
      if !@used_proxy
        raise "OnlyProxy"
      end
    else

      require 'mechanize'
      @agent = Mechanize.new

      if @used_proxy
        if @proxies.empty?
          raise "ProxyNotSet"
        else
          #set proxy for not multi treading functions
          set_proxy(@proxies[rand(@proxies.count)])
        end
      end

      @agent.user_agent_alias = user_agent
      @agent.open_timeout     = timeout
      @agent.read_timeout     = timeout
      @agent.keep_alive       = keep_alive
      @host                   = 'https://m.avito.ru'
    end

  end

  ################
  ####AVITO.RU####
  ################

  def get_links(link='rossiya', page=1)
    begin
      page = @agent.get "#{@host}/#{link}?page=#{page}"
      #################
      r true,  page.search("//article[contains(@class, 'b-item')]/a").map{|i| i.attr('href')}
    rescue Exception => e
      r false, e
    end
  end

  def get_categories(link='location')
    begin
      page = @agent.get "#{@host}/#{link}"
      #################
      r true,  page.search("//article[@class='b-list']/ul[@class='list']/li[@class='list-item']/a[@class='list-link']").map{|i| i.attr('href')}
    rescue Exception => e
      r false, e
    end
  end


  def get_all_categories
    ##################
    #get_all_categories
  end

  def get_post(link)
    begin
      hash = {}
      id   = link.split("_")[-1]
      post = @agent.get "#{@host}#{link}"

      if "#{@host}#{link}" == post.uri.to_s
        # avito крендель
        # phone_url  = post.search("//a[@class='button-text action-link link']")
        phone_url = post.search("//a[contains(@class,'action-show-number')]")

        if phone_url.nil? || phone_url.empty?
          r false, {:id => id, :exception => false, :not_phone => true}
        else
          phone_url  = phone_url.attr("href").text
          phone_page = JSON.parse(@agent.get("#{@host}#{phone_url}?async", [], URI.parse("#{@host}#{link}")).body)
          ####
          hash[:id          ] = id
          hash[:title       ] = post.search("//header[contains(@class, 'single-item-header')]").text.strip
          hash[:name        ] = post.search("//div[@class='person-name']/text()"   ).text.strip
          hash[:description ] = post.search("//div[@class='description-wrapper']"  ).text.strip
          hash[:price       ] = post.search("//div[@class='info-price']/span[@class='price-value']").text.gsub(/[\s,\u00A0]/,"").to_i
          hash[:category    ] = post.search("//div[@class='info-params params']/span[@class='param param-last']").text

          #hask  bug "<". Example -"<span>Размер < 19</span>"
          if hash[:category].nil? || hash[:category].empty?
            hash[:category] = post.search("//div[@class='info-params params']/span/span[@class='param param-last']").text
          end
          hash[:phone]  = phone_page['phone'].gsub(/[- ]/,"")[-10,10]
          person_params = post.search("//div[contains(@class, 'person-params') and contains(@class, 'address-person-params')]/text()").text.strip

          if person_params.scan(",").blank?
            hash[:region] = person_params
          else
            person_arr = person_params.split(",")
            hash[:region  ] = person_arr[0].strip
            hash[:location] = person_arr[1].strip
          end

          hash[:user_address] = post.search("//div[contains(@class, 'person-params') and contains(@class, 'address-person-params')]/span[@class='info-text address-text']").text.strip

          hash.delete_if { |k, v| v.to_s.empty? }

          r true, hash
        end
      else
        r false, {:id => id, :exception => false, :destroyed => true}
      end
    rescue Exception => e
      if e.class.method_defined? :response_code
        http_code = e.response_code.to_i
      else
        http_code = false
      end
      r false, {:id => id, :exception => e, :http_code => http_code, :hash => hash}
    end
  end

  def get_posts(links)
    pls   = proxy_and_link(links)
    p pls
    arr   = []
    if pls
      pls.each do |pl|
        arr << Thread.new do
          if @used_proxy
            set_proxy(pl[0])
          end

          if j
            Thread.current["result"] = get_post_api(pl[1])
          else
            Thread.current["result"] = get_post(pl[1])
          end

        end
      end
      ###
      arr.map { |t| t.join; t["result"] }
    end
  end

  def get_posts_api(ids)
    arr=[]

    ids.each do |id|
      arr << Thread.new do
        Thread.current["result"] = get_post_api(id)
      end
    end
    ###
    arr.map { |t| t.join; t["result"] }

  end


  def get_post_api(id)
    begin
      hash = {}
      link = gen_link(id)
      json  = JSON.parse(open(link, :proxy => rand_proxy, :read_timeout=>10).read)

      hash[:id          ] = json['id']
      hash[:url         ] = json['url']
      hash[:title       ] = json['title']
      hash[:name        ] = json['seller'].map{|v| v[1]}.join(", ")
      hash[:description ] = json['description']
      hash[:category    ] = json['refs']['categories'][json['categoryId']]['name']
      hash[:phone       ] = json['phone'].gsub(/[- ]/, '')[-10,10]

      if !json['price'].blank?
         hash[:price       ] = json['price']['value'].to_i
      end
      if !json['locationId'].blank?
        hash[:region]       = json['refs']['locations'][json['locationId']]['name']
      end

      if !json['districtId'].blank?
        hash[:location]     = json['refs']['districts'][json['districtId']]['name']
      end

      hash[:user_address] = json['address']

      hash.delete_if { |k, v| v.to_s.empty? }

      r true, hash

    rescue Exception => e
      if e.class.method_defined? :response_code
        http_code = e.response_code.to_i
      else
        http_code = false
        destroyed = true
      end
      r false, {:id => id, :exception => e, :http_code => http_code, :hash => hash, :destroyed => destroyed}
    end
  end

  def get_index_ids(lastStamp=nil)
    begin
      link = "https://www.avito.ru/api/2/items?checksum=a5a3e0a0844c6028113f0f5245ba5ac2&key=neohoMNwARklNSgGQiFtz4HFfgX9juWKSmEgczgP"
      res  = JSON.parse(open(link, :proxy => rand_proxy, :read_timeout=>2).read)
      ut   = res['lastStamp'].to_i

      if ut != lastStamp.to_i
        ids  = res['items'].map{|r| r['id'].to_i}

        r true, {:lastStamp => ut, :ids => ids}
      else
        r false, res['lastStamp']
      end
    rescue Exception => e
      r false, e
    end
  end

  def get_ids(threads=50, depth=100, timeout=3)
    a= []
    u=depth/threads
    1.upto(u) do |i|
      arr=[]
      threads*i-threads+1.upto(threads*i) do |page|
        arr << Thread.new do
          begin

            Thread.current["result"] = JSON.parse(open(gen_link(0,1,"page=#{page}"), :read_timeout=>timeout, :proxy=>rand_proxy).read)['items'].map{|i| i['id'].to_i}
          rescue 
            Thread.current["result"] = nil
          end
        end
      end
      a += arr.map { |t| t.join; t["result"] }
    end
    a.flatten.compact.uniq
  end

  #######
  private

    def gen_link(id=0, v=1, params='includeRefs=true&reducedParams=true', items=true)
      
      if id != 0
        id = "/" + id.to_s
      else
        id = ""
      end

      if params.size == 0
        amp = ""
      else
        amp = "&"
      end 

      if v==1
        if items
          path = '/items' + id.to_s
        else
          path = id.to_s
        end
        
        checksum = md5( md5("Pwmj$%o[o$KLLPS5nBGAVejEu(mtQw<y3?&NPk&f") + md5(path) + md5(params) )
        url      = "https://www.avito.ru/api/2" + path + "?checksum=" + checksum + "&key=neohoMNwARklNSgGQiFtz4HFfgX9juWKSmEgczgP" + amp + params
      else
        #Реализовать версию с другим key -> XcyLEIoAuUgGSJUDFAs4xWTnV2TKEmvZTZuTtPFr
        url = ":)"
      end

      return  url
    end





    def md5(str)
      Digest::MD5.hexdigest(str)
    end

    def proxy_and_link(links)
      if @used_proxy
        if @proxies.count == links.count
          links.each_with_index.map {|v,k| [@proxies[k], v] }
        elsif @proxies.count != links.count
          links.each_with_index.map {|v,k| [@proxies[rand(@proxies.count)], v] }
        else
          false
        end
      else
        links.each_with_index.map {|v,k| [@proxies[k], v] }
      end
    end

    def set_proxy(proxy)
      if proxy.user.nil? || proxy.password.nil?
        @agent.set_proxy proxy.host, proxy.port
      else
        @agent.set_proxy proxy.host, proxy.port, proxy.user, proxy.password
      end
    end

    def rand_proxy
      proxy = @proxies[rand(@proxies.count)]
      "http://#{proxy['host']}:#{proxy['port']}"
    end


    def user_agent
      user_agent = Mechanize::AGENT_ALIASES.map {|i| i[0] if i[0] != "Mechanize"}.compact
      user_agent[rand(user_agent.count)]
    end

    def r status, message
      {:status => status, :result => message}
    end

end
