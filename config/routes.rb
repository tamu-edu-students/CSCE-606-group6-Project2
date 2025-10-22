Rails.application.routes.draw do
  root "home#index"

  resources :users
  resources :tickets do
    post :assign, on: :member
  end
  get    "/login",  to: "sessions#new"
  delete "/logout", to: "sessions#destroy"
  match  "/auth/:provider/callback", to: "sessions#create", via: [ :get, :post ]
  get    "/auth/failure", to: "sessions#failure"

  # Dev-only quick-login helpers (choose who you want to be)
  if Rails.env.development? || Rails.env.test?
    get "/dev_login/requester", to: "dev_login#requester"
    get "/dev_login/agent",     to: "dev_login#agent"
  end
end
