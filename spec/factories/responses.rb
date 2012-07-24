# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :response do
    question nil
    short_text "MyString"
    long_text "MyString"
    points 1
  end
end
