FactoryGirl.define do
  factory :item do
    name Faker::Lorem.paragraph
    done { Faker::Boolean.boolean }
  end
end
