class GroupsController < InheritedResources::Base
  belongs_to :division, optional: true
  respond_to :json
  
  def show
    show! do |success|
      success.html
      success.csv {
        @dates = (30.days.ago.to_date..Date.today).map{ |date| date }
        response.headers['Content-Disposition'] = "attachment; filename=\"#{parent.name.parameterize}-#{@group.name.parameterize}-#{Date.today}.csv\""
      }
    end
  end
end
