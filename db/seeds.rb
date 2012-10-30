# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# puts 'SETTING UP DEFAULT USER LOGIN'
# user = User.find_or_create_by_email :name => 'Cody Swann', :email => 'cody@gunnertech.com', :password => 'please', :password_confirmation => 'please'
# puts 'New user created: ' << user.name
# brendon_huttmann = User.find_or_create_by_email :name => 'Brendon Huttmann', :email => 'huttmannb@gmail.com', :password => 'please', :password_confirmation => 'please'
# puts 'New user created: ' << brendon_huttmann.name
# user.add_role 'admin'
# 
# a_j_burnett = User.find_or_create_by_email name: 'A.J. Burnett', email: 'a_j_burnett@example.com', password: 'please', password_confirmation: 'please'
# rod_barajas = User.find_or_create_by_email name: 'Rod Barajas', email: 'rod_barajas@example.com', password: 'please', password_confirmation: 'please'
# pedro_alvarez = User.find_or_create_by_email name: 'Pedro Alvarez', email: 'pedro_alvarez@example.com', password: 'please', password_confirmation: 'please'
# 
# 
# 
# pirates_organization = Organization.find_or_create_by_name('The Pirates Organization')
# 
# pittsburgh_pirates = pirates_organization.divisions.find_or_create_by_name('Pittsburgh Pirates')
# 
# brendon_huttmann.add_role('admin',brendon_huttmann.assigned_divisions.create(division: pittsburgh_pirates)) if brendon_huttmann.assigned_divisions.empty?
# brendon_huttmann.add_role 'admin', pirates_organization
# 
# user.add_role('admin',brendon_huttmann.assigned_divisions.first) if user.assigned_divisions.empty?
# user.add_role 'admin', pirates_organization
# 
# 
# a_j_burnett.add_role 'athlete', pittsburgh_pirates
# rod_barajas.add_role 'athlete', pittsburgh_pirates
# pedro_alvarez.add_role 'athlete', pittsburgh_pirates
# 
# pittsburgh_pirates_pitchers = pittsburgh_pirates.groups.find_or_create_by_name("Pitchers")
# pittsburgh_pirates_catchers = pittsburgh_pirates.groups.find_or_create_by_name("Catchers")
# pittsburgh_pirates_infielders = pittsburgh_pirates.groups.find_or_create_by_name("Infielders")
# pittsburgh_pirates_outfielders = pittsburgh_pirates.groups.find_or_create_by_name("Outfielders")
# 
# pittsburgh_pirates_pitchers.users << a_j_burnett unless pittsburgh_pirates_pitchers.users.include?(a_j_burnett)
# pittsburgh_pirates_catchers.users << rod_barajas unless pittsburgh_pirates_catchers.users.include?(rod_barajas)
# pittsburgh_pirates_infielders.users << pedro_alvarez unless pittsburgh_pirates_infielders.users.include?(pedro_alvarez)
# 
# pirates_organization_survey = pirates_organization.surveys.find_or_create_by_name('Recovery Survey')
# brendon_huttmann.add_role 'admin', pirates_organization_survey
# user.add_role 'admin', pirates_organization_survey
# 
# pittsburgh_pirates.surveys << pirates_organization_survey unless pittsburgh_pirates.surveys.include?(pirates_organization_survey)
# 
# pirates_organization_survey.assigned_surveys.first.point_ranges.find_or_create_by_name("Fully Recovered", low: 9, high: nil)
# pirates_organization_survey.assigned_surveys.first.point_ranges.find_or_create_by_name("Mostly Recovered", low: 7, high: 8)
# pirates_organization_survey.assigned_surveys.first.point_ranges.find_or_create_by_name("Somewhat Recovered", low: 5, high: 6)
# pirates_organization_survey.assigned_surveys.first.point_ranges.find_or_create_by_name("Under Recovered", low: 3, high: 4)
# pirates_organization_survey.assigned_surveys.first.point_ranges.find_or_create_by_name("Severely Under Recovered", low: 0, high: 2)
# 
# pirates_organization_question_set_1 = pirates_organization.question_sets.find_or_create_by_name("Recovery Habits")
# pirates_organization_question_set_2 = pirates_organization.question_sets.find_or_create_by_name("Nutrition")
# pirates_organization_question_set_3 = pirates_organization.question_sets.find_or_create_by_name("Uncontrolables")
# 
# 
# pirates_organization.question_sets << pirates_organization_question_set_1 unless pirates_organization.question_sets.include?(pirates_organization_question_set_1)
# pirates_organization.question_sets << pirates_organization_question_set_2 unless pirates_organization.question_sets.include?(pirates_organization_question_set_2)
# pirates_organization.question_sets << pirates_organization_question_set_3 unless pirates_organization.question_sets.include?(pirates_organization_question_set_3)
# 
# pirates_organization_survey.question_sets << pirates_organization_question_set_1 unless pirates_organization_survey.question_sets.include?(pirates_organization_question_set_1)
# pirates_organization_survey.question_sets << pirates_organization_question_set_2 unless pirates_organization_survey.question_sets.include?(pirates_organization_question_set_2)
# pirates_organization_survey.question_sets << pirates_organization_question_set_3 unless pirates_organization_survey.question_sets.include?(pirates_organization_question_set_3)
# 
# sleep_hours_question = pirates_organization.questions.find_or_create_by_short_text("Sleep Hours")
# active_cool_down_question = pirates_organization.questions.find_or_create_by_short_text("Active Cool Down")
# nap_relaxation_question = pirates_organization.questions.find_or_create_by_short_text("Nap / Relaxation")
# cold_tub_contrast_ice_question = pirates_organization.questions.find_or_create_by_short_text("Cold Tub / Contrast / Ice")
# post_activity_protein_shake_question = pirates_organization.questions.find_or_create_by_short_text("Post Activity Protein Shake")
# muscle_armor_question = pirates_organization.questions.find_or_create_by_short_text("Muscle Armor")
# 
# sleep_hours_question.responses.find_or_create_by_short_text("&gt; 8", points: 2)
# sleep_hours_question.responses.find_or_create_by_short_text("6-8", points: 1)
# sleep_hours_question.responses.find_or_create_by_short_text("&lt; 6", points: -1)
# 
# active_cool_down_question.responses.find_or_create_by_short_text("Yes", points: 2)
# active_cool_down_question.responses.find_or_create_by_short_text("No", points: 0)
# 
# nap_relaxation_question.responses.find_or_create_by_short_text("Yes", points: 2)
# nap_relaxation_question.responses.find_or_create_by_short_text("No", points: 0)
# 
# cold_tub_contrast_ice_question.responses.find_or_create_by_short_text("Yes", points: 2)
# cold_tub_contrast_ice_question.responses.find_or_create_by_short_text("No", points: 0)
# 
# post_activity_protein_shake_question.responses.find_or_create_by_short_text("Yes", points: 2)
# post_activity_protein_shake_question.responses.find_or_create_by_short_text("No", points: 0)
# 
# muscle_armor_question.responses.find_or_create_by_short_text("Yes", points: 2)
# muscle_armor_question.responses.find_or_create_by_short_text("No", points: 0)
# 
# 
# nutrition_question_1 = pirates_organization.questions.find_or_create_by_short_text("Breakfast Within 1 Hour Waking")
# nutrition_question_2 = pirates_organization.questions.find_or_create_by_short_text("Meals Per Day")
# nutrition_question_3 = pirates_organization.questions.find_or_create_by_short_text("Hydration")
# nutrition_question_4 = pirates_organization.questions.find_or_create_by_short_text("Caffeine Occurances")
# nutrition_question_5 = pirates_organization.questions.find_or_create_by_short_text("Alcohol Use")
# 
# nutrition_question_1.responses.find_or_create_by_short_text("Yes", points: 2)
# nutrition_question_1.responses.find_or_create_by_short_text("No", points: 0)
# 
# nutrition_question_2.responses.find_or_create_by_short_text("&gt; 4", points: 2)
# nutrition_question_2.responses.find_or_create_by_short_text("3", points: 1)
# nutrition_question_2.responses.find_or_create_by_short_text("&lt; 3", points: -1)
# 
# nutrition_question_3.responses.find_or_create_by_short_text("Clear", points: 2)
# nutrition_question_3.responses.find_or_create_by_short_text("Medium", points: 1)
# nutrition_question_3.responses.find_or_create_by_short_text("Dark", points: -1)
# 
# nutrition_question_4.responses.find_or_create_by_short_text("0-2", points: 2)
# nutrition_question_4.responses.find_or_create_by_short_text("&gt; 2", points: 0)
# 
# nutrition_question_5.responses.find_or_create_by_short_text("0", points: 2)
# nutrition_question_5.responses.find_or_create_by_short_text("1-3", points: 1)
# nutrition_question_5.responses.find_or_create_by_short_text("&gt; 3", points: -1)
# 
# 
# uncontrolables_question_1 = pirates_organization.questions.find_or_create_by_short_text("Current Soreness")
# uncontrolables_question_2 = pirates_organization.questions.find_or_create_by_short_text("Consecutive Days Activity")
# uncontrolables_question_3 = pirates_organization.questions.find_or_create_by_short_text("Temperature")
# uncontrolables_question_4 = pirates_organization.questions.find_or_create_by_short_text("Time Traveled (Hours)")
# 
# uncontrolables_question_1.responses.find_or_create_by_short_text("None", points: 2)
# uncontrolables_question_1.responses.find_or_create_by_short_text("Some", points: 1)
# uncontrolables_question_1.responses.find_or_create_by_short_text("Mod", points: 0)
# uncontrolables_question_1.responses.find_or_create_by_short_text("High", points: -1)
# 
# uncontrolables_question_2.responses.find_or_create_by_short_text("0-3", points: 2)
# uncontrolables_question_2.responses.find_or_create_by_short_text("4-9", points: 1)
# uncontrolables_question_2.responses.find_or_create_by_short_text("&gt; 9", points: -1)
# 
# uncontrolables_question_3.responses.find_or_create_by_short_text("&lt; 80", points: 2)
# uncontrolables_question_3.responses.find_or_create_by_short_text("80-90", points: 1)
# uncontrolables_question_3.responses.find_or_create_by_short_text("&gt; 90", points: -1)
# 
# uncontrolables_question_4.responses.find_or_create_by_short_text("&lt; 3", points: 2)
# uncontrolables_question_4.responses.find_or_create_by_short_text("3-6", points: 1)
# uncontrolables_question_4.responses.find_or_create_by_short_text("&gt; 6", points: -1)
# 
# sleep_hours_question.assigned_questions << sleep_hours_question.assigned_questions.create(question_set: pirates_organization_question_set_1) if sleep_hours_question.assigned_questions.empty?
# active_cool_down_question.assigned_questions << active_cool_down_question.assigned_questions.create(question_set: pirates_organization_question_set_1) if active_cool_down_question.assigned_questions.empty?
# nap_relaxation_question.assigned_questions << nap_relaxation_question.assigned_questions.create(question_set: pirates_organization_question_set_1) if nap_relaxation_question.assigned_questions.empty?
# cold_tub_contrast_ice_question.assigned_questions << cold_tub_contrast_ice_question.assigned_questions.create(question_set: pirates_organization_question_set_1) if cold_tub_contrast_ice_question.assigned_questions.empty?
# post_activity_protein_shake_question.assigned_questions << post_activity_protein_shake_question.assigned_questions.create(question_set: pirates_organization_question_set_1) if post_activity_protein_shake_question.assigned_questions.empty?
# muscle_armor_question.assigned_questions << muscle_armor_question.assigned_questions.create(question_set: pirates_organization_question_set_1) if muscle_armor_question.assigned_questions.empty?
# 
# 
# nutrition_question_1.assigned_questions << nutrition_question_1.assigned_questions.create(question_set: pirates_organization_question_set_2) if nutrition_question_1.assigned_questions.empty?
# nutrition_question_2.assigned_questions << nutrition_question_2.assigned_questions.create(question_set: pirates_organization_question_set_2) if nutrition_question_2.assigned_questions.empty?
# nutrition_question_3.assigned_questions << nutrition_question_3.assigned_questions.create(question_set: pirates_organization_question_set_2) if nutrition_question_3.assigned_questions.empty?
# nutrition_question_4.assigned_questions << nutrition_question_4.assigned_questions.create(question_set: pirates_organization_question_set_2) if nutrition_question_4.assigned_questions.empty?
# nutrition_question_5.assigned_questions << nutrition_question_5.assigned_questions.create(question_set: pirates_organization_question_set_2) if nutrition_question_5.assigned_questions.empty?
# 
# uncontrolables_question_1.assigned_questions << uncontrolables_question_1.assigned_questions.create(question_set: pirates_organization_question_set_3) if uncontrolables_question_1.assigned_questions.empty?
# uncontrolables_question_2.assigned_questions << uncontrolables_question_2.assigned_questions.create(question_set: pirates_organization_question_set_3) if uncontrolables_question_2.assigned_questions.empty?
# uncontrolables_question_3.assigned_questions << uncontrolables_question_3.assigned_questions.create(question_set: pirates_organization_question_set_3) if uncontrolables_question_3.assigned_questions.empty?
# uncontrolables_question_4.assigned_questions << uncontrolables_question_4.assigned_questions.create(question_set: pirates_organization_question_set_3) if uncontrolables_question_4.assigned_questions.empty?
# 
# CompletedSurvey.all.map(&:update_score)
# User.all.map(&:update_score)

english = Locale.find_or_create_by_code(code: "en", name: 'English')
spanish = Locale.find_or_create_by_code(code: "es", name: 'Spanish')

Organization.first.assigned_locales.create(locale: english) if Organization.first.locales.where{ code == 'en' }.count == 0
Organization.first.assigned_locales.create(locale: spanish) if Organization.first.locales.where{ code == 'es' }.count == 0


['Text', 'Number', 'Decimal', 'Percentage'].each do |metric_type|
  MetricType.find_or_create_by_name(metric_type)
end

User.all.each{|user| user.update_attributes(language: 'en') if user.language.blank? }

mapped_production_domain = MappedDomain.find_or_create_by_domain(DEFAULT_DOMAIN)
mapped_staging_domain = MappedDomain.find_or_create_by_domain("recoverytracker-staging.herokuapp.com")
mapped_development_domain = MappedDomain.find_or_create_by_domain("localhost")

[mapped_production_domain, mapped_staging_domain, mapped_development_domain].each do |mapped_domain|
  Organization.first.mapped_domains << mapped_domain unless Organization.first.mapped_domains.include? mapped_domain
end