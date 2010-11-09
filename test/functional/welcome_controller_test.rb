require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should show twitter login link if the user isn't logged in" do
    WelcomeController.any_instance.expects(:current_user).returns(nil)
    get :index
    assert_select "h2", "To get started sign in with Twitter"
  end

  test "should show furrow form if the user is logged in" do
    WelcomeController.any_instance.expects(:current_user).returns(Factory(:user))
    get :index
    assert_not_nil assigns(:current_user)
    assert_not_nil assigns(:furrow)
    assert_select "#furrowForm"
  end
end
