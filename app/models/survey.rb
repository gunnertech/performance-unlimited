class Survey < ActiveRecord::Base
  translates :name
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes
  
  resourcify
  
  belongs_to :organization
  
  has_many :assigned_question_sets, order: :position
  has_many :question_sets, through: :assigned_question_sets
  has_many :questions, through: :question_sets
  
  has_many :assigned_surveys
  has_many :point_ranges, through: :assigned_surveys
  has_many :completed_surveys
  has_many :divisions, through: :organization
  
  attr_accessible :name, :active, :organization, :organization_id, :user_id
  attr_accessor :user_id
  
  after_create :make_creatore_an_admin
  
  # default_scope where{ active == true }
  
  def to_s
    name
  end
  
  def time_zone
    divisions.first.time_zone || 'Eastern Time (US & Canada)'
  end
  
  protected
  def make_creatore_an_admin
    User.find(user_id).add_role 'admin', self
  end
end

Survey::Translation.class_eval do
  attr_accessible :locale, :name
end