def stub_user_search(username)
  twitter_result = mock('result', :id => '123456',
                                  :name => 'Frank N Beans',
                                  :screen_name => username,
                                  :profile_image_url => 'http://images.twitter.com/123456')
  twitter_client = mock('client', :user => twitter_result)
  stub_client_creation(twitter_client)
end

def stub_client_creation(twitter_client, access_token=nil, access_secret=nil)
  Twitter::Base.expects(:new).once.returns(twitter_client)
end
