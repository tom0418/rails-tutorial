FactoryBot.define do
  sequence(:name) { |n| "Test User#{n}" }
  sequence(:email) { |n| "test#{n}@example.com" }

  factory :user, class: User do
    name { 'Test User' }
    email { 'test@example.com' }
    password { 'password' }
  end

  factory :list_user, class: User do
    name
    email
    password { 'password' }
  end
end
