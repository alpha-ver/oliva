class VKA
  
  #def initialize(antigate_key, vk_token=false)
  #  if vk_token
  #  #@vk      = VkontakteApi::Client.new(Vk::Account.find_by(:status => 1024).token)
  #  @captcha = Antigate.wrapper('92846f7da681d95250f11170780398a3') #???
  #  end
  #end

  def initialize(hash={})
    if hash[:antigate_key]
      @captcha = Antigate.wrapper(hash[:antigate_key])
    end
    if hash[:token]
      @vk = VkontakteApi::Client.new(hash[:token])
    end
    @vk_pub = VkontakteApi::Client.new()
  end

  ##########
  ##########
  ##########

  def find(q)
    @vk.users.search(q.merge(:count => 1000, :fields => "sex, city, country, can_write_private_message", :has_photo=>1)) # ;(
  end

  def friends(id)
    begin
      r={:success => true, :result=> @vk_pub.friends.get(:user_id => id)}
    rescue VkontakteApi::Error => e
      if e.error_code == 14
        r={:success => false, :result=> {:code => e.error_code, captcha_sid: e.captcha_sid, captcha_img: e.captcha_img}}
      else
        r={:success => false, :result=> {:code => e.error_code }}
      end
    end
    r
  end

  def invite(id, captcha_sid=false, captcha_img=false, step=0)
    begin
      if captcha_sid
        r = @captcha.recognize(captcha_img, 'jpg')
        if r[1] == "R"
          step = 5
        else         
          v = @vk.friends.add(user_id: id, captcha_sid: captcha_sid, captcha_key: r[1])
        end
      else  
        v = @vk.friends.add(user_id: id)
      end
      if step==5
        {:success => false, :result=> {:code => 14, :captcha => "R" }}
      else
        {:success => true,  :result=> v}
      end
    rescue VkontakteApi::Error => e
      if e.error_code == 14
        if @captcha.nil? || step > 3
          {:success => false, :result=> {:code => e.error_code, captcha_sid: e.captcha_sid, captcha_img: e.captcha_img}}
        else
          invite(id, e.captcha_sid, e.captcha_img, step+1)
        end
      elsif e.error_code == 17
        {:success => false, :result=> {:code => e.error_code, :url => e.redirect_uri}}
      else
        {:success => false, :result=> {:code => e.error_code }}
      end
    end
  end


  def post(param, captcha_sid=false, captcha_img=false, step=0)
    begin
      if captcha_sid
        r = @captcha.recognize(captcha_img, 'jpg')
        if r[1] == "R"
          step = 5
        else
          if param[:img].blank?        
            v = @vk.wall.post(owner_id: param[:owner_id], message: param[:message], from_group: param[:from_group], captcha_sid: captcha_sid, captcha_key: r[1])
          else
            v = @vk.wall.post(owner_id: param[:owner_id], message: param[:message], from_group: param[:from_group], captcha_sid: captcha_sid, captcha_key: r[1], 
              attachments: wall_upload_photo(owner_id: param[:owner_id], img: param[:img] )
            )
          end
        end
      else
        if param[:img].blank?
          v = @vk.wall.post(owner_id: param[:owner_id], message: param[:message], from_group: param[:from_group])
        else
          v = @vk.wall.post(owner_id: param[:owner_id], message: param[:message], from_group: param[:from_group], 
            attachments: wall_upload_photo(owner_id: param[:owner_id], img: param[:img] )
          )
        end
      end
      if step==5
        {:success => false, :result=> {:code => 14, :captcha => "R" }}
      else
        {:success => true,  :result=> v}
      end
    rescue VkontakteApi::Error => e
      if e.error_code == 14
        if @captcha.nil? || step > 3
          {:success => false, :result=> {:code => e.error_code, captcha_sid: e.captcha_sid, captcha_img: e.captcha_img}}
        else
          post(param, e.captcha_sid, e.captcha_img, step+1)
        end
      elsif e.error_code == 17
        {:success => false, :result=> {:code => e.error_code, :url => e.redirect_uri}}
      else
        {:success => false, :result=> {:code => e.error_code }}
      end
    end
  end

  def wall_upload_photo(param) #{:owner_id => , :img =>  }
    server  = @vk.photos.getWallUploadServer(:owner_id => param[:owner_id])
    img     = open param[:img]
    photo   = VkontakteApi.upload(url: server.upload_url, photo: [img, 'image/jpeg', '1.jpg'])
    d       = @vk.photos.saveWallPhoto(photo)

    "photo#{d[0][:owner_id]}_#{d[0][:id]}"
  end



  private


    def i_cad(id, captcha_sid=false,captcha_key=false)
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
      r = {:success=>true}
      while arr.count > 0
        if r[:success]
          id = arr.shift
          r = cad(id)
        else
          recognized = captcha.recognize(r[:result][:captcha_img], 'jpg')
          r = cad(id, r[:result][:captcha_sid], recognized[1])
        end
        p r
      end
    end

  

end
