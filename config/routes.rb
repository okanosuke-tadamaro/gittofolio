Gittofolio::Application.routes.draw do

  get "welcome/index"
  root 'welcome#index'
  get '/repository' => 'repository#index'
  get "/:user_name" => "repository#index"
  get 'github/callback' => 'welcome#callback'
  # get "/:user_name/:language" => "repository#by_language"

end
