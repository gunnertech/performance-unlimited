class DataFile < ActiveRecord::Base
  attr_accessible :file_contents
  belongs_to :data_fileable, polymorphic: true
end
