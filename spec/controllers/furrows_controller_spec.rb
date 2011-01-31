require 'spec_helper'

describe FurrowsController do

  context "as an authenticated user" do
    before do
      @user = Factory(:user)
      stub_logged_in(@user)
    end

    context "post to :create with complete form" do
      before do
        stub_new_from_nickname
        @user.stub!(:follow)
        post :create, valid_params
      end

      it "should respond with redirect" do
        response.should be_redirect
      end

      it "should give a success message to the user" do
        flash[:notice].should =~ /Success/
      end
    end

    context "post to :create with missing seed user name" do
      before do
        stub_bad_user_create('bad_user')
        post :create, valid_params
      end

      it "should response with success" do
        response.should be_success
      end
    end

    context "post to :create with seed user that doesn't exist"

    context "post to :create with invalid duration"

    context "post to :create with invalid action"
  end

  context "while not authenticated" do
    context "post to :create with complete form" do
      before {post :create, valid_params}

      it "should respond with redirect" do
        response.should be_redirect
      end
    end
  end
end

def stub_new_from_nickname 
  User.stub!(:new_from_nickname).and_return(Factory(:user))
end

def stub_bad_user_create(twitter_nickname)
  user = User.new(:nickname => twitter_nickname)
  user.errors.add(:nickname, "Couldn't find twitter user named #{twitter_nickname}")
  User.stub!(:new_from_nickname).and_return(user)
end

def stub_logged_in(user=Factory(:user))
  User.stub!(:find).with(user.id).and_return(user)
  session[:user] = user.id
end

def valid_params
  {:furrow => {:action => 'follow', 
               :duration => 5}, 
   :user => {:nickname => 'valid_twitter_user'}
  }
end
