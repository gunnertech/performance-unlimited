# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mapped_domain do
    domain "MyString"
    organization nil
  end
end
