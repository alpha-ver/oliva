class AvitoApi

  def initialize(proxy=false)
    
    @proxy = URI.parse("http://10.10.20.1:8888")
  end

  def get(path='/items', params=false, v=2)
    #begin
      p gen_link(path, params, v)
      res  = open( gen_link(path, params, v), proxy: @proxy).read
      p res
      hash = JSON.parse(res)
      p hash
      r true, hash
    #rescue Exception => e
    #  r false, e
    #end
  end

  private
    def gen_link(path='/items', params=false, v=2)
      prefix_path = "/api/#{v}"

      if params || params.blank? && params['deviceId'].blank?
        params['deviceId'] = '1122334455667788'
      end

      if params
        query = Hash[params.sort]
      else
        query = {}
      end
  
      checksum = md5( md5("LLI1/E9&zfG-wwKTRd[XGFOAH~u.pnEJ{q(=oyAG") + md5(path) + md5(query.to_query))
      #query["key"]      ="neohoMNwARklNSgGQiFtz4HFfgX9juWKSmEgczgP"
      query["key"]      ="XcyLEIoAuUgGSJUDFAs4xWTnV2TKEmvZTZuTtPFr"
      query["checksum"] = checksum

      URI::HTTPS.build(:host => "www.avito.ru", :path => prefix_path + path, :query => query.to_query)
    end

    def md5(str)
      Digest::MD5.hexdigest(str)
    end

    def r status, message
      {:status => status, :result => message}
    end

end
