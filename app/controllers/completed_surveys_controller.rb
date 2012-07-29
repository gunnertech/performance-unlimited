class CompletedSurveysController < InheritedResources::Base
  belongs_to :survey, optional: true
  belongs_to :user, optional: true
  respond_to :json
  
  def index
    if parent?
      @completed_surveys = parent.completed_surveys.limit((params[:day_range]||30))
    end
    index!
  end
  
  def create
    @completed_survey = parent.completed_surveys.create(user_id: params[:taker_id].to_i, date: Date.today)
    
    params[:responses].split(',').each do |response_code|
      question_id, response_id = response_code.split('-')
      @completed_survey.selected_responses.create(user_id: params[:taker_id], response_id: response_id)
    end
    
    create!
  end
end
