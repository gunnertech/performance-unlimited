class AuthenticationsController < InheritedResources::Base
  def destroy
    destroy!{ @authentication.authenticationable }
  end
end
