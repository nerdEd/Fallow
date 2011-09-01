class FurrowsController < ApplicationController

  before_filter :require_user

  def new
    @current_user = current_user
    @furrow = Furrow.new(:user => @current_user, :seed_user => User.new)
  end

  def create
    seed_user = User.new_from_nickname(params['furrow']['user']['nickname'])

    @furrow = Furrow.new(params['furrow'].merge!({:user => current_user, :seed_user => seed_user}))

    if(@furrow.save)
      flash[:notice] = "Great Success! You will now #{@furrow.action} @#{@furrow.seed_user.nickname} for #{@furrow.duration} day(s)"
      @furrow.start!
      redirect_to new_furrow_path
    else
      @current_user = current_user
      render :new
    end
  end
end
