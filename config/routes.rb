require "api_version_constraint"

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # devise_for :users
  namespace :api,
            defaults: {
              format: :json
            },
            constraints: {
              subdomain: "api"
            },
            path: "/" do
    namespace :v1,
              path: "/",
              constraints:
                ApiVersionConstraint.new(version: 1, default: true) do
      resources :sessions, only: %i[create destroy]
      resources :users
      resources :tasks
    end
  end
end
