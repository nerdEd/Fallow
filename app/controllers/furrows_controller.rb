class FurrowsController < ApplicationController
  def create
    seed_user = User.new_from_nickname(params[:user][:nickname])
    seed_user.save

    @furrow = Furrow.new(params[:furrow].merge!({:user => current_user, :seed_user => seed_user}))
    if(@furrow.save)
      redirect_to root_path
    else
      render 'welcome/index'
    end
  end
end
