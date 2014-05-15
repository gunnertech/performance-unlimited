module ApplicationHelper
  def z_score_for(value,mean,standard_deviation)
    (value.to_f - mean.to_f)/standard_deviation.to_f
  end
  
  
  def cache_key_for_alerts(user)
    count          = AssignedAlert.recent_for(user).count
    max_updated_at = user.last_sign_in_at
    "assigned_alerts/all-#{count}-#{max_updated_at}"
  end
  
  def percentile_for(rank, population)
    (((population.count-rank).to_f/population.count.to_f) * 100.0).to_i
  end
  
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
