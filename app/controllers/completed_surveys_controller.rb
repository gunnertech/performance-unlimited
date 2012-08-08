class CompletedSurveysController < InheritedResources::Base
  belongs_to :survey, optional: true
  belongs_to :user, optional: true
  respond_to :json
  
  def index
    if parent?
      start_date = params[:day_range].to_i.days.ago
      end_date = Date.today
      @completed_surveys = parent.completed_surveys.where{ date >> (start_date..end_date)  }
    end
    index!
  end
  
  def create
    @completed_survey = parent.completed_surveys.create(user_id: params[:taker_id].to_i, date: Date.today)
    @user = User.find(params[:taker_id])
    params[:responses].split(',').each do |response_code|
      question_id, response_id = response_code.split('-')
      @completed_survey.selected_responses.create(user_id: params[:taker_id], response_id: response_id)
    end
    
    title = "#{@user.name.parameterize}-#{Date.today}.csv"
    @dates = (30.days.ago.to_date..Date.today).map{ |date| date }
    # @user.organizations.each do |organization|
    #   organization.upload_spreadsheets(render_to_string(template: 'users/show.csv.erb'), title)
    # end
    
    create!
  end
end
