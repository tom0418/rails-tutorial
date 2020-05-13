FactoryBot.define do
  factory :micropost, class: Micropost do
    content { 'Test' }
    association :user
  end
end
