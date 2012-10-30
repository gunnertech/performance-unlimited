class MappedDomain < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :domain
end
