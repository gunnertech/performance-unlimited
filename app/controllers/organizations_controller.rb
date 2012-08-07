class OrganizationsController < InheritedResources::Base
  before_filter :create_session_variable, only: :show
  
  def add_authentication
    @organization = Organization.find(params[:organization_id] || session[:organization_id])
    if auth_hash[:provider] == 'twitter'
      @organization.authentications.create(
        provider: 'twitter',
        uid: auth_hash[:uid],
        token: auth_hash[:credentials][:token],
        secret: auth_hash[:credentials][:secret],
        nickname: auth_hash[:info][:nickname]
      )
    elsif auth_hash[:provider] == 'google_oauth2'
      @organization.authentications.create(
        provider: 'google_oauth2',
        uid: auth_hash[:uid],
        token: auth_hash[:credentials][:token],
        nickname: auth_hash[:info][:name]
      )
    end
    
    redirect_to @organization
  end
  
  protected
  
  def create_session_variable
    session[:organization_id] = params[:id]
  end
  
  def auth_hash
    request.env['omniauth.auth']
  end
  
end
