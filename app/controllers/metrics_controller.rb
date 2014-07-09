class MetricsController < InheritedResources::Base
  belongs_to :organization
  respond_to :json
  
  skip_load_and_authorize_resource only: [:calculations]
  
  def create
    create!{ parent }
  end
  
  def update
    update!{ parent }
  end
  
  def calculations
    @metric = Metric.find(params[:id])
    @user = User.find(params[:user_id])
    
    if params[:compare_type].present? && params[:compare_id].present?
      @comparison = params[:compare_type].classify.constantize.find(params[:compare_id])
    else
      @comparison = @user.organizations.first
    end
    
    rms = @metric.recorded_for(@user).reorder{ recorded_on.desc }
    user_ids = @comparison.users.pluck('users.id').uniq
    rank, values = @user.rank_for(rms.limit(1).first,user_ids)
    
    hash = {
      rank: rank,
      percentile: (((((values.count-rank).to_f/values.count.to_f) * 100.0).to_i) rescue 0),
      z_score: (view_context.number_with_precision((rms.limit(1).first.numerical_value.to_f - @metric.recorded_for(user_ids).average(:numerical_value).to_f)/values.standard_deviation.to_f,precision:1) rescue 0).to_s.gsub(/Inf/,"0"),
      id: @metric.id,
      user_id: @user.id,
      population: values.count
    }
    
    respond_to do |format|
      format.json{ render json: hash }
    end
  end
end
