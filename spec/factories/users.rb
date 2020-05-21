FactoryBot.define do
  sequence(:name) { |n| "Test User#{n}" }
  sequence(:email) { |n| "test#{n}@example.com" }

  factory :user, class: User do
    name { 'Test User' }
    email { 'test@example.com' }
    password { 'password' }
    activated { 1 }
    activated_at { Time.zone.now }

    trait :with_default_microposts do
      after(:create) do |user|
        user.microposts.create!(content: 'Test micropost.')
      end
    end

    trait :with_sorted_microposts do
      after(:build) do |user|
        user.microposts.build(content: 'Test micropost.', created_at: 10.minutes.ago)
        user.microposts.build(content: 'Most Resent.', created_at: Time.zone.now)
      end
    end

    trait :with_over30_microposts do
      transient do
        posts_count { 31 }
      end

      after(:create) do |user, evaluator|
        evaluator.posts_count.times do |n|
          user.microposts.create!(content: "Test micropost #{n}.")
        end
      end
    end
  end

  factory :list_user, class: User do
    name
    email
    password { 'password' }
    activated { 1 }
    activated_at { Time.zone.now }
  end
end
