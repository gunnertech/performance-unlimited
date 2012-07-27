Recoverytracker::Application.routes.draw do
  devise_for :users

  resources :selected_responses

  resources :assigned_questions

  resources :questions do
    resources :responses
  end

  resources :assigned_question_sets, only: [] do
    resources :assigned_questions
  end

  resources :question_sets

  resources :point_ranges

  resources :assigned_surveys

  resources :surveys do
    resources :completed_surveys
    resources :assigned_question_sets
  end

  resources :assigned_groups
  
  resources :groups, only: [] do
    resources :users
  end
  
  resources :groups #TODO: REMOVE
  
  resources :divisions do
    resources :groups
  end

  resources :organizations
  
  resources :assigned_divisions #TODO: REMOVE
  resources :completed_surveys #TODO: REMOVE
  
  resources :users do
    resources :assigned_divisions
    resources :completed_surveys
  end

  
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
end
