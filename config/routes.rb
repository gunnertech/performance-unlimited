Recoverytracker::Application.routes.draw do

  resources :metric_types

  match '/auth/:provider/callback', to: 'organizations#add_authentication'
  
  devise_for :users
  
  resources :authentications

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
    member do
      get 'leaderboard'
    end
    resources :groups
    resources :assigned_surveys
  end

  resources :organizations do
    resources :metrics
    resources :divisions
  end
  
  resources :assigned_divisions #TODO: REMOVE
  resources :completed_surveys #TODO: REMOVE
  
  resources :users, only: [] do
    resources :assigned_divisions
    resources :completed_surveys
    resources :assigned_groups
    resources :recorded_metrics
  end
  
  scope "/admin" do
    resources :users
  end

  
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
end
