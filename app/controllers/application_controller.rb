class ApplicationController < ActionController::Base
  protect_from_forgery
  load_and_authorize_resource :unless => :devise_controller?
  
  before_filter :set_locale

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
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
end
