Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :messages do
    collection do
      get :unread
      get :read
      get :sent
    end
    member do
      post :mark_read
    end
  end

  # These don't exist
  resources :message_tickets
  resources :users

end
