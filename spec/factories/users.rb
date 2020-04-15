FactoryBot.define do
  factory :user, class: User do
    name { 'Test User' }
    email { 'test@example.com' }
    password { 'password' }
  end

  factory :another, class: User do
    name { 'Another User' }
    email { 'another@example.com' }
    password { 'password' }
  end
end
