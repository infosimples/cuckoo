Cuckoo::Application.routes.draw do

  root :to => "timesheet#show"

  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get  'users/new_admin'    => 'users/registrations#new_admin'
    post 'users/create_admin' => 'users/registrations#create_admin'
  end

  resources :users
  resources :settings, :only => [:index, :update]
  resources :projects, :except => [:show, :destroy]
  resources :tasks, :except => [:show, :destroy]
  resources :time_entries

  patch 'time_entries/:id/finish' => 'time_entries#finish', as: :time_entry_finish

  get 'timesheet(/:year/:month/:day)' => 'timesheet#show', as: :timesheet

  get 'reports' => 'reports#new', as: :reports
  post 'reports' => 'reports#view'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
