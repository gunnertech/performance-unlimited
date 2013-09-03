Organization.find_or_create_by_name(name: "Florida Gators")

english = Locale.find_or_create_by_code(code: "en", name: 'English')
spanish = Locale.find_or_create_by_code(code: "es", name: 'Spanish')

Organization.first.assigned_locales.create(locale: english) if Organization.first.locales.where{ code == 'en' }.count == 0
Organization.first.assigned_locales.create(locale: spanish) if Organization.first.locales.where{ code == 'es' }.count == 0


['Text', 'Number', 'Decimal', 'Percentage'].each do |metric_type|
  MetricType.find_or_create_by_name(metric_type)
end

User.all.each{|user| user.update_attributes(language: 'en') if user.language.blank? }

mapped_production_domain = MappedDomain.find_or_create_by_domain(DEFAULT_DOMAIN)
mapped_staging_domain = MappedDomain.find_or_create_by_domain("performance-unlimited-staging.herokuapp.com")
mapped_development_domain = MappedDomain.find_or_create_by_domain("localhost")

[mapped_production_domain, mapped_staging_domain, mapped_development_domain].each do |mapped_domain|
  Organization.first.mapped_domains << mapped_domain unless Organization.first.mapped_domains.include? mapped_domain
end