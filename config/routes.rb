Rails.application.routes.draw do
  mount_devise_token_auth_for "User", at: "api/v1/auth"
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      get "/farm", to: "farms#show"

      patch "/entities/:id/move", to: "entities#move"
      patch "/entities/:id/level_up", to: "entities#level_up"
      delete "/entities/:id", to: "entities#destroy"
      post "/entities", to: "entities#create"
    end
  end
end
