class Division < ActiveRecord::Base
  has_paper_trail
  resourcify
  
  belongs_to :organization

  has_many :assigned_divisions, dependent: :destroy
  has_many :managers, class_name: "User", through: :assigned_divisions
  has_many :groups, order: :position, dependent: :destroy
  has_many :assigned_groups, through: :groups, order: :position
  has_many :users, through: :groups
  
  has_many :assigned_surveys, dependent: :destroy
  has_many :surveys, through: :assigned_surveys
  has_many :metrics, through: :organization
  # has_many :recorded_metrics, through: :metrics
  
  attr_accessible :name, :organization, :organization_id, :time_zone, :creator
  attr_accessor :creator
  
  after_create :set_organization
  
  def recorded_metrics
    organization.recorded_metrics.joins{ user }.where{ user.id >> my{ users.pluck('users.id') }}
  end
  
  def to_s
    name
  end
  
  def today
    Time.now.in_time_zone((self.time_zone)||'Eastern Time (US & Canada)').to_date
  end
  
  def grouped_users
    grouped_users = []
    
    if groups.count == 0
      return grouped_users
    end
    
    biggest_group = groups.max_by{ |group| group.users.active.count }
    
    0.upto(biggest_group.users.active.count-1).each do |row|
      grouped_users[row] ||= []
      groups.each_with_index do |group,i|
        grouped_users[row][i] ||= []
        grouped_users[row][i].push(users.active.joins{ groups }.where{ groups.id >> group.id }.to_a)
        grouped_users[row][i].flatten!
      end
    end
    
    grouped_users
  end
  
  def set_organization
    if organization.nil? && creator.present? && Organization.with_role('admin', creator).first.present?
      self.update_attributes(organization: Organization.with_role('admin', creator).first)
    end
  end
end
