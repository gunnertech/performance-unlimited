Recoverytracker::Application.routes.draw do
  get "users/index"

  get "users/show"

  get "users/create"

  get "users/update"

  get "users/destroy"

  get "users/new"

  get "users/edit"

  devise_for :users
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
end
