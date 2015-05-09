class AvitoApi

  def initialize()

  end

  def get(path='/items', params=false)

    begin
      p gen_link(path, params)
      res  = open(gen_link(path, params)).read
      hash = JSON.parse(res)

      r true, hash
    rescue Exception => e
      r false, e
    end
  end

  private
    def gen_link(path='/items',params=false,v=1)
      prefix_path = '/api/2'

      if params
        query = Hash[params.sort]
      else
        query = {}
      end
      
      if v==1
      checksum = md5( md5("Pwmj$%o[o$KLLPS5nBGAVejEu(mtQw<y3?&NPk&f") + md5(path) + md5(query.to_query))

      query["key"]      ="neohoMNwARklNSgGQiFtz4HFfgX9juWKSmEgczgP"
      #query["key"]      ="XcyLEIoAuUgGSJUDFAs4xWTnV2TKEmvZTZuTtPFr"
      query["checksum"] = checksum

      URI::HTTPS.build(:host => "www.avito.ru", :path => prefix_path + path, :query => query.to_query)
      else
        #Реализовать версию с другим key -> XcyLEIoAuUgGSJUDFAs4xWTnV2TKEmvZTZuTtPFr
        raise NotNotNot      
      end
    end

    def md5(str)
      Digest::MD5.hexdigest(str)
    end

    def r status, message
      {:status => status, :result => message}
    end

end