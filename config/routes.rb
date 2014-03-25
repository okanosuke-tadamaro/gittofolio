Gittofolio::Application.routes.draw do
  
  resources :repositories
  resources :users

  root "welcome#welcome"
  get "welcome/index"
  get '/welcome/signout'
  get '/search' => 'welcome#user_search'
  get 'github/callback' => 'welcome#callback'

  get '/repository' => 'repository#index'
  get '/:user_name' => "repository#index"
  get '/:user_name/:repo_name' => "repository#detail"
  get '/:user_name/:repo_name/*repo_directory' => "repository#detail"

end
