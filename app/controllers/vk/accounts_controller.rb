class Vk::AccountsController < ApplicationController
  before_action :set_vk_account, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :vk_init

  respond_to :html

  def index
    @vk_account_groups = Vk::AccountGroup.where(:user_id => current_user.id).all

    #@vk_accounts = Vk::Account.where(:user_id => current_user.id).all
    respond_with(@vk_accounts)
  end

  def show
    respond_with(@vk_account)
  end

  def new
    @vk_account = Vk::Account.new(:user_id => current_user.id)
    respond_with(@vk_account)
  end

  def edit
  end

  def create
    if params[:create_type] == "new1" && !vk_account_params[:phone].blank?
      check_phone = vk_check_phone(vk_account_params[:phone])
      if check_phone[:success]
        sex      = rand(2)+1
        password = pass_gen
        users    = @vk.users.search(sort:0, city: city_main_rand, country: 1, sex: sex, count:10, offset: rand(991))

        first_name = nil
        last_name  = nil

        users.items.each do |i|
          if first_name.nil?
            if i['first_name'].scan(/[a-z]/i).empty?
              first_name = i['first_name']
            end
          else
            if i['last_name'].scan(/[a-z]/i).empty?
              last_name = i['last_name']
            end
          end
        end
        
        sign_up  = vk_sign_up(first_name, last_name, sex, vk_account_params[:phone], password)

        if sign_up[:success]
          @vk_account = Vk::Account.new(
            phone: vk_account_params[:phone],
            user_id: current_user.id,
            status: -1,
            pass: password,
            info: {
              :method     => 'vk_sign_up',
              :users      => users, 
              :first_name => first_name, 
              :last_name  => last_name, 
              :sex        => sex, 
              :sid        => sign_up[:result][:sid]
            }
          )
          @vk_account.save

          flash[:notice] = t('vk.sign_up_sms')
          redirect_to vk_account_path(@vk_account.id)

        else
          @vk_account = Vk::Account.new(
            phone: vk_account_params[:phone],
            user_id: current_user.id,
            status: "-#{sign_up[:result][:code]}".to_i,
            pass: password,
            info: {
              :method      => 'vk_sign_up',
              :users       => users, 
              :first_name  => first_name, 
              :last_name   => last_name, 
              :sex         => sex, 
              :captcha_sid => sign_up[:result][:captcha_sid], 
              :captcha_img => sign_up[:result][:captcha_img]
            }
          )
          @vk_account.save

          flash[:notice] = t('vk.error_code_'+ sign_up[:result][:code].to_s)
          redirect_to vk_account_path(@vk_account.id)
        end

      else
        flash[:notice] = t('vk.error_code_'+ check_phone[:result][:code].to_s)
        redirect_to vk_accounts_path
      end

      
    else
      @vk_account = Vk::Account.new(vk_account_params.merge({:user_id => current_user.id}))
      access = get_access_token
      if access
        @vk_account.id    = access['user_id']
        @vk_account.token = access['access_token']
        @vk_account.save

        redirect_to vk_account_path(@vk_account.id)
      else
        flash[:notice] = t('Ошибка добавления акаунта. Проверьте логин и пароль.')

        redirect_to :back
      end
        
    end
  end

  def update
    if params[:code_status] == "-14"

      if @vk_account.info['method'] == 'vk_sign_up'
        sign_up=vk_sign_up(
          @vk_account.info['first_name'], 
          @vk_account.info['last_name'], 
          @vk_account.info['sex'], 
          @vk_account.phone, 
          @vk_account.pass, 
          @vk_account.info['captcha_sid'], 
          params[:captcha]
        )

        if sign_up[:success]
          @vk_account.status = -1 
          @vk_account.info   = @vk_account.info.merge({:sid => sign_up[:result][:sid]})
          @vk_account.save

          render :json => sign_up

        else
          if sign_up[:result][:code] = -14
            @vk_account.info = @vk_account.info.merge({:captcha_sid => sign_up[:result][:captcha_sid], :captcha_img => sign_up[:result][:captcha_img]})
          else
            @vk_account.status = "-#{sign_up[:result][:code]}".to_i
          end
          flash[:notice] = t('vk.error_code_'+ sign_up[:result][:code].to_s)
          @vk_account.save
          respond_with(@vk_account)
        end        
      else

      end


    elsif params[:code_status] == "-1"
      confirm = vk_confirm(@vk_account.phone, params[:sms], @vk_account.pass)
      if confirm[:success]
        @vk_account.id     = confirm[:result][:uid]
        @vk_account.status = 1
        @vk_account.login  = @vk_account.phone
        @vk_account.save
        flash[:notice] = "Регистрация прошла успешно."
        respond_with(@vk_account)
      else
        flash[:notice] = t('vk.error_code_'+ confirm[:result][:code].to_s)
        respond_with(@vk_account)
      end

    elsif params[:code_status] == 'resend'
      resend = vk_sign_up_resend(
        @vk_account.info['first_name'], 
        @vk_account.info['last_name'], 
        @vk_account.info['sex'],
        @vk_account.phone, 
        @vk_account.pass, 
        @vk_account.info['sid'],
        0
      )

      if resend[:success]
        flash[:notice] = t('vk.code_resended')
        respond_with(@vk_account)
      else
        @vk_account.status = "-#{resend[:result][:code]}".to_i
        @vk_account.info = @vk_account.info.merge({:captcha_sid => resend[:result][:captcha_sid], :captcha_img => resend[:result][:captcha_img]})
        @vk_account.save
        flash[:notice] = t('vk.error_code_'+ resend[:result][:code].to_s)
        respond_with(@vk_account)
      end


    else
      @vk_account.update(vk_account_params.merge({:user_id => current_user.id}))
      access = get_access_token
      if access
        @vk_account.id    = access['user_id']
        @vk_account.token = access['access_token']
        @vk_account.save

        redirect_to vk_account_path(@vk_account.id)
      else
        flash[:notice] = t('Ошибка обновления акаунта. Проверьте логин и пароль.')

        redirect_to :back
      end
    end




  end

  def destroy
    @vk_account.destroy
    respond_with(@vk_account)
  end

  private

    def vk_init
      @vk_pub  = VkontakteApi::Client.new()
      #@vk      = VkontakteApi::Client.new(Vk::Account.find_by(:status => 1024).token)
      @captcha = Antigate.wrapper('92846f7da681d95250f11170780398a3') #???
    end

    def vk_check_phone(phone)
      begin
        vk = @vk_pub.auth.checkPhone(
          client_id:     rand_secret[0],
          client_secret: rand_secret[1],
          phone:         phone,
        )  
        {:success => true, :result=> vk }
      rescue VkontakteApi::Error => e
        vk_ex(e)
      end
    end

    def vk_sign_up(first_name, last_name, sex, phone, password, captcha_sid=0, captcha_key=0)
      begin
        if captcha_sid == 0 || captcha_key == 0 
          vk= @vk_pub.auth.signup(
            first_name:    first_name,
            last_name:     last_name,
            client_id:     rand_secret[0],
            client_secret: rand_secret[1],
            #password:      password, бла бла бла
            phone:         phone,
            sex:           sex
          )        
        else
          vk= @vk_pub.auth.signup(
            first_name:    first_name,
            last_name:     last_name,
            client_id:     rand_secret[0],
            client_secret: rand_secret[1],
            #password:      password, бла бла бла
            phone:         phone,
            sex:           sex,
            captcha_sid:   captcha_sid,
            captcha_key:  captcha_key,
          ) 
        end

        {:success => true, :result=> vk}

      rescue VkontakteApi::Error => e
        vk_ex(e)
      end
    end

    def vk_sign_up_resend(first_name, last_name, sex, phone, password, sid, voice=0)
      begin
        vk= @vk_pub.auth.signup(
          first_name:    first_name,
          last_name:     last_name,
          client_id:     rand_secret[0],
          client_secret: rand_secret[1],
          #password:      password, бла бла бла
          phone:         phone,
          sex:           sex,
          sid:           sid,
          voice:         voice

        )        
        {:success => true, :result=> vk}
      rescue VkontakteApi::Error => e
        vk_ex(e)
      end
    end




    def vk_confirm(phone, code, password)
      begin
        vk= @vk_pub.auth.confirm(
          client_id:     rand_secret[0],
          client_secret: rand_secret[1],
          phone:         phone,
          code:          code,
          password:      password #небла
        )        
        {:success => true, :result=> vk}
      rescue VkontakteApi::Error => e
        vk_ex(e)
      end
    end


    def vk_ex(e)
      if e.error_code == 14
        {:success => false, :result=> {:code => e.error_code, captcha_sid: e.captcha_sid, captcha_img: e.captcha_img}}
      else
        {:success => false, :result=> {:code => e.error_code }}
      end
    end


    def pass_gen
      (("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a).shuffle.first(rand(14)+16).join
    end

    #@todo
    def rand_secret
      ["4902646", "la3G5IoNM4rGmD4y5EbN"]
    end

    # 4906456 , PjJwvcWMWYDVz9Z3yagV

    def country_rand
      [19, 20, 5, 21, 22, 23, 24, 25, 26, 27, 28, 6, 29, 30, 31, 32, 33, 34, 3, 35, 36, 37, 38, 39, 40, 235, 41, 42, 43, 44, 45, 46, 47, 48, 233, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 7, 72, 73, 231, 74, 75, 76, 77, 78, 79, 8, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 4, 91, 92, 10, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 11, 138, 106, 12, 107, 108, 109, 110, 13, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 15, 129, 130, 131, 132, 133, 134, 135, 136, 137, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 9, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 234, 183, 184, 185, 186, 187, 188, 189, 190, 16, 191, 192, 193, 194, 195, 196, 197, 198, 199, 17, 200, 201, 18, 2, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 230, 215, 216, 217, 218, 219, 220, 221, 222, 223, 14, 224, 226, 227, 232, 228, 229].shuffle[0]
    end

    def city_main_rand
      [1,2, 10, 37, 153,  49, 60, 61, 72,  73,  95, 99, 104, 110, 119, 123, 151, 158].shuffle[0]
    end


    def get_access_token
      url   = VkontakteApi.authorization_url(type: :client, scope: [:groups,:friends,:photos,:video,:audio,:wall,:offline,:email,:docs]) #many ?
      agent = Mechanize.new()
      vk_login_page = agent.get url
      vk_login_page.form.email = vk_account_params[:login]
      vk_login_page.form.pass  = vk_account_params[:pass]
      vk_grant_page            = vk_login_page.form.submit()
      if vk_grant_page.form.nil? && vk_grant_page.uri.path = '/blank.html'
        r = Hash[vk_grant_page.uri.fragment.split('&').map{|i| i.split("=")}]
      elsif !vk_grant_page.form.field('email').nil? || !vk_grant_page.form.field('pass').nil?
        r = false
      else
        vk_success_page = vk_grant_page.form.submit()
        r = Hash[vk_success_page.uri.fragment.split('&').map{|i| i.split("=")}]
      end
      r
    end

    def set_vk_account
      @vk_account = Vk::Account.find(params[:id])
    end

    def vk_account_params
      params.require(:vk_account).permit(:login, :pass, :phone, :active, :status, :info, :user_id, :proxy_id, :token)
    end

    #0 – не проверялся
    #1 – ок
    #2 – ошибка авторизации
    #3 – регистрация ожимаем подтверждения смс
    #4 – новорегистррованный
    #1024 - системный
    #a=75309210, 3233280, 1188100, 95653538, 4152179, 12212027, 125657861, 163070071, 23107330, 75595675, 7411366, 169406311, 22728681, 2000984, 121438427, 192720034, 91566669, 19471147, 6856456, 178100430, 35528666, 32501428, 22270201, 67936172, 2569809, 86943103, 31783506, 14069491, 106191378, 63217101, 32977215, 5629351, 133626781, 40526941, 34264014, 2063594, 125904647, 55136751, 50500892, 21112819, 4721881, 97289816, 32705545, 25656416, 7249251, 3721673, 141254715, 49806928, 31736187, 7125487, 200911254, 195439991, 91656318, 62346335, 26765834, 17120156, 4045231, 194319206, 139329275, 86687529, 51084012, 38928548, 33263907, 10355442, 7318791, 212737541, 140710816, 136176837, 131488920, 126292751, 123078249, 102133600, 96744984, 59024774, 58521691, 39054184, 35721931, 15716766, 13560626, 3168446, 2713540, 617406, 156159250, 149194463, 147509676, 146478932, 143463114, 141026889, 140239095, 138258718, 121275378, 118102791, 62900791, 52276318, 28676520, 24951484, 24846088, 19373891, 11574985, 11428078, 8949766, 8316208, 8233844, 214284679, 201002541, 184735957, 156698155, 116118733, 94062321, 44970496, 41760198, 32143170, 27940044, 191115912, 140783148, 139818502, 120877468, 94611703, 76394467, 68588478, 58346857, 54286927, 39478637, 16566408, 9481022, 9478922, 7629338, 3352211, 2298675, 1617394, 245892054, 168985311, 165121884, 155583689, 140176325, 137285640, 134908499, 134607158, 113030286, 25273610, 21236761, 16897091, 10106395, 5073617, 1933704, 183938241, 160440048, 142837467, 141705742, 134697418, 102986792, 102075214, 82832634, 79150466, 64623500, 58747334, 52145725, 22073419, 15459843, 5293909, 258342932, 221806503, 215112942, 193455938, 189064675, 155055394, 154263443, 153691413, 144199905, 143410705, 143334744, 143322827, 143248080, 139946190, 124092600, 117911692, 101558831, 98433450, 84481056, 80965912, 80507285, 78905008, 54586994, 51565091, 30188223, 30160793, 27726772, 25077980, 23147438, 21408561, 21012047, 20206796, 19687248, 13603791, 12832587, 11220415, 6100149, 5542568, 1688640, 217573747, 206789821, 189344228, 186372258, 169346625, 169114731, 162211652, 161561755, 159709802, 158418432, 155707282, 153888505, 143405185, 142306718, 141120654, 136639982, 134699767, 131645873, 108774371, 104565165, 101485982, 97002300, 89863344, 87469289, 84498364, 82454655, 79698631, 67678251, 65845544, 65664077, 64343794, 60498436, 59838710, 58102934, 56761279, 51133935, 28888414, 25847595, 25254615, 23056939, 20476907, 18458335, 16732544, 4064092, 3110261, 1885510, 212511368, 202033027, 201753374, 196258671, 191331975, 187983677, 185421015, 174468215, 167579401, 160157163, 156919056, 154129024, 149179485, 147392955, 143566612, 142638438, 141412737, 140260258, 137760877, 137108457, 136610071, 136464000, 134410878, 130551765, 121377609, 115962257, 114940302, 102825872, 93974462, 88068705, 83467913, 82613437, 71993880, 66085118, 65315433, 64717131, 63596197, 62392837, 62305054, 52763224, 52614937, 46540601, 35383445, 35001550, 33779976, 33604126, 29256262, 17461186, 15464605, 14923659, 10342772, 10013187, 8118123, 7842063, 7278115, 2272004, 247318717, 246827555, 223745544, 221177455, 204478799, 200362161, 196791375, 192589809, 191213086, 190975022, 190473681, 180473518, 169406233, 168455708, 162659901, 162614658, 161992684, 158439199, 157429522, 157105085, 154807703, 152121786, 149192666, 147795785, 147470739, 144800367, 143386668, 143326829, 143228045, 142641978, 138509362, 137107400, 136665366, 134621718, 134405592, 119250921, 116230541, 116041773, 190882773, 111074767, 110325370, 110284716, 108636607, 108287785, 107923883, 106698831, 104784324, 103696180, 95387607, 94622497, 94352734, 94078593, 90492109, 85681250, 83610332, 80470976, 77043387, 69984254, 69512236, 66814746, 66760632, 65177442, 65003053, 62045765, 59897918, 58266967, 57224120, 56845561, 56239207, 55602146, 55198877, 207989877, 55088772, 53492896, 52417140, 51797787, 51095188, 49714742, 47907573, 168461573, 47293647, 42302557, 56692557, 41379942, 40778927, 39728596, 55713596, 52358596, 38471591, 36838845, 34771653, 32988247, 29678244, 29030078, 27095234, 19067044, 8810032, 8638989, 6739481, 5312516, 2435985, 243997495, 235976521, 212055748, 209996273, 209978024, 209543285, 206757985, 205648030, 203657369, 202949002, 199216973, 199076567, 189758532, 189191270, 186547591, 185953513, 185852290, 182535617, 181723289, 178359620, 173699578, 170586508, 168058461, 167142459, 157331024, 155848849, 155736081, 155697924, 155083141, 154589061, 154137489, 150819400, 148743210, 147757508, 143893243, 143375889, 143272458, 142451919, 139940026, 139148937, 138084260, 137878577, 134906949, 134408390, 132490931, 131494109, 125454677, 125174009, 124827907, 124805284, 121218562, 120510222, 114209739, 113849092, 112606554, 110747613, 110093880, 109971664, 109112212, 108629992, 107984155, 107428962, 105427627, 104735338, 103851424, 177677424, 168221424, 102876009, 102126374, 131565374, 132416374, 101955263, 100905087, 97508731, 239868731, 96358492, 146812492, 100026492, 95872264, 92683355, 89687706, 200575706, 83829135, 186977135, 82940916, 82775533, 81893107, 81505886, 80708851, 78881748, 77663655, 77331773, 76631893, 76422453, 75943182, 75528305, 72962629, 72278962, 71448753, 70479762, 68525054, 67497347, 66156954, 65975265, 65174133, 64985752, 63109724, 63044858, 63041882, 59565266, 59380961, 48422465, 44296300, 41661321, 41409021, 39943121, 39136692, 38442559, 30925426, 28120564, 24950486, 22785224, 18679945, 18358031, 17604767, 17072345, 16453864, 14500102, 153929102, 13774866, 11444269, 6251719, 5931354, 5080957, 4551278, 4397246, 4311474, 162198474, 3705483, 3562436, 1736555, 832794, 169991876, 144333818, 143106233, 135119063, 134462644, 116598537, 74269495, 70923057, 69740305, 65685751, 36440075, 32523203, 22876139, 15724776, 7515983, 301831997, 297894625, 292224823, 292132298, 292054231, 289795106, 284068640, 276416337, 276312125, 275178600, 272854364, 271638369, 268236142, 264504225, 255992405, 255806665, 254292713, 253552789, 252941526, 250371997, 248243700, 247617927, 246856235, 246429197, 244712121, 287762121, 244183912, 242271625, 242170314, 279216314, 239400812, 238717353, 237931057, 266360057, 235945646, 235730832, 235680201, 234432237, 233440502, 231166129, 230913050, 229576709, 226712115, 225985226, 254591226, 225055773, 223096969, 221105342, 220130316, 219561026, 219297102, 218909226, 218868921, 218624460, 218127839, 216282507, 216238864, 216029037, 215848414, 215793353, 215112007, 214403177, 214111701, 214070024, 213854887, 213628233, 212739309, 211597836, 211557099, 211423205, 211396345, 210233172, 209529163, 209036582, 208733503, 208509333, 207062882, 206818599, 206786027, 206600447, 205910809, 205479946, 205352249, 203637574, 203555913, 201927617, 201615702, 201096585, 201061538, 200461180, 200359130, 200267929, 199206547, 198689880, 198177215, 197880267, 197549086, 197360728, 196988445, 195973079, 194571852, 194548000, 193225089, 228444089, 193068692, 193066485, 192824829, 192700248, 192402077, 192399345, 192381495, 190646685, 190582366, 190301698, 189419706, 189151526, 188492597, 188343058, 187818929, 187175039, 185074237, 184945948, 184563979, 184526599, 183970282, 183364784, 237355784, 183319187, 183052712, 182774821, 181302449, 253007449, 180921321, 180083269, 179848832, 179817231, 179605447, 179185508, 179066188, 178773412, 177210499, 196910499, 177185699, 176528474, 176335859, 174811311, 174588928, 174204489, 173170243, 172828589, 214999589, 172740601, 172717587, 172281324, 171491288, 171346426, 171301492, 170813060, 193929060, 289799060, 170767481, 170135098, 169865253, 168920422, 168748930, 168451240, 168307429, 168279686, 168218933, 167483411, 167416905, 167064050, 167037722, 166490980, 166171669, 292047669, 165716178, 165432543, 165017469, 164683552, 208485552, 163747752, 163685276, 227294276, 163660629, 163500630, 163410161, 163047451, 162522960, 161798021, 161584644, 161495848, 161240991, 160825138, 160580135, 160251894, 160076131, 159293423, 158607931, 158527618, 158224076, 157423305, 177067305, 156948958, 156667122, 156553468, 156541135, 208094135, 156446903, 155854210, 155729519, 198439519, 155620766, 276409766, 155389561, 155138304, 155103578, 155085171, 155063581, 154898987, 194614987, 154820638, 154660115, 154622325, 154279780, 168595780, 153817697, 166949697, 153724639, 153497404, 153044452, 206327452, 152872885, 152608734, 152294488, 152143942, 152036330, 151802135, 151752794, 151720819, 151439211, 151415378, 150919061, 150454746, 150338606, 148659258, 148177458, 147841870, 147660556, 147564877, 147417557, 147391568, 147029346, 146571324, 145979785, 145144522, 144913365, 144386438, 144332160, 143077327, 142488242, 141619181, 224765181, 140574434, 218471434, 140522895, 140393387, 140004610, 139991724, 139521370, 138884936, 153338936, 142729936, 207775936, 137864844, 137635247, 137581281, 137500092, 137494876, 137395271, 137369903, 137326358, 137252509, 137113302, 136840490, 136751682, 136636386, 136635765, 136392563, 196592563, 136389850, 136137549, 226799549, 135971004, 135382309, 134473236, 134265109, 134168846, 134015343, 133938578, 232962578, 133844331, 133782042, 133605678, 133568779, 133381465, 133031156, 224193156, 133030021, 132820416, 132755678, 132696295, 132577036, 132521630, 132355338, 137060338, 132287443, 132155603, 132018808, 131840213, 129662343, 125612336, 124933883, 124252363, 171005363, 161530363, 123742589, 123168571, 123056990, 122308454, 122061690, 121709509, 121691428, 121545431, 123147431, 121517053, 121205844, 120369090, 119964866, 118185450, 117719972, 117575653, 117451689, 115080806, 112575078, 112540738, 111658315, 111081074, 110129510, 121230510, 110034347, 109968530, 109815768, 109366193, 192122193, 109085740, 109061529, 107733582, 107131889, 106668450, 160656450, 106536682, 106525950, 133541950, 105367585, 104574041, 103616139, 103050079, 102407774, 102388966, 101946886, 101489729, 101290385, 100646589, 198164589, 100436284, 100162660, 134286660, 99769662, 99421019, 99351500, 98426082, 98376002, 98156466, 235855466, 97671285, 97503506, 97132700, 97068520, 240581520, 96625413, 96381219, 95273863, 95254952, 94860523, 110383523, 102549523, 94464909, 94107696, 94104886, 93980162, 93489974, 93437898, 93299940, 132386940, 93234498, 93079559, 93010624, 91861764, 90797519, 89576470, 88422521, 87988497, 87802981, 144453981, 87575984, 87456959, 87210792, 86591690, 85767975, 85474944, 85398818, 85103588, 164925588, 85022033, 84720088, 84315977, 83988693]

end
