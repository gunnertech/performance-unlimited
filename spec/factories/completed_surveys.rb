# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :completed_survey do
    date "2012-07-23"
    user nil
    survey nil
  end
end
