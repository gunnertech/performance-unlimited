# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    provider "MyString"
    uid "MyString"
    nickname "MyString"
    token "MyString"
    secret "MyString"
    authenticationable_type "MyString"
    authenticationable_id 1
  end
end
