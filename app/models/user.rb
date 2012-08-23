class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :score, :average, :active
  
  before_validation :set_first_name_and_last_name
  
  has_many :assigned_groups
  has_many :groups, through: :assigned_groups
  has_many :assigned_divisions
  has_many :divisions, through: :groups
  has_many :organizations, through: :divisions
  has_many :completed_surveys
  
  default_scope order("users.last_name ASC")
  
  class << self
    def leaderboard(start_date=nil,end_date=nil)
      if start_date && end_date
        joins{ completed_surveys }.where{ completed_surveys.date >> (start_date..end_date) }.order{ completed_surveys.score.desc }
      else
        joins{ completed_surveys }.order{ completed_surveys.score.desc }
      end
    end
    
    def active
      where{ active == true }
    end
  end
  
  def time_zone
    divisions.first.try(:time_zone) || 'Eastern Time (US & Canada)'
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
  
  def assigned_group_for(groupd_id)
    assigned_groups.where{ group_id == my{groupd_id} }.first
  end
  
  def update_score
    score = completed_surveys.map(&:score).inject(:+) rescue 0
    average = completed_surveys.count > 0 ? score.to_f/completed_surveys.count.to_f : nil
    
    update_attributes(score: score, average: average)
  end
  
end
