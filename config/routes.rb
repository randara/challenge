Rails.application.routes.draw do
  root to: "user#index"

  get 'user/index'
  post 'user/upload'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
