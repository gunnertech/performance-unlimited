module ApplicationHelper
  def icon_image_tag
    if @organization
      image_tag(@organization.logo.url)
    elsif defined?(:resouce) && resouce && resource.respond_to?(:organization)
      image_tag(resource.organization.logo.url)
    end
  end
end
