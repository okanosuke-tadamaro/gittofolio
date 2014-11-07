Gittofolio::Application.routes.draw do
  
  get '/github/callback' => 'welcome#callback'
  get '/signout' => "welcome#destroy"

  get '/api/activity' => 'api#activity'
  get '/api/repositories' => 'api#repositories'

  get '/:user_name' => "users#show"
  get '/update_display/:repo_id' => 'repositories#update_display'
  get '/:user_name/:repo_id' => "repositories#show"
  put '/:user_name/:repo_id' => 'repositories#update'
  
  resources :screenshots, :only => [:create]
  resources :websites, :only => [:create]
  resources :repositories, :only => [:update]

  get "welcome/index"
  get '/search' => 'welcome#user_search'

  # get '/:user_name/:repo_name' => "repository#detail"
  # get '/:user_name/:repo_name/*repo_directory' => "repository#detail"

  root "welcome#welcome"

end
