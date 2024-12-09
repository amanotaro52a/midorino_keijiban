FactoryBot.define do
  factory :user do
    name { "Test User" } # 修正: `username` → `name`
    email { "testuser@example.com" }
    password { "password" }
    password_confirmation { "password" }
    avatar { nil }
  end
end
