PerformanceUnlimited::Application.routes.draw do


  resources :metric_types

  match '/auth/:provider/callback', to: 'organizations#add_authentication'
  
  scope "/admin" do
    resources :users do
      member do
        get 'dashboard'
        put 'transfer'
        post 'sign_in_as'
      end
    end
  end
  
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

  resources :surveys do
    resources :completed_surveys
    resources :assigned_question_sets
  end

  resources :assigned_groups
  
  resources :groups, only: [] do
    resources :users
  end
  
  resources :groups do
    member do
      get 'dashboard'
    end
  end
  resources :assigned_surveys, only: [] do
    resources :point_ranges
  end
  
  resources :groups do
    member do
      get 'dashboard'
      put 'upload_performance_data'
      get 'download_performance_template'
    end
  end
  
  resources :divisions do
    member do
      get 'dashboard'
      put 'upload_performance_data'
      get 'download_performance_template'
    end
  end
  
  
  resources :divisions do
    member do
      get 'leaderboard'
      get 'dashboard'
    end
    resources :groups do
      member do
        get 'dashboard'
        put 'upload_performance_data'
        get 'download_performance_template'
      end
    end
    resources :assigned_surveys
  end

  resources :organizations do
    member do
      get 'dashboard'
      put 'upload_performance_data'
      get 'download_performance_template'
    end
    resources :metrics
    resources :divisions do
      member do
        get 'dashboard'
        put 'upload_performance_data'
        get 'download_performance_template'
      end
    end
  end
  
  resources :assigned_divisions #TODO: REMOVE
  resources :completed_surveys #TODO: REMOVE
  
  resources :recorded_metrics, only: [] do
    collection do
      get 'average'
    end
  end
  
  resources :metrics, only: [] do
    member do
      get 'calculations'
    end
    
    resources :alerts
  end
  
  resources :comments, only: [:create]
  
  resources :users, only: [:show,:update,:create] do
    resources :comments
    resources :assigned_alerts
    resources :assigned_divisions
    resources :completed_surveys
    resources :assigned_groups
    resources :recorded_metrics
    resources :divisions
  end

  
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
end
