class DataFile < ActiveRecord::Base
  attr_accessible :data_fileable_id, :data_fileable_type, :file_contents
  belongs_to :data_fileable, polymorphic: true
end
