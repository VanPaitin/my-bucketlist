FactoryGirl.define do
  factory :bucketlist do
    name { Faker::Commerce.department }
  end
end
