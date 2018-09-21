FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password { "12345678" }
  end
end