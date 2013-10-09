# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    by_user_id 1
    for_user_id 1
    body "MyText"
    metric nil
  end
end
