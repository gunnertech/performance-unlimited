Recoverytracker::Application.routes.draw do
  devise_for :users

  resources :selected_responses

  resources :responses

  resources :assigned_questions

  resources :questions

  resources :assigned_question_sets

  resources :question_sets

  resources :point_ranges

  resources :assigned_surveys

  resources :surveys do
    resources :completed_surveys
  end

  resources :assigned_groups
  
  resources :groups, only: [] do
    resources :users
  end

  resources :divisions do
    resources :groups
  end

  resources :organizations
  
  resources :users do
    resources :assigned_divisions
    resources :completed_surveys
  end

  
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
end
