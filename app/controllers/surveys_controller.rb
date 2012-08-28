class SurveysController < InheritedResources::Base
  
  def index
    @surveys = Survey.with_role('admin', current_user)
  end
  
  # def edit
  #   resource.organization.locales.each do |l|
  #     resource.translations.build(locale: l.code) if resource.translations.where{ locale == my{l.code.to_s} }.count == 0
  #   end
  #   
  #   edit!
  # end
end
