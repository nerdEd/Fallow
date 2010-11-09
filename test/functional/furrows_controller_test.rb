require 'test_helper'

class FurrowsControllerTest < ActionController::TestCase
  test "post to create w/ user logged in and a complete furrow form" do
    stub_logged_in

    assert_difference ['Furrow.count', 'User.count'] do
      stub_new_from_nickname
      post :create, valid_params
    end

    assert_redirected_to root_path
  end

  test "post to create w/o a user logged in and a complete furrow form" do

  end

  test "post to create w/ a user logged in and a incomplete furrow form" do

  end

  test "post to create w/o a user logged in and a incomplete furrow form" do

  end

  def stub_new_from_nickname 
    User.expects(:new_from_nickname).once.returns(Factory(:user))
  end

  def stub_logged_in
    FurrowsController.any_instance.expects(:current_user).returns(Factory(:user))
  end

  def valid_params
    {:furrow => {:action => 'follow', :duration => 5}, :user => {:nickname => 'valid_twitter_user'}}
  end
end
