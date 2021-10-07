Rails.application.routes.draw do
  resources :clients, :employees
  resources :countries, :projects, :roles, :persons, only: [:index, :show]

end
