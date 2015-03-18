Rails.application.routes.draw do

  devise_for :users
  resources :articles do
    resources :comments
    collection do
      get :stats
    end
  end

  #match 'articles/stats', to: 'articles#stats', via: [:get]
  root 'welcome#index'
end
