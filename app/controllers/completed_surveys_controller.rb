class CompletedSurveysController < InheritedResources::Base
  belongs_to :survey, optional: true
  belongs_to :user, optional: true
  respond_to :json
  
  def index
    if parent?
      # end_date = Date.today
      # start_date = params[:day_range].to_i.days.ago
      end_date = Time.now.in_time_zone(parent.time_zone).to_date
      start_date = end_date - params[:day_range].to_i.days
      
      @completed_surveys = parent.completed_surveys.joins{ survey }.where{ survey.active == true }.where{ date >> (start_date..end_date)  }
    end
    index!
  end
  
  def create
    I18n.locale = :en
    
    today = Time.now.in_time_zone(parent.time_zone).to_date
    @completed_survey = parent.completed_surveys.create(user_id: params[:taker_id].to_i, date: today)
    
    if @completed_survey.valid?
      @user = User.find(params[:taker_id])
      params[:responses].split(',').each do |response_code|
        question_id, response_id = response_code.split('-')
        @completed_survey.selected_responses.create(user_id: params[:taker_id], response_id: response_id)
      end
    
      title = "#{@user.name.parameterize}-#{today}.csv"
      @dates = ((today-30.days)..today).map{ |date| date }
      @user.organizations.each do |organization|
        organization.upload_spreadsheets(render_to_string(template: 'users/show.csv.erb'), title)
      end
    end
    
    create!
  end
end
