class Locale < ActiveRecord::Base
  attr_accessible :code, :name
  has_many :assigned_locales
  has_many :organizations, through: :assigned_locales
end
