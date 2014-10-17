Gittofolio::Application.routes.draw do
  
  get '/:user_name' => "repositories#index"
  get '/:user_name/:repo_id' => "repositories#show"
  put '/:user_name/:repo_id' => 'repositories#update'
  
  resources :screenshots, :only => [:create]
  resources :websites, :only => [:create]

  get '/github/callback' => 'welcome#callback'
  get '/signout' => "welcome#destroy"
  get "welcome/index"
  get '/search' => 'welcome#user_search'
  get '/update_display/:repo_id' => 'repository#update_display'

  get '/api/activity' => 'api#activity'
  get '/api/repositories' => 'api#repositories'

  # get '/:user_name/:repo_name' => "repository#detail"
  # get '/:user_name/:repo_name/*repo_directory' => "repository#detail"

  root "welcome#welcome"

end
