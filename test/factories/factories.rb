Factory.define :furrow do |f|
  f.association :user
  f.association :seed_user
  f.duration 5
end

Factory.define :follow_furrow, :parent => :furrow do |f|
  f.action 'follow'
end

Factory.define :user do |f|
  f.sequence(:twitter_id) {|n| "fakeid#{n}"}
  f.sequence(:nickname) {|n| "frankie0#{n}"}
  f.token 'my_token'
  f.secret 'my_secret'
end

Factory.define :seed_user, :parent => :user do |f|

end
