Gittofolio::Application.routes.draw do

  root 'repository#index'
  get "/:user_name" => "repository#all"
  # get "/:user_name/:language" => "repository#by_language"

end
