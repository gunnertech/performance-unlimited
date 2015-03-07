class SelectedResponsesController < InheritedResources::Base
  respond_to :html, :js, :json
  
  # def update
  #   @selected_response = SelectedResponse.find(params[:id])
  #   raise @selected_response.update_attributes(params[:selected_attribute]).inspect
  # end
end
