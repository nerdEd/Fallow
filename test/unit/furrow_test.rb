require 'test_helper'

class FurrowTest < ActiveSupport::TestCase
  test 'a furrow should be invalid without a user' do
    furrow = Factory.build(:furrow, :user => nil)
    assert !furrow.valid?
  end

  test 'a furrow should be invalid without a seed user' do
    furrow = Factory.build(:furrow, :seed_user => nil)
    assert !furrow.valid?
  end

  test 'a furrow should be invalid if the user and seed user are the same' do
    user = Factory(:user)
    furrow = Factory.build(:furrow, :user => user, :seed_user => user)
    assert !furrow.valid?
  end

  test 'a valid new furrow should be in the "unstarted" state' do
    furrow = Factory.build(:furrow)
    assert furrow.valid?
  end

  test 'a follow furrow which is started should then be in the started state and follow the seed user' do
    furrow = Factory(:follow_furrow)
    furrow.user.expects(:follow).once.with(furrow.seed_user)
    furrow.start!
    assert furrow.started?
  end
end
