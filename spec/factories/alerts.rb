# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alert do
    alertable_type "MyString"
    alertable_id 1
    message "MyString"
    metric nil
    date "2013-10-07"
    threshold_minimum 1.5
    threshold_maximum 1.5
  end
end
