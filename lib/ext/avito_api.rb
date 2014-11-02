class AvitoApi

  def initialize()

  end

  #private

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

end