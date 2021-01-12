Rails.application.routes.draw do
  if Rails.application.credentials.youtube
    get "/youtube", to: "youtube#index"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
