class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :role
  before_filter :configure_permitted_parameters, if: :devise_controller?


  def role

    if current_user.nil?

    else
      #role = current_user.role
      #if role.id < 0
      #  render :text => "Ban!"
      #end
    end
  end


  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, key:[:name, :email, :password, :current_password, :antigate_key] }
    end

end
