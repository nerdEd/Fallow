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

  test 'a furrow should be invalid if the duration is blank' do
    furrow = Factory.build(:furrow, :duration => nil)
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

  test 'a furrow cannot exist if there is already a furrow for those users in the started or unstarted state' do
    active_furrow = Factory(:follow_furrow, :state => 'started')
    spare_furrow = Factory.build(:follow_furrow, :user => active_furrow.user, :seed_user => active_furrow.seed_user)

    assert !spare_furrow.valid?
  end

  test 'a furrow is invalid with an action of anything other than follow or unfollow' do
    furrow = Factory.build(:furrow, :action => 'fuck')
    assert !furrow.valid?
  end

  test 'a furrow can exist if there is already a furrow for those users but it is in the finished state' do
    active_furrow = Factory(:follow_furrow, :state => 'finished')
    spare_furrow = Factory.build(:follow_furrow, :user => active_furrow.user, :seed_user => active_furrow.seed_user)

    assert spare_furrow.valid?
  end

  test 'finding furrows that are ready to be finished when none are ready for completion' do
    3.times do Factory(:follow_furrow) end
    complete_furrows = Furrow.due_for_completion

    assert_equal 0, complete_furrows.size
  end

  test 'finding furrows that are ready to be finished when some are ready' do
    Timecop.freeze(Date.today - 5) do
      3.times do Factory(:started_follow_furrow, :duration => 3, :created_at => Date.today) end
      Factory(:started_follow_furrow, :duration => 6, :created_at => Date.today)
    end

    assert_equal 3, Furrow.due_for_completion.count
  end

end
