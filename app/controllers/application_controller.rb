class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def require_user
    unless current_user
      flash[:notice] = 'Plase sign in with Twitter'
      redirect_to root_path
    end
  end

  def current_user
    User.find(session[:user]) if session[:user]
  end

  def logged_in?
    !session[:user].nil?
  end
end
