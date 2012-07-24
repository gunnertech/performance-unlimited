# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :point_range do
    assigned_survey nil
    low 1
    high 1
    description "MyText"
  end
end
