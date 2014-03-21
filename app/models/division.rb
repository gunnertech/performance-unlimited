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
  has_many :data_files, as: :data_fileable
  # has_many :recorded_metrics, through: :metrics
  
  attr_accessible :name, :organization, :organization_id, :time_zone, :creator, :file, :file_contents
  attr_accessor :creator, :file, :recorded_date
  
  after_create :set_organization
  before_save :start_upload, if: Proc.new{|resource| resource.file_contents.present? }
  before_validation :format_name
  
  def start_upload
    self.data_files.create(file_contents: file_contents)
    self.file_contents = nil
    save!
    do_upload(recorded_date)
  end
  
  def format_name
    self.name = name.squish
  end
  
  def do_upload(recorded_date=nil)
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
    
    offset = 3
    
    rows.headers.each_with_index do |header,i|
      if header.to_s.squish.downcase == 'date'
        offset = 4
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
          recorded_date = Date.strptime(row['Date'], "%m/%d/%Y") rescue nil
        else
          recorded_date = Date.strptime(row['Date'], "%m/%d/%y") rescue nil
        end
      else
        recorded_date = original_recorded_date
      end
      
      if recorded_date.nil?
        puts "^^^^^^^^^^^^^^^^^^ LOOK AT ME HERE: #{row['Date']} ^^^^^^^^^^"
        recorded_date = original_recorded_date
      end
      
      user = nil
      group_arr = []
      
      if row['Groups'].present?
        (row['Groups'].split(",")||[]).each do |piece|
          pieces = piece.split(":")
          division = self
          group = division.groups.find_or_create_by_name(pieces.last)
          group_arr.push(group) unless group_arr.include?(group)
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
      
      if group_arr.empty?
        division = self
        group = division.groups.find_or_create_by_name("Primary")
        group_arr.push(group)
      end
      
      group_arr.each do |group|
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
              metric.recorded_metrics.create!(value: row[header], recorded_on: recorded_date, user: user)
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
    group_ids = groups.pluck('id')
    biggest_group_count = groups.max_by{ |group| group.users.active.count }.try(:users).try(:count) || 0
    grouped = users.group_by{|user| user.groups.where{ id >> my{group_ids}}.first.id}
    [biggest_group_count, groups.count, grouped, Group.find(grouped.keys)]
  end
  
  def set_organization
    if organization.nil? && creator.present? && Organization.with_role('admin', creator).first.present?
      self.update_attributes(organization: Organization.with_role('admin', creator).first)
    end
  end
end
