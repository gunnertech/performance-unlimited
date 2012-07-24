# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.find_or_create_by_email :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.name
user2 = User.find_or_create_by_email :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user2.name
user.add_role 'admin'

a_j_burnett = User.find_or_create_by_email name: 'A.J. Burnett', email: 'a_j_burnett@example.com', password: 'please', password_confirmation: 'please'
rod_barajas = User.find_or_create_by_email name: 'Rod Barajas', email: 'rod_barajas@example.com', password: 'please', password_confirmation: 'please'
pedro_alvarez = User.find_or_create_by_email name: 'Pedro Alvarez', email: 'pedro_alvarez@example.com', password: 'please', password_confirmation: 'please'
gorkys_hernandez = User.find_or_create_by_email name: 'Gorkys Hernandez', email: 'gorkys_hernandez@example.com', password: 'please', password_confirmation: 'please'



pirates_organization = Organization.find_or_create_by_name('The Pirates Organization')

pittsburgh_pirates = pirates_organization.divisions.find_or_create_by_name('Pittsburgh Pirates')

a_j_burnett.add_role 'athlete', pittsburgh_pirates
rod_barajas.add_role 'athlete', pittsburgh_pirates
pedro_alvarez.add_role 'athlete', pittsburgh_pirates
gorkys_hernandez.add_role 'athlete', pittsburgh_pirates

pittsburgh_pirates_pitchers = pittsburgh_pirates.groups.find_or_create_by_name("Pitchers")
pittsburgh_pirates_catchers = pittsburgh_pirates.groups.find_or_create_by_name("Catchers")
pittsburgh_pirates_infielders = pittsburgh_pirates.groups.find_or_create_by_name("Infielders")
pittsburgh_pirates_outfielders = pittsburgh_pirates.groups.find_or_create_by_name("Outfielders")

pittsburgh_pirates_pitchers.users << a_j_burnett unless pittsburgh_pirates_pitchers.users.include?(a_j_burnett)
pittsburgh_pirates_catchers.users << rod_barajas unless pittsburgh_pirates_catchers.users.include?(rod_barajas)
pittsburgh_pirates_infielders.users << pedro_alvarez unless pittsburgh_pirates_infielders.users.include?(pedro_alvarez)
pittsburgh_pirates_outfielders.users << gorkys_hernandez unless pittsburgh_pirates_outfielders.users.include?(gorkys_hernandez)

pirates_organization_survey = pirates_organization.surveys.find_or_create_by_name('Recovery Survey')

pittsburgh_pirates.surveys << pirates_organization_survey unless pittsburgh_pirates.surveys.include?(pirates_organization_survey)

pirates_organization_question_set_1 = pirates_organization.question_sets.find_or_create_by_name("Recovery Habits")
pirates_organization_question_set_2 = pirates_organization.question_sets.find_or_create_by_name("Nutrition")
pirates_organization_question_set_3 = pirates_organization.question_sets.find_or_create_by_name("Uncontrolables")

pirates_organization.question_sets << pirates_organization_question_set_1 unless pirates_organization.question_sets.include?(pirates_organization_question_set_1)
pirates_organization.question_sets << pirates_organization_question_set_2 unless pirates_organization.question_sets.include?(pirates_organization_question_set_2)
pirates_organization.question_sets << pirates_organization_question_set_3 unless pirates_organization.question_sets.include?(pirates_organization_question_set_3)

pirates_organization_survey.question_sets << pirates_organization_question_set_1 unless pirates_organization_survey.question_sets.include?(pirates_organization_question_set_1)
pirates_organization_survey.question_sets << pirates_organization_question_set_2 unless pirates_organization_survey.question_sets.include?(pirates_organization_question_set_2)
pirates_organization_survey.question_sets << pirates_organization_question_set_3 unless pirates_organization_survey.question_sets.include?(pirates_organization_question_set_3)

