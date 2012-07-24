# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assigned_question_set do
    question_set nil
    survey nil
    position 1
  end
end
