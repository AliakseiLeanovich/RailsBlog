Rails.application.routes.draw do

  devise_for :users
  resources :articles do
    resources :comments
    collection do
      get :stats
    end
  end

  root 'welcome#index'
end
