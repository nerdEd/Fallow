class UsersController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by_twitter_id(:twitter_id => auth['uid'])
    info = auth['info']
    credentials = auth['credentials']
    user.update_attributes(:name => info['name'],
                           :nickname => info['nickname'],
                           :image_url => info['image'],
                           :token => credentials['token'],
                           :secret => credentials['secret'])
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
