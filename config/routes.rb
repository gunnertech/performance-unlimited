Recoverytracker::Application.routes.draw do
  resources :selected_responses

  resources :responses

  resources :completed_surveys

  resources :assigned_questions

  resources :questions

  resources :assigned_question_sets

  resources :question_sets

  resources :point_ranges

  resources :assigned_surveys

  resources :surveys

  resources :assigned_groups

  resources :groups

  resources :divisions

  resources :organizations

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
