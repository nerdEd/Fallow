class UsersController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by_twitter_id(:twitter_id => auth['uid'])
    user.update_attributes(:name => auth['user_info']['name'],
                           :nickname => auth['user_info']['nickname'],
                           :image_url => auth['user_info']['image'],
                           :token => auth['credentials']['token'],
                           :secret => auth['credentials']['secret'])
    session[:user] = user.id 
    redirect_to furrows_path
  end

  def failed_auth
    redirect_to root_path
  end

  def logout
    session[:user] = nil
    redirect_to root_path
  end
end
