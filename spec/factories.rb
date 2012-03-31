FactoryGirl.define do
  factory :furrow do |f|
    f.association :user
    f.association :seed_user
    f.duration 5
  end

  factory :follow_furrow, :parent => :furrow do |f|
    f.action 'follow'
  end

  factory :unfollow_furrow, :parent => :furrow do |f|
    f.action 'unfollow'
  end

  factory :started_unfollow_furrow, :parent => :furrow do |f|
    f.state 'started'
  end

  factory :started_follow_furrow, :parent => :follow_furrow do |f|
    f.state 'started'
  end

  factory :user do |f|
    f.sequence(:twitter_id) {|n| "fakeid#{n}"}
    f.sequence(:nickname) {|n| "frankie0#{n}"}
    f.token 'my_token'
    f.secret 'my_secret'
  end

  factory :seed_user, :parent => :user do |f|

  end
end
