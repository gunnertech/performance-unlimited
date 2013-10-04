class Group < ActiveRecord::Base
  belongs_to :division
  has_one :organization, through: :division
  has_many :assigned_groups, order: :position
  has_many :users, through: :assigned_groups
  
  has_many :metrics, through: :organization
  # has_many :recorded_metrics, through: :metrics
  
  attr_accessible :name, :global_position, :position, :file, :file_contents
  attr_accessor :global_position, :file, :recorded_date
  
  after_save :update_positions
  
  acts_as_list scope: :division
  
  validates :name, uniqueness: {scope: :division_id}
  
  before_save :start_upload, if: Proc.new{|resource| resource.file_contents.present? }
  
  def start_upload
    do_upload(recorded_date)
  end
  
  def do_upload(recorded_date)
    require 'csv'
    begin
      rows = CSV.parse(file_contents, :headers => true)
    rescue
      return false
    end
    rows.headers.each_with_index do |header,i|
      if i > 3 && self.organization.metrics.where{ lower(name) == my{header.downcase} }.first.nil?
        self.organization.metrics.create(name: header, metric_type: MetricType.find_or_create_by_name('Number'))
      end
    end
    (rows||[]).each_with_index do |row, i|
      next if row['First Name'].blank?
      user = nil
      groups = []
      
      if row['Groups'].present?
        (row['Groups'].split(",")||[]).each do |piece|
          pieces = piece.split(":")
          division = self.division
          group = self
          groups.push(group) unless groups.include?(group)
        end
        
      end
      
      if row['Athlete ID'].present?
        user = User.find_by_id(row['Athlete ID'])
      else
        user = self.users.where{ (first_name == my{row['First Name']}) & (last_name == my{row['Last Name']}) }.first
      end
      
      if user.nil?
        user = User.new(first_name: row['First Name'], last_name: row['Last Name'])
        user.save!
      end
      
      if groups.empty?
        division = self.division
        group = self
        groups.push(group)
      end
      
      groups.each do |group|
        user.add_role('athlete', group) unless user.has_role?('athlete',group)
        user.groups << group unless user.groups.include?(group)
      end
      
      
      rows.headers.each_with_index do |header,i|
        if i > 3
          if row[header].present?
            metric = self.organization.metrics.where{ lower(name) == my{header.downcase} }.first
            # begin
              if row[header].match(/%/)
                row[header] = (row[header].gsub(/%/,"").to_f / 100)
                m = self.organization.metrics.where{ lower(name) == my{header.downcase} }.first
                m.metric_type_id = MetricType.find_or_create_by_name('Percentage').id
                m.save!
              elsif row[header].to_s.squish.present? && row[header].to_s.match(/[a-z]/i)
                m = self.organization.metrics.where{ lower(name) == my{header.downcase} }.first
                m.metric_type_id = MetricType.find_or_create_by_name('Text').id
                m.save!
              end
              metric.recorded_metrics.create!(value: row[header], recorded_on: recorded_date, user: user)
            # rescue
            #   #raise metric.to_s
            # end
          end
        end
      end
    end
    self.file_contents = nil
    self.save!
  end
  handle_asynchronously :do_upload
  
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
