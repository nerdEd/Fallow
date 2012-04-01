class User < ActiveRecord::Base
  has_many :furrows

  validates_presence_of :twitter_id
  validates_presence_of :nickname
  
  validates_uniqueness_of :twitter_id
  validates_uniqueness_of :nickname

  def follow(user)
    @client ||= fetch_client
    @client.follow(user.twitter_id)
  end

  def unfollow(user)
    @client ||= fetch_client
    @client.unfollow(user.twitter_id)
  end

  def follows?(user)
    @client ||= fetch_client
    @client.friendship?(nickname, user.nickname)
  rescue Twitter::Error::Forbidden
    false
  end

  def self.new_from_nickname(twitter_nickname)
    return unless twitter_nickname

    twitter_nickname = twitter_nickname.delete '@'
    
    existing_user = User.find_by_nickname(twitter_nickname)
    return existing_user if existing_user

    user_details = Twitter.user(twitter_nickname)

    User.new(:twitter_id => user_details.id,
             :name => user_details.name,
             :nickname => user_details.screen_name,
             :image_url => user_details.profile_image_url)

  rescue Twitter::Error::NotFound => e
    user = User.new(:nickname => twitter_nickname)
    user.errors.add(:nickname, "Couldn't find twitter user named #{twitter_nickname}")
    user
  end

private

  def fetch_client
    @client = Twitter::Client.new(
      :oauth_token => self.token,
      :oauth_token_secret => self.secret
    )
  end
end
