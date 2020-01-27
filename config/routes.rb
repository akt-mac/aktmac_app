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

  resources :users
  resources :repairs
  resources :machine_categories
end
