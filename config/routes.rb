Rails.application.routes.draw do
  get "copy", to: "copies#index"
  get "copy/refresh", to: "copies#refresh"
  get "copy/:key", to: "copies#show", constraints: { key: /[\w.]+/ }
end
