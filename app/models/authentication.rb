class Authentication < ActiveRecord::Base
  attr_accessible :authenticationable_id, :authenticationable_type, :nickname, :provider, :secret, :token, :uid, :refresh_token
  belongs_to :authenticationable, polymorphic: true
end
