Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'api/home#hello'
  namespace :api, constraints: { format: 'json' } do
    resources :sessions, only: %i[create] do
      get :current, on: :collection
      delete :destroy, on: :collection
    end
    resources :users, only: %i[index create show]
    resources :registrations, only: %i[create]
  end

  match '*path', to: 'api/home#not_found', via: %i[get post put patch delete]
end
