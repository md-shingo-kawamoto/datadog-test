Rails.application.routes.draw do
  root 'todos#index'
  
  resources :todos do
    member do
      patch :toggle
    end
  end
  
  # APMエラーテスト用エンドポイント
  get '/error/test', to: 'errors#test'
  get '/error/database', to: 'errors#database'
  get '/error/timeout', to: 'errors#timeout'
  get '/health', to: 'health#index'
end

