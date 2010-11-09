Fallow::Application.routes.draw do
  match '/auth/twitter/callback' => 'users#create', :as => 'twitter_sign_in'
  match '/auth/failure' => 'users#failed_auth'
  match '/logout' => 'users#logout', :as => 'logout'

  resources :furrows, :only => [:create]

  root :to => "welcome#index"
end
