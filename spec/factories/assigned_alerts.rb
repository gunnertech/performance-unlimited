# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assigned_alert do
    user nil
    alert nil
    date "2013-10-07"
    cleared false
  end
end
