class GroupsController < InheritedResources::Base
  belongs_to :division, optional: true
  respond_to :json
  
  def show
    show! do |success|
      success.html
      success.csv {
        today = Time.now.in_time_zone(parent.time_zone).to_date
        start_date = Date.strptime(params[:start_date], "%m/%d/%Y") rescue (today-30.days)
        end_date = Date.strptime(params[:end_date], "%m/%d/%Y") rescue today
        
        @dates = (start_date..end_date).map{ |date| date }
        response.headers['Content-Disposition'] = "attachment; filename=\"#{parent.name.parameterize}-#{@group.name.parameterize}-#{today}.csv\""
      }
    end
  end
end
