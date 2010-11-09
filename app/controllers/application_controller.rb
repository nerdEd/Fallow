class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    User.find(session[:user]) if session[:user]
  end

  def logged_in?
    !session[:user].nil?
  end
end
