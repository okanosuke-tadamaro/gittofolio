Gittofolio::Application.routes.draw do
  
  resources :repositories
  resources :users
  resources :websites, :only => [:create]

  get '/github/callback' => 'welcome#callback'
  get '/signout' => "welcome#destroy"
  get "welcome/index"
  get '/search' => 'welcome#user_search'
  get '/update_display/:repo_id' => 'repository#update_display'
  
  get '/api/activity' => 'api#activity'
  get '/:user_name/settings' => 'users#show'

  get '/repository' => 'repository#index'
  get '/detail' => 'repository#detail'
  get '/:user_name' => "repository#index"
  get '/:user_name/:repo_name' => "repository#detail"
  get '/:user_name/:repo_name/*repo_directory' => "repository#detail"

  root "welcome#welcome"

end
