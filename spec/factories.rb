
FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password { "secretPassword" }
    password_confirmation { "secretPassword" }
  end

  factory :wow do
    comment { "Beautiful!" }
    address { "21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8" }
    association :user
  end


end