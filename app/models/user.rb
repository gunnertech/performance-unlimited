class User < ActiveRecord::Base
  self.per_page = 50
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :score, :average, 
                  :active, :language, :division_id, :assigned_roles, :change_roles, :group_ids
  
  attr_accessor :assigned_roles, :editor, :change_roles
  
  before_validation :set_first_name_and_last_name
  after_save :assign_roles
  before_save :set_name
  
  after_create :add_admin_role, if: Proc.new{ |user| User.count <= 1 }
  
  has_many :assigned_groups
  has_many :groups, through: :assigned_groups
  has_many :assigned_divisions
  has_many :admined_divisions, through: :assigned_divisions, class_name: "Division", source: :division
  has_many :divisions, through: :groups
  has_many :organizations, through: :divisions
  has_many :completed_surveys
  has_many :recorded_metrics
  
  belongs_to :default_division, class_name: "Division", foreign_key: "division_id"
  
  default_scope order{ last_name.asc }
  
  class << self
    def leaderboard(start_date=nil,end_date=nil)
      if start_date && end_date
        joins{ completed_surveys }.where{ completed_surveys.date >> (start_date..end_date) }.reorder{ completed_surveys.score.desc }
      else
        joins{ completed_surveys }.reorder{ completed_surveys.score.desc }
      end
    end
    
    def active
      where{ active == true }
    end
  end
  
  def divisions_with_admin_access
    ids = Organization.with_role('admin', self).pluck('organizations.id')
    Division.joins{ organization }.where{ organization.id >> my{ids} }
  end
  
  def time_zone
    divisions.first.try(:time_zone) || 'Eastern Time (US & Canada)'
  end
  
  def organization
    Organization.with_role('admin', self).first || organizations.first
  end
  
  def admined_organizations
    if has_role?('admin')
      Organization.all
    else
      Organization.with_role('admin', self)
    end
  end
  
  def to_s
    name || email
  end
  
  def set_name
    self.name ||= "#{self.first_name} #{self.last_name}"
  end
  
  def set_first_name_and_last_name
    if name
      name_pieces = name.split(" ")
      self.first_name = name_pieces.first
      self.last_name = (name_pieces - [name_pieces.first]).join(" ").strip
    end
  end
  
  def assigned_roles
    @assigned_roles || self.roles.map{|role| role.name }
  end
  
  def assigned_group_for(groupd_id)
    assigned_groups.where{ group_id == my{groupd_id} }.first
  end
  
  def update_score
    self.score = completed_surveys.sum('completed_surveys.score')
    self.average = completed_surveys.reorder{ user_id }.group{ user_id }.select{ avg(score).as(the_avg) }.first.try(:the_avg).try(:to_f)
    self.save!
    #update_attributes(score: score, average: average)
  end
  
  def is_a_participant?
    roles.where{ name == 'athlete' }.count > 0
  end
  
  def is_an_admin?
    roles.where{ name == 'admin' }.count > 0
  end
  
  def assign_roles
    if assigned_roles && change_roles
      self.roles = []
      assigned_roles.each do |ar| 
        if ar == 'admin'
          Organization.with_role('admin', self.editor).each do |organization|
            assign_role(ar,organization)
            organization.surveys.each do |s|
              assign_role(ar,s)
            end
          end
        else
          self.groups.each do |group|
            assign_role(ar,group.division)
          end
        end
      end 
    end
    true
  end
  
  def assign_role(role, resource=nil)
    if resource
      self.add_role role.to_s, resource
    else
      self.add_role role.to_s
    end
  end
  
  def add_admin_role
    self.add_role('admin')
  end
  
end
