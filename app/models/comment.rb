class Comment < ActiveRecord::Base
  belongs_to :metric
  belongs_to :commenter, class_name: "User", foreign_key: "by_user_id"
  belongs_to :user, class_name: "User", foreign_key: "for_user_id"
  has_one :organization, through: :metric
  
  attr_accessible :body, :by_user_id, :for_user_id, :metric_id
  
  def left_on
    created_at.to_date
  end
  
  def as_json(options = {})
    super options.merge(methods: [:left_on], include: {commenter:{}, user:{}})
  end
end
