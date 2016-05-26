FactoryGirl.define do
  factory :bucketlist do
    sequence(:name) { |n| Faker::Commerce.department + " list#{n}" }
  end
end
