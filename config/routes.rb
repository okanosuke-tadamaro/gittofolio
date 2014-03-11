Gittofolio::Application.routes.draw do
  
  resources :users do
    resources :repositories
    resources :details
  end

  get "welcome/index"
  root 'welcome#index'
  get '/search' => 'welcome#user_search'
  get '/welcome/signout'
  get 'github/callback' => 'welcome#callback'

  get '/account/:current_user' => 'welcome#settings'
  get '/repository' => 'repository#index'
  get '/:user_name' => "repository#index", :as => "repo"
  get '/:user_name/:repo_name' => "repository#detail", :as => "each_repo"
  get '/:user_name/:repo_name/*repo_directory' => "repository#detail"

  # get 'welcome/signout'

end