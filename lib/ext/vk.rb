class VK
  
  def initialize(antigate_key, vk_token=false)
    if vk_token

    #@vk      = VkontakteApi::Client.new(Vk::Account.find_by(:status => 1024).token)
    @captcha = Antigate.wrapper('92846f7da681d95250f11170780398a3') #???
    end
  end



  private


  def cad(id, captcha_sid=false,captcha_key=false)
    begin
      if captcha_sid        
        v = @vk.friends.add(user_id: id, captcha_sid: captcha_sid, captcha_key: captcha_key)
      else  
        v = @vk.friends.add(user_id: id)
      end
      r = {:success => true, :result=> v}
    rescue VkontakteApi::Error => e
      if e.error_code == 14
        r={:success => false, :result=> {:code => e.error_code, captcha_sid: e.captcha_sid, captcha_img: e.captcha_img}}
      else
        r={:success => false, :result=> {:code => e.error_code }}
      end
    end
    r
  end




  def cadd(arr)
    captcha = Antigate.wrapper('92846f7da681d95250f11170780398a3')
    r       = {:success=>true}

    while arr.count > 0
      if r[:success]
        id = arr.shift
        r = cad(id)
      else
        recognized = captcha.recognize(r[:result][:captcha_img], 'jpg')
        r = cad(id, r[:result][:captcha_sid], recognized[1])
      end

      p r
      sleep 10
    end
  end

  

end