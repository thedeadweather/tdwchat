Rails.application.routes.draw do
  root to: 'rooms#index'

  # указываем в путях к ресурсам токен вместо id
  resources :rooms, only: [:create, :index, :show], param: :token

  mount ActionCable.server => '/cable'
end
