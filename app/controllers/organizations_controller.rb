class OrganizationsController < InheritedResources::Base
  def add_authentication
    @organization = Organization.find(params[:organization_id])
    if auth_hash[:provider] == 'twitter'
      @organization.authentications.create(
        provider: 'twitter',
        uid: auth_hash[:uid],
        token: auth_hash[:credentials][:token],
        secret: auth_hash[:credentials][:secret],
        nickname: auth_hash[:info][:nickname]
      )
    end
    
    redirect_to @organization
  end
  
  protected
  
  def auth_hash
    request.env['omniauth.auth']
  end
  
end
