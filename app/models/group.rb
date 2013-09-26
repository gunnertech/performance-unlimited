class Group < ActiveRecord::Base
  belongs_to :division
  has_one :organization, through: :division
  has_many :assigned_groups, order: :position
  has_many :users, through: :assigned_groups
  
  has_many :metrics, through: :organization
  # has_many :recorded_metrics, through: :metrics
  
  attr_accessible :name, :global_position, :position
  attr_accessor :global_position
  
  after_save :update_positions
  
  acts_as_list scope: :division
  
  validates :name, uniqueness: {scope: :division_id}
  
  def to_s
    name
  end
  
  def recorded_metrics
    organization.recorded_metrics.joins{ user }.where{ user.id >> my{ users.pluck('users.id') }}
  end
  
  def full_name
    "#{division.to_s}: #{name}"
  end
  
  def as_json(options = {})
    super options.merge(include: {users:{}})
  end
  
  protected
  def update_positions
    unless global_position.nil?
      assigned_groups.each{ |assigned_group| assigned_group.update_attributes(position: global_position)  }
    end
  end
end
