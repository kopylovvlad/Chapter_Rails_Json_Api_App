Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'api/home#hello'

  match '*path', to: 'api/home#not_found', via: %i[get post put patch delete]
end
