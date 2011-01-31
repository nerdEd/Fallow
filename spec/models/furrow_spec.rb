require 'spec_helper'

describe Furrow, "being created" do
  subject {Factory.build(:furrow)}

  it {should be_valid}
  
  it {should be_unstarted}

  context "without a user" do
    before {subject.user = nil}

    it {should_not be_valid}
  end

  context "without a seed user" do
    before {subject.seed_user = nil}

    it {should_not be_valid}
  end

  context "with identical user and seed user" do
    before {subject.seed_user = subject.user}

    it {should_not be_valid}
  end

  context "with no duration set" do
    before {subject.duration = nil}

    it {should_not be_valid}
  end

  context "when an identical furrow already exists, unstarted" do
    before do
      Factory(:furrow, :user => subject.user, :seed_user => subject.seed_user)
    end

    it {should_not be_valid}
  end

  context "when an identical furrow already exists, started" do
    before do
      Factory(:furrow, :user => subject.user, :seed_user => subject.seed_user, :state => 'started')
    end

    it {should_not be_valid}
  end

  context "when an identical furrow already exists, finished" do
    before do
      Factory(:furrow, :user => subject.user, :seed_user => subject.seed_user, :state => 'finished')
    end

    it {should be_valid}
  end

  context "with an invalid action" do
    before {subject.action = "Your Mom"}

    it {should_not be_valid}
  end

  context "when the user already follows the seed user" do
    context "then started as a follow" do

      it "should be invalid"
    end
  end

  context "when the user doesn't follow the seed user" do
    context "then started as a unfollow" do

      it "should be invalid" 
    end
  end

  context "then started as a follow" do
    before do
      subject.action = 'follow'
      subject.user.should_receive(:follow).once.with(subject.seed_user)
      subject.start!
    end

    it {should be_started}

    context "and finished" do
      before do
        subject.user.should_receive(:unfollow).with(subject.seed_user)
        subject.finish
      end

      it {should be_finished}
    end
  end

  context "then started as an unfollow" do
    before do
      subject.action = 'unfollow'
      subject.user.should_receive(:unfollow).once.with(subject.seed_user)
      subject.start!
    end

    it {should be_started}

    context "and finished" do
      before do
        subject.user.should_receive(:follow).with(subject.seed_user)
        subject.finish
      end

      it {should be_finished}
    end
  end
end

describe Furrow, "finding complete furrows" do
  subject {Furrow.due_for_completion.count}

  context "when none are ready for completion" do
    before do
      3.times {Factory(:started_follow_furrow)}
    end

    it {should == 0}
  end

  context "when some are ready for completion" do
    before do
      Timecop.freeze(Date.today - 5) do
        3.times {Factory(:started_follow_furrow, :duration => 3, :created_at => Date.today)}
        Factory(:started_follow_furrow, :duration => 6, :created_at => Date.today)
      end
    end

    it {should == 3}
  end
end
