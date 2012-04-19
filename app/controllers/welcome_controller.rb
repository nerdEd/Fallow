class WelcomeController < ApplicationController
  def index
    redirect_to furrows_path if logged_in?
  end
end
