# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :metric do
    metric_type nil
    organization nil
    name "MyString"
    decimal_places 1
  end
end
