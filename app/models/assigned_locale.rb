class AssignedLocale < ActiveRecord::Base
  belongs_to :locale
  belongs_to :organization
  attr_accessible :locale, :locale_id, :organization, :organization_id
end
