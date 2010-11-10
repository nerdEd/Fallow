class Furrow < ActiveRecord::Base
  include ActiveRecord::Transitions

  belongs_to :user
  belongs_to :seed_user, :class_name => 'User'

  validates_presence_of :user
  validates_presence_of :seed_user
  validates_presence_of :state

  validate :user_and_seed_user_cannot_be_the_same
  validate :cannot_overlap_furrows

  attr_accessor :duration

  state_machine do
    state :unstarted # first one is initial state
    state :started
    state :finished

    event :start do
     transitions :to => :started, :from => [:unstarted], :on_transition => :start_furrow
    end
  end  

  def self.active
    where("state = ? OR state = ?", 'started', 'unstarted')
  end

private

  def start_furrow
    user.follow(seed_user)
  end

  def cannot_overlap_furrows
    return unless self.user_id && self.seed_user_id && !self.id
    overlappers = Furrow.active.where("user_id = ? AND seed_user_id = ?", self.user_id, self.seed_user_id) 
    errors.add(:base, 'Cannot have overlapping furrows') if overlappers.count > 0
  end

  def user_and_seed_user_cannot_be_the_same
    errors.add(:base, 'Users must be different') if user == seed_user
  end
end
