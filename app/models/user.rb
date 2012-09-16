class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :score, :average, 
                  :active, :language, :division_id, :assigned_roles, :change_roles
  
  attr_accessor :assigned_roles, :editor, :change_roles
  
  before_validation :set_first_name_and_last_name
  after_save :assign_roles
  
  has_many :assigned_groups
  has_many :groups, through: :assigned_groups
  has_many :assigned_divisions
  has_many :admined_divisions, through: :assigned_divisions, class_name: "Division", source: :division
  has_many :divisions, through: :groups
  has_many :organizations, through: :divisions
  has_many :completed_surveys
  has_many :recorded_metrics
  
  belongs_to :default_division, class_name: "Division", foreign_key: "division_id"
  
  default_scope order("users.last_name ASC")
  
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
  
  # def admined_divisions
  #   Organization.with_role('admin', self).map{ |organization| organization.divisions.all }.flatten
  # end
  
  def time_zone
    divisions.first.try(:time_zone) || 'Eastern Time (US & Canada)'
  end
  
  def organization
    Organization.with_role('admin', self).first || organizations.first
  end
  
  def to_s
    name
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
    score = completed_surveys.map(&:score).inject(:+) rescue 0
    average = completed_surveys.count > 0 ? score.to_f/completed_surveys.count.to_f : nil
    
    update_attributes(score: score, average: average)
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
  
end
