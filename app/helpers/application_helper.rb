module ApplicationHelper
  def icon_image_tag
    if @organization
      image_tag(@organization.logo.url)
    else
      begin
        image_tag(resource.organization.logo.url)
      rescue
        image_tag(parent.organization.logo.url) rescue nil
      end
    end
  end
end
