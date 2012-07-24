class SelectedResponse < ActiveRecord::Base
  belongs_to :user
  belongs_to :response
  # attr_accessible :title, :body
end
