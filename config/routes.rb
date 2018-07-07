Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'api/home#hello'
  namespace :api, constraints: { format: 'json' } do
    resources :sessions, only: %i[create] do
      get :current, on: :collection
      delete :destroy, on: :collection
    end
    resources :users, only: %i[index create show] do
      scope :module => 'users' do
        resources :chapters, only: %i[index show]
      end
    end
    resources :registrations, only: %i[create]
    resources :chapters do
      scope :module => 'chapters' do
        resources :states, only: [] do
          collection do
            patch :on_review
            patch :approved
            patch :published
          end
        end
        resources :comments do
          scope :module => 'comments' do
            resources :likes, only: %i[index create] do
              delete :destroy, on: :collection
            end
          end
        end
      end
    end
  end

  match '*path', to: 'api/home#not_found', via: %i[get post put patch delete]
end
