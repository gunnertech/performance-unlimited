class ApplicationController < ActionController::Base
  protect_from_forgery
  load_and_authorize_resource :unless => :devise_controller?, except: :index
  
  before_filter :set_locale
  before_filter :after_token_authentication
  
  protected
  
  def authorize_parent
    authorize! :read, (parent) if parent?
  end

  def set_locale
    if devise_controller?
      I18n.locale = current_user.try(:language) || I18n.default_locale
    else
      I18n.locale = params[:locale] || current_user.try(:language) || I18n.default_locale
    end
  end
  
  def default_url_options(options={})
    { :locale => I18n.locale }
  end
  
  def after_token_authentication
    if params[:auth_token].present?
      user = User.find_by_authentication_token(params[:auth_token])
      user.my_reset_authentication_token if user.present?
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    if signed_in?
      redirect_to root_url, :alert => exception.message
    else
      redirect_to new_user_session_url, :alert => exception.message
    end
    
  end
end
