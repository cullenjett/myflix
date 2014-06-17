Myflix::Application.routes.draw do
  root to: 'pages#front'

  get '/home', to: 'videos#index', as: 'home'
  get 'ui(/:action)', controller: 'ui'

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end

  resources :categories, only: [:show]

  resources :users, only: [:create]
  get '/register', to: 'users#new', as: 'register'

  get '/sign_in', to: 'sessions#new', as: 'sign_in'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy', as: 'sign_out'
end
