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
                  :active, :language, :division_id, :assigned_roles, :change_roles, :group_ids, :transfer_to
  
  attr_accessor :assigned_roles, :editor, :change_roles, :transfer_to
  
  before_validation :set_first_name_and_last_name
  before_validation :transfer, if: Proc.new{ |user| user.transfer_to.present? }
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
  has_many :recorded_metrics, dependent: :destroy
  has_many :metrics, through: :recorded_metrics
  has_many :assigned_alerts
  has_many :alerts, through: :assigned_alerts
  has_many :left_comments, class_name: "Comment", foreign_key: "by_user_id"
  has_many :comments, class_name: "Comment", foreign_key: "for_user_id"
  
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
    
    def search(term)
      relation = scoped

      pieces = term.split(" ")
      if term =~ /\d\d/
        relation = relation.where{ code =~ "#{term}%" }
      elsif term =~ / / && !(term =~ /,/)
        if pieces.length <= 2
          if term =~ / $/
            first_n = pieces.join(" ")
            last_n = ""
          else
            first_n = pieces[0]
            last_n = pieces[1]
          end
        else
          last_n = pieces.last
          first_n = (pieces - [pieces.last]).join(" ")
        end
        relation = relation.where{(last_name =~ "#{last_n.to_s.strip}%") & (first_name =~ "#{first_n.to_s.strip}%")}
      else
        last_n, first_n = term.split(",")
        relation = relation.where{(last_name =~ "#{last_n.to_s.strip}%") & (first_name =~ "#{first_n.to_s.strip}%")}
      end

      relation.reorder{ [last_name, first_name] }.group{ id }
    end
    
  end
  
  def rank_for(recorded_metric, among_users, for_date=nil)
    rank = 1
    values = []
    target_value = recorded_metric.numerical_value
    for_metric = recorded_metric.metric
    
    among_users.each_with_index do |user,i|
      rm = RecordedMetric.where{ (user_id == my{user}) & (metric_id == my{for_metric.id }) }.reorder{ recorded_on.desc }.limit(1).pluck('numerical_value').first

      if rm
        values.push(rm) 
      end
    end
        
    values = values.sort.reverse
    
    values.each_with_index do |v,i|
      if target_value >= v
        rank = i+1 
        break
      end
    end 
    
    [rank, values]
  end
  
  def as_json(options={})
    super({methods: [:label, :value, :url]}.merge(options))
  end
  
  def label
    "#{last_name}, #{first_name}"
  end
  
  def value
    "#{last_name}, #{first_name}"
  end
  
  def url
    "/admin/users/#{id}"
  end
  
  def run_transfer_to(target)
    target.comments << self.comments
    target.recorded_metrics << self.recorded_metrics
    # self.recorded_metrics = []
    target.completed_surveys << self.completed_surveys
    # self.completed_surveys = []
    target.assigned_alerts << self.assigned_alerts
    # self.assigned_alerts = []
    self.save!
    target.save!
    self.destroy
    
  end
  handle_asynchronously :run_transfer_to
  
  def transfer
    target = User.find_by_name(transfer_to)
    # raise target.inspect
    # 2073
    # 1589
    if target && target != self
      run_transfer_to(target)
    end
  end
  
  def users
    User.where{ id >> my{Organization.with_role('admin', self).joins{ users }.pluck('users.id')} }
  end
  
  def reverse_name
    "#{last_name}, #{first_name}"
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
    self.last_name = self.last_name.titlecase if self.last_name
    self.first_name = self.first_name.titlecase if self.first_name
    self.name ||= "#{self.first_name} #{self.last_name}".squish
  end
  
  def set_first_name_and_last_name
    if name && first_name.blank? && last_name.blank?
      name_pieces = name.split(" ")
      self.first_name = name_pieces.first.squish
      self.last_name = (name_pieces - [name_pieces.first]).join(" ").squish
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
