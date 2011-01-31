class User < ActiveRecord::Base
  has_many :furrows
  has_many :furrows, :foreign_key => 'seed_user_id'

  validates_presence_of :twitter_id
  validates_presence_of :nickname
  
  validates_uniqueness_of :twitter_id
  validates_uniqueness_of :nickname

  def follow(user)
    @client ||= fetch_client
    @client.friendship_create(user.twitter_id, true)
  end

  def unfollow(user)
    @client ||= fetch_client
    @client.friendship_destroy(user.twitter_id)
  end

  def follows?(user)
    @client ||= fetch_client
    @client.friendship_exists?(nickname, user.nickname)
  rescue Twitter::General => e
    return false if e.message =~ /Could not find both specified users/
    raise e
  end

  def self.new_from_nickname(twitter_nickname)
    return unless twitter_nickname

    twitter_nickname = twitter_nickname.delete '@'
    
    existing_user = User.find_by_nickname(twitter_nickname)
    return existing_user if existing_user

    credentials = Twitter::OAuth.new(TWITTER_KEY, TWITTER_SECRET)
    client = Twitter::Base.new(credentials)
    user_details = client.user(twitter_nickname)

    User.new(:twitter_id => user_details.id,
             :name => user_details.name,
             :nickname => user_details.screen_name,
             :image_url => user_details.profile_image_url)
  rescue Twitter::NotFound => not_found
    user = User.new(:nickname => twitter_nickname)
    user.errors.add(:nickname, "Couldn't find twitter user named #{twitter_nickname}")
    user
  end

private

  def fetch_client
    credentials = Twitter::OAuth.new(TWITTER_KEY, TWITTER_SECRET)
    credentials.authorize_from_access(self.token, self.secret)
    @client = Twitter::Base.new(credentials)
  end
end
