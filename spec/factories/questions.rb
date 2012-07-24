# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    short_text "MyString"
    long_text "MyText"
  end
end
