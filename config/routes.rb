Gittofolio::Application.routes.draw do
  
  resources :repositories
  resources :users
  get "welcome/index"
  root 'welcome#index'
  get '/search' => 'welcome#user_search'
  get '/welcome/signout'
  get 'github/callback' => 'welcome#callback'

  controller :repository do
    get '/repository' => 'repository#index'
    get '/:user_name' => "repository#index"
    get '/:user_name/:repo_name' => "repository#detail"
    get '/:user_name/:repo_name/*repo_directory' => "repository#detail"
  end

  # get 'welcome/signout'

end