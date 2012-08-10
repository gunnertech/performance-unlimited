module ApplicationHelper
  def icon_image_tag
    if @organization
      image_tag(@organization.logo.url)
    else
      image_tag(resource.organization.logo.url) rescue nil
    end
  end
end
