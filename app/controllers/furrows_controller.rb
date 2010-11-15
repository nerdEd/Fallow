class FurrowsController < ApplicationController

  before_filter :require_user

  def create
    seed_user = User.new_from_nickname(params[:user][:nickname])
    if !seed_user.save
      redirect_to root_path
      return
    end

    @furrow = Furrow.new(params[:furrow].merge!({:user => current_user, :seed_user => seed_user}))
    if(@furrow.save!)
      flash[:notice] = "Great Success! You will now #{@furrow.action} #{@furrow.seed_user.nickname} for #{@furrow.duration} day(s)"
      redirect_to root_path
    else
      @current_user = current_user
      render 'welcome/index'
    end
  end
end
