require 'spec_helper'

describe User, "being created without twitter" do
  subject {FactoryGirl.build(:user)}

  context "without a twitter id" do
    before {subject.twitter_id = nil}

    it {should_not be_valid}
  end

  context "without a nickname" do
    before {subject.nickname = nil}

    it {should_not be_valid}
  end

  context "with a duplicate twitter id" do
    before {FactoryGirl.create(:user, :twitter_id => subject.twitter_id)}

    it {should_not be_valid}
  end

  context "with a duplicate nickname" do
    before {FactoryGirl.create(:user, :nickname => subject.nickname)}

    it {should_not be_valid}
  end
end

describe User, "being initialized from nickname" do
  use_vcr_cassette 'new_from_nickname', :record => :new_episodes

  context "when the nickname is valid has no '@' symbol" do
    subject {User.new_from_nickname('nerded')}
    
    it {should be_valid}
  end

  context "when the nickname is valid has an '@' symbol" do
    subject {User.new_from_nickname('@nerded')}

    it {should be_valid}
  end

  context "when the nickname is valid, but the user already exists" do
    before do
      @user = FactoryGirl.create(:user)
    end

    subject {User.new_from_nickname(@user.nickname)}

    it {should be_valid}
  end

  context "whent the nickname is not valid" do
    subject {User.new_from_nickname('fake_usernamexx1231341231123')}

    it {should_not be_valid}
  end
end

describe User, "checking whether it follows another user" do
  use_vcr_cassette 'following_check', :record => :new_episodes

  before {@user = User.new_from_nickname('nerded')}
  subject {@user.follows?(@other_user)}

  context "when the user is following the other user" do
    before {@other_user = FactoryGirl.create(:user, :nickname => 'bryanl')}

    it {should be_true}
  end

  context "when the user isn't following the other user" do
    before {@other_user = FactoryGirl.create(:user, :nickname => 'dhh')}

    it {should be_false}
  end
  
  context "when the user that is being checked on doesn't exist" do
    before {@other_user = FactoryGirl.create(:user, :nickname => 'fake_usernamexx129134')}

    it {should be_false}
  end
end

describe User, "with an authenticated twitter client" do
  before do
    @user = FactoryGirl.create(:user)
    @seed_user = FactoryGirl.create(:user) 

    @twitter_client = mock('client')
    Twitter::Client.stub!(:new).and_return(@twitter_client)
  end

  context "following another user" do
    context "when the user to be followed isn't already being followed" do
      before do
        @twitter_client.stub!(:follow).and_return(@seed_user.twitter_id)
      end

      it "should follow the user" do
        @user.follow(@seed_user)
      end
    end

    context "when the user to be followed is already being followed"

    context "when the user to be followed doesn't exist"
  end

  context "unfollowing another user" do
    context "when the user to be unfollowed is already being followed" do
      before do
        @twitter_client.stub!(:unfollow).and_return(@seed_user.twitter_id)
      end
      
      it "should unfollow the seed user" do
        @user.unfollow(@seed_user)
      end
    end

    context "when the user to be unfollowed isn't being followed"

    context "when the user to be unfollowed doesn't exist"
  end
end
