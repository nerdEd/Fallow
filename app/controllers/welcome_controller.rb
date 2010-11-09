class WelcomeController < ApplicationController
  def index
    @current_user = current_user
    if(@current_user)
      @furrow = Furrow.new(:user => @current_user, :seed_user => User.new)
    end
  end
end
