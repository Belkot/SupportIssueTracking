FactoryGirl.define do
  factory :ticket do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    department
    #association :department, factory: :department, name: "Head department"
    #reference nil
    subject { Faker::Lorem.sentence }
    body { Faker::Hacker.say_something_smart }
  end
end
