require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'a user should be ivalid without a twitter id' do
    user = Factory.build(:user, :twitter_id => nil)
    assert !user.valid?
  end

  test 'a user should be invalid without a nickname' do
    user = Factory.build(:user, :nickname => nil)
    assert !user.valid?
  end

  test 'a user should be invalid if its twitter_id is not unique' do
    user = Factory(:user)
    dup_user = Factory.build(:user, :twitter_id => user.twitter_id)
    assert !dup_user.valid?
  end

  test 'generating a user from a valid twitter nickname' do
    VCR.use_cassette('new_from_nickname') do
      user = User.new_from_nickname('nerded')
      assert user.valid?
    end
  end

  test 'generating a user from a twitter nickname with the @ symbol' do
    VCR.use_cassette('new_from_nickname') do
      user = User.new_from_nickname('@nerded')
      assert user.valid?
    end
  end

  test 'generating a user from a twitter nickname when that user already exists' do
    user = Factory(:user)
    second_time = User.new_from_nickname(user.nickname)
    assert second_time.valid?
  end

  test 'generating a user from a invalid twitter nickname' do
    VCR.use_cassette('bad_new_from_nickname') do
      user = User.new_from_nickname('fake_usernamexx892342kj')
      assert !user.valid?
    end
  end

  test 'a user should be invalid if its nickname is not unique' do
    user = Factory(:user)
    dup_user = Factory.build(:user, :nickname => user.nickname)
    assert !dup_user.valid?
  end

  test 'following another user' do
    user = Factory(:user)
    seed_user = Factory(:user, :twitter_id => '123456')

    twitter_client = mock('client')
    stub_client_creation(twitter_client, user.token, user.secret)
    twitter_client.expects(:friendship_create).once.with(seed_user.twitter_id, true)

    user.follow(seed_user)
  end

  test 'unfollowing another user' do
    user = Factory(:user)
    seed_user = Factory(:user, :twitter_id => '123456')

    twitter_client = mock('client')
    stub_client_creation(twitter_client, user.token, user.secret)
    twitter_client.expects(:friendship_destroy).once.with(seed_user.twitter_id)

    user.unfollow(seed_user)
  end

  test 'following another user that is already being followed' do

  end

  test 'unfollowing a user who is not currently being followed' do

  end

  test 'following another user w/ failure' do

  end

  test 'unfollowing another user w/ failure' do

  end

  def stub_user_search(username)
    twitter_result = mock('result', :id => '123456',
                                    :name => 'Frank N Beans',
                                    :screen_name => username,
                                    :profile_image_url => 'http://images.twitter.com/123456')
    twitter_client = mock('client', :user => twitter_result)
    stub_client_creation(twitter_client)
  end

  def stub_client_creation(twitter_client, access_token=nil, access_secret=nil)
    credentials = mock('credentials')
    Twitter::OAuth.expects(:new).once.returns(credentials)

    if(access_token && access_secret)
      credentials.expects(:authorize_from_access).once.with(access_token, access_secret)
    end

    Twitter::Base.expects(:new).once.returns(twitter_client)
  end
end
