class Furrow < ActiveRecord::Base
  include ActiveRecord::Transitions

  belongs_to :user
  belongs_to :seed_user, :class_name => 'User'

  validates_presence_of :user
  validates_presence_of :seed_user
  validates_presence_of :state

  validate :user_and_seed_user_cannot_be_the_same

  attr_accessor :duration

  state_machine do
    state :unstarted # first one is initial state
    state :started

    event :start do
     transitions :to => :started, :from => [:unstarted], :on_transition => :start_furrow
    end
  end  

private

  def start_furrow
    user.follow(seed_user)
  end

  def user_and_seed_user_cannot_be_the_same
    errors.add(:base, 'Users must be different') if user == seed_user
  end
end
