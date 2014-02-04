class Group < ActiveRecord::Base
  belongs_to :division
  has_one :organization, through: :division
  has_many :assigned_groups, order: :position, dependent: :destroy
  has_many :users, through: :assigned_groups
  
  has_many :metrics, through: :organization
  has_many :data_files, as: :data_fileable
  # has_many :recorded_metrics, through: :metrics
  
  attr_accessible :name, :global_position, :position, :file, :file_contents
  attr_accessor :global_position, :file, :recorded_date
  
  after_save :update_positions
  
  acts_as_list scope: :division
  
  validates :name, uniqueness: {scope: :division_id}
  
  before_save :start_upload, if: Proc.new{|resource| resource.file_contents.present? }
  
  def start_upload
    self.data_files.create(file_contents: file_contents)
    self.file_contents = nil
    save!
    do_upload(recorded_date)
  end
  
  def do_upload(recorded_date)
    original_recorded_date = recorded_date
    file_to_parse = self.data_files.where{ processing == false }.first
    
    return true if file_to_parse.nil?
    file_to_parse.processing = true
    file_to_parse.save!
    
    
    
    require 'csv'
    begin
      rows = CSV.parse(file_to_parse.file_contents, :headers => true)
    rescue
      return false
    end
    
    rows.headers.each_with_index do |header,i|
      if header.to_s.squish.downcase == 'date'
        offset = 4
      else
        offset = 3
      end
    end
    
    rows.headers.each_with_index do |header,i|
      if header.present? && i > offset && self.metrics.where{ lower(name) == my{header.downcase} }.first.nil?
        self.metrics.create(name: header, metric_type: MetricType.find_or_create_by_name('Number'))
      end
    end
    (rows||[]).each_with_index do |row, i|
      next if row['First Name'].blank?
      if row['Date'].present?
        date_pieces = row['Date'].split("/")
        if date_pieces.last.length > 2
          recorded_date = Date.strptime(row['Date'], "%m/%d/%Y")
        else
          recorded_date = Date.strptime(row['Date'], "%m/%d/%y")
        end
      else
        recorded_date = original_recorded_date
      end
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
        user = self.users.where{ (first_name =~ my{row['First Name'].try(:squish)}) & (last_name =~ my{row['Last Name'].try(:squish)}) }.first
      end
      
      if user.nil?
        user = User.new(first_name: row['First Name'].try(:squish), last_name: row['Last Name'].try(:squish))
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
        if i > offset
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
              recorded_metric = metric.recorded_metrics.where{ (recorded_on == my{recorded_date}) & (user_id == my{user.try(:id)}) }.first
              if recorded_metric.present?
                recorded_metric.value = row[header]
                recorded_metric.save
              else
                metric.recorded_metrics.create(value: row[header], recorded_on: recorded_date, user: user)
              end
            # rescue
            #   #raise metric.to_s
            # end
          end
        end
      end
    end
    file_to_parse.destroy
    self.file_contents = nil
    self.save!
    do_upload(nil)
  end
  handle_asynchronously :do_upload, run_at: Proc.new { 1.minutes.from_now }
  
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
