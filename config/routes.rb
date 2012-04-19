Fallow::Application.routes.draw do
  match '/auth/:provider/callback' => 'users#create', :as => 'twitter_sign_in'
  match '/auth/failure' => 'users#failed_auth'
  match '/logout' => 'users#logout', :as => 'logout'

  resources :furrows, :only => [:create, :index] do
    member do
      put :cancel
    end
  end

  root :to => "welcome#index"
end
