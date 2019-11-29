
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
    picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.png').to_s, 'image/png') }
    address { "21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8" }
    association :user
  end


end