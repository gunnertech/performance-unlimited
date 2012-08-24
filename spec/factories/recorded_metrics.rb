# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recorded_metric do
    user nil
    value "MyString"
    recorded_on "2012-08-24"
  end
end
