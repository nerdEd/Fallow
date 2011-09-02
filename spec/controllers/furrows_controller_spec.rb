require 'spec_helper'

describe FurrowsController do
  let(:user) {Factory(:user)}

  context "as an authenticated user" do
    before do
      stub_logged_in(user)
    end

    #describe 'GET to :index' do
      #before {stub_logged_in(user)}
      #subject {get :index}

      #context 'with existing active furrows' do
        #before {@furrow = Factory(:started_follow_furrow, :user => user)}

        #it 'should assign the correct furrows' do
          #assigns[:furrows].should == [@furrow]
        #end
      #end

      #context 'with only active furrows existing for other users' do
        #before {Factory(:started_unfollow_furrow)}

        #it 'should not assign furrows that do not belong to current user' do
          #assigns[:furrows].should == []
        #end
      #end

      #context 'with only expired furrows' do
        #let(:furrow) {Factory(:finished_follow_furrow)}
        #before {furrow}

        #it 'should not return expired furrows' do
          #assigns[:furrows].should == []
        #end
      #end

      #context 'with expired and active furrows' do
        #let(:furrow) {Factory(:started_follow_furrow)}
        #before do
          #furrow
          #Factory(:finished_follow_furrow)
        #end

        #it 'should only assign the active furrows' do
          #assigns[:furrows].should == [furrow]
        #end
      #end
    #end

    describe 'POST to :create' do
      let(:post_params) {valid_params}
      subject {post :create, post_params}

      context 'with complete form' do
        before do
          stub_new_from_nickname
          user.stub!(:follow)
        end

        it {should be_redirect}
        it {should redirect_to(new_furrow_path)}
      end

      context 'with missing seed user name' do
        before {stub_bad_user_create('bad_user')}

        it {should render_template(:new)}
      end

      #context "post to :create with seed user that doesn't exist"
      #context "post to :create with invalid duration"
      #context "post to :create with invalid action"
    end
  end

  context "while not authenticated" do
    describe 'GET to :new' do
      subject {get :new}

      it {should be_redirect}
      it {should redirect_to(root_path)}
    end

    describe 'GET to :index' do
      subject {get :index}

      it {should be_redirect}
      it {should redirect_to(root_path)}
    end

    describe 'POST to :create' do
      subject {post :create, post_params}

      context 'with complete params' do
        let(:post_params) {valid_params}

        it {should be_redirect}
        it {should redirect_to(root_path)}
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
  {'furrow' => {'action' => 'follow', 
               'duration' => 5, 
               'user' => {'nickname' => 'valid_twitter_user'}}
  }
end
