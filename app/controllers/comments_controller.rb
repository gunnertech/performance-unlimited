class CommentsController < InheritedResources::Base
  belongs_to :user, optional: true
  respond_to :json
  
  protected
  
  def collection
    return @comments if @comments
    
    @comments = end_of_association_chain.accessible_by(current_ability)
    
    @comments = @comments.where{ metric_id == my{params[:metric_id]}} if params[:metric_id].present?
    
    @comments
  end
  
end
