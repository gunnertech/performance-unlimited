class AlertMailer < ActionMailer::Base
  def notification_email(completed_survey)
    @completed_survey = completed_survey
    
    domain = completed_survey.organization.mapped_domains.first.try(:domain) || DEFAULT_DOMAIN
    emails = completed_survey.organization.users.joins{ roles }.where{ roles.name == 'admin' }.select{ email }.map(&:email).uniq
    
    mail(from: "notifications@#{domain}" :to => emails, :subject => "Survey Notifications for #{completed_survey.user}")
  end
end