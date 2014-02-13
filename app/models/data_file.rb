class DataFile < ActiveRecord::Base
  belongs_to :data_fileable, polymorphic: true
end
