Rails.application.routes.draw do
  devise_for :users,
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations'
             }
  get '/member-data', to: 'members#show'
  resources :clients, :employees
  resources :countries, :projects, :roles, :persons, only: [:index, :show]

end
