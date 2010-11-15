require 'test_helper'

class FurrowsControllerTest < ActionController::TestCase
  test "post to create w/ user logged in and a complete furrow form" do
    stub_logged_in

    assert_difference ['Furrow.count', 'User.count'] do
      stub_new_from_nickname
      post :create, valid_params
    end

    assert_redirected_to root_path
    furrow = Furrow.last
    assert_select('#notice', "Great Success! You will now #{furrow.action} for #{furrow.duration} day(s)")
  end

  #test "post to create w/o a user logged in and a complete furrow form" do
    #assert_difference ['Furrow.count', 'User.count'], 0 do
      #post :create, valid_params
    #end

    #assert_redirected_to root_path
    #assert_select('#notice', 'Please sign in with Twitter')
  #end

  #test "post to create w/ a user logged in and a missing seed user name" do
    #stub_logged_in
    #stub_bad_user_create('bad_user')

    #assert_difference ['Furrow.count', 'User.count'], 0 do
      #post :create, valid_params
    #end

    #assert_redirected_to root_path
    #assert_select('#error', "Couldn't find twitter user named bad_user")
  #end

  #test "post to create w/o a user logged in and a incomplete furrow form" do

  #end

  def stub_new_from_nickname 
    User.expects(:new_from_nickname).once.returns(Factory(:user))
  end

  def stub_logged_in
    FurrowsController.any_instance.expects(:current_user).twice.returns(Factory(:user))
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
