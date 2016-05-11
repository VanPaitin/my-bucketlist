FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "andela"
    password_confirmation "andela"
  end
end
