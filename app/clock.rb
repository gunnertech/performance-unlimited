require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)

require 'clockwork' 
include Clockwork


every(60.minutes, 'send_reminders') do
  hour = Time.now.utc.in_time_zone('Eastern Time (US & Canada)').hour
  User.where{ reminder_hour == my{} }.each do |user|
    user.send_survey_reminder if user.reminder_active? && user.phone_number.present?
  end
end