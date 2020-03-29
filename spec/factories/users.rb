FactoryBot.define do
  factory :user do
    name { 'testuser1' }
    email { 'estuser1@example.com' }
    password { 'testuser1' }
    password_confirmation { 'testuser1' }
  end
end
