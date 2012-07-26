class Division < ActiveRecord::Base
  resourcify
  
  belongs_to :organization

  has_many :assigned_divisions
  has_many :managers, class_name: "User", through: :assigned_divisions
  has_many :groups
  has_many :users, through: :groups
  
  has_many :assigned_surveys
  has_many :surveys, through: :assigned_surveys
  
  attr_accessible :name, :organization, :organization_id
  
  def to_s
    name
  end
  
  def grouped_users
    grouped_users = []
    
    if groups.count == 0
      return grouped_users
    end
    
    0.upto((users.size/groups.count).ceil-1).each do |row|
      grouped_users[row] ||= []
      groups.each_with_index do |group,i|
        grouped_users[row][i] ||= []
        grouped_users[row][i].push(users.joins{ groups }.where{ groups.id >> group.id }.to_a)
        grouped_users[row][i].flatten!
      end
    end
    
    grouped_users
  end
end
