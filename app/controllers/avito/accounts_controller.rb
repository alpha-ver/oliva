class Avito::AccountsController < ApplicationController
  respond_to    :html
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @avito_accounts = Avito::Account.where(:user_id => current_user.id).all
    respond_with(@avito_accounts)
  end

  def show
    respond_with(@avito_account)
    if @avito_account.status == 0
      account_info
    elsif @avito_account.status == 1 && params[:task] == 'post'
      account_post
    end 
  end

  def new
    @avito_account = Avito::Account.new
    respond_with(@avito_account)
  end

  def edit
  end

  def create
    @avito_account = Avito::Account.new(account_params)
    @avito_account.user = current_user
    @avito_account.save
    respond_with(@avito_account)
  end

  def update
    @avito_account.update(account_params)
  end

  def destroy
    @avito_account.destroy
    respond_with(@account)
  end

  private
    def set_account
      @avito_account = Avito::Account.find_by(:id => params[:id], :user_id => current_user.id)
    end

    def account_params
      params.require(:avito_account).permit(:login, :pass, :task)
    end


    ################
    #######XXX######
    ################
    def account_info
      fork do
        agent      = Mechanize.new
        page_login = agent.get "https://www.avito.ru/profile/login"
        if page_login.form.action == "/profile/login"
          page_login.form.field("login").value    = @avito_account.login
          page_login.form.field("password").value = @avito_account.pass
          page_profile = page_login.form.submit()

          if page_profile.uri.path == "/profile/login"
            #no auth
            @avito_account.status = 2

          elsif page_profile.uri.path == "/profile"
            #auth ok
            page_settings    = agent.get "https://www.avito.ru/profile/settings"
            @avito_account.f = {
              :info => {
                :name   => page_settings.search("//h1/span[contains(@class,'name')]").text.strip,
                :status => page_settings.search("//h1/span[contains(@class,'status')]").text.strip                
              },
              :posts => []
            }
            @avito_account.status = 1
            
            #page_additem = agent.get "https://www.avito.ru/additem"
          end

        else
          #no form
        end
        @avito_account.save

      end
    end


    def account_post
      
    end
end




