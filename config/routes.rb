Rails.application.routes.draw do

  get 'results/index'

  devise_for :users
  resources :articles do
    resources :comments
    collection do
      get :stats
    end
  end

  get 'results', to: 'results#index', as: 'results'

  root 'welcome#index'
end
