Rails.application.routes.draw do

  resources :roles

  get 'results/index'

  devise_for :users
  resources :articles do
    resources :comments
    collection do
      get :stats
    end
  end

  get 'results', to: 'results#index', as: 'results'
  get 'tags/:tag', to: 'articles#index', as: :tag

  root 'welcome#index'

  resources :users
  resources :groups
end
