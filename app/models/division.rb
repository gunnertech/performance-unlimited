class Division < ActiveRecord::Base
  resourcify
  
  belongs_to :organization

  has_many :assigned_divisions
  has_many :managers, class_name: "User", through: :assigned_divisions
  has_many :groups, order: :position
  has_many :assigned_groups, through: :groups, order: :position
  has_many :users, through: :groups
  
  has_many :assigned_surveys, dependent: :destroy
  has_many :surveys, through: :assigned_surveys
  
  attr_accessible :name, :organization, :organization_id, :time_zone, :creator
  attr_accessor :creator
  
  after_create :set_organization
  
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
    self.update_attributes(organization: Organization.with_role('admin', creator).first)
  end
end
