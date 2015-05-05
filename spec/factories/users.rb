FactoryGirl.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.email }
    password "12345678"
    factory :admin do
      admin true
    end
  end

end
