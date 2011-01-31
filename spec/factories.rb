Factory.define :furrow do |f|
  f.association :user
  f.association :seed_user
  f.duration 5
end

Factory.define :follow_furrow, :parent => :furrow do |f|
  f.action 'follow'
end

Factory.define :unfollow_furrow, :parent => :furrow do |f|
  f.action 'unfollow'
end

Factory.define :started_unfollow_furrow, :parent => :furrow do |f|
  f.state 'started'
end

Factory.define :started_follow_furrow, :parent => :follow_furrow do |f|
  f.state 'started'
end

Factory.define :user do |f|
  f.sequence(:twitter_id) {|n| "fakeid#{n}"}
  f.sequence(:nickname) {|n| "frankie0#{n}"}
  f.token 'my_token'
  f.secret 'my_secret'
end

Factory.define :seed_user, :parent => :user do |f|

end
