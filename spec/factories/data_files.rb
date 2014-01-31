# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_file do
    data_fileable_type "MyString"
    data_fileable_id 1
    file_contents "MyText"
  end
end
