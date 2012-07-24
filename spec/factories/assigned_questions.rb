# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assigned_question do
    question nil
    question_set nil
    position 1
  end
end
