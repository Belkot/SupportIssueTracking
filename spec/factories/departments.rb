FactoryGirl.define do
  factory :department do
    sequence(:name) { |n| "Test#{n} department"}#{ Faker::Commerce.department }
  end

end
