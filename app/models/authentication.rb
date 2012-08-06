class Authentication < ActiveRecord::Base
  attr_accessible :authenticationable_id, :authenticationable_type, :nickname, :provider, :secret, :token, :uid
  belongs_to :authenticationable, polymorphic: true
end
