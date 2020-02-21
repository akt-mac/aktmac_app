Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :repairs do
    member do
      get 'edit_progress' # 進捗チェック
      patch 'update_progress'
      patch 'update_contacted' # 連絡チェック
      patch 'update_delivery' # 引渡チェック
      patch 'update_reminder' # 催促チェック
    end
    collection do
      get 'export'
    end
  end
  resources :machine_categories
end
