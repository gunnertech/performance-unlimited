class Organization < ActiveRecord::Base
  resourcify
  has_attached_file :logo, { default_url: "/assets/logos/:style/missing.png", default_style: :medium,   styles: { medium: "250x200#", thumb: "125x100#" }}.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  has_many :divisions
  has_many :surveys
  has_many :question_sets
  has_many :questions
  
  attr_accessible :name, :logo
  
  def to_s
    name
  end
end
