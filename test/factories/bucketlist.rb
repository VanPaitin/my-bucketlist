FactoryGirl.define do
  factory :bucketlist do
    sequence(:name) { |n| Faker::Name.name + " list#{n}" }
  end
end
