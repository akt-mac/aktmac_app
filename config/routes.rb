Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      patch 'editor_switch' # 編集権限切替
    end
    collection do
      post 'import'
    end
  end
  resources :repairs do
    member do
      get 'show_sub'
      get 'edit_progress' # 進捗チェック
      patch 'update_progress'
      patch 'update_contacted' # 連絡チェック
      patch 'update_delivery' # 引渡チェック
      patch 'update_reminder' # 催促チェック
    end
    collection do
      get 'export'
      get 'export_pdf'
      get 'data_management'
      post 'import'
      get 'delete_check' # まとめて削除チェック
      patch 'update_delete_check' # まとめて削除チェック更新
      get 'delete_confirmation' # まとめて削除確認
      delete 'delete_all' # まとめて削除
      patch 'reset_delete_check' # 削除選択のリセット
    end
  end
  resources :machine_categories do
    collection do
      post 'import'
    end
  end
end
