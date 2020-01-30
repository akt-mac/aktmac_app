Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # 進捗チェック
  get 'repairs/:id/edit_progress', to: 'repairs#edit_progress', as: 'progress'
  patch 'repairs/:id/update_progress', to: 'repairs#update_progress', as: 'update_progress'

  # 連絡チェック
  get 'repairs/:id/edit_contacted', to: 'repairs#edit_contacted', as: 'contacted'
  patch 'repairs/:id/update_contacted', to: 'repairs#update_contacted', as: 'update_contacted'

  # 引渡チェック
  patch 'repairs/:id/update_delivery', to: 'repairs#update_delivery', as: 'update_delivery'

  resources :users
  resources :repairs
  resources :machine_categories
end
