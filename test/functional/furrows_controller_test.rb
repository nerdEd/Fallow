require 'test_helper'

class FurrowsControllerTest < ActionController::TestCase
  test "post to create w/ user logged in and a complete furrow form" do
    stub_new_from_nickname
    stub_logged_in

    User.any_instance.expects(:follow)

    assert_difference ['Furrow.count'], 1 do
      post :create, valid_params
    end

    assert_redirected_to root_path
    furrow = Furrow.last
    assert_equal flash[:notice], "Great Success! You will now #{furrow.action} @#{furrow.seed_user.nickname} for #{furrow.duration} day(s)"
  end

  test "post to create w/o a user logged in and a complete furrow form" do
    assert_difference ['Furrow.count', 'User.count'], 0 do
      post :create, valid_params
    end

    assert_redirected_to root_path
  end

  test "post to create w/ a user logged in and a missing seed user name" do
    stub_logged_in
    stub_bad_user_create('bad_user')

    assert_difference ['Furrow.count', 'User.count'], 0 do
      post :create, valid_params
    end

    assert_response 200
  end

  test "post to create w/o a user logged in and a incomplete furrow form" do

  end

  def stub_new_from_nickname 
    User.expects(:new_from_nickname).once.returns(Factory(:user))
  end

  def stub_logged_in
    session[:user] = Factory(:user)
  end

  def valid_params
    {:furrow => {:action => 'follow', :duration => 5}, :user => {:nickname => 'valid_twitter_user'}}
  end

  def stub_bad_user_create(twitter_nickname)
    user = User.new(:nickname => twitter_nickname)
    user.errors.add(:nickname, "Couldn't find twitter user named #{twitter_nickname}")
    User.expects(:new_from_nickname).returns(user)
  end
end
