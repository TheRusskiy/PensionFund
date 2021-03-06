Pensionfund::Application.routes.draw do
  root :to => 'home#index'

  resources :users

  resources :job_positions

  resources :payments

  resources :employees

  resources :transfers do
    collection do
      get 'edit',
          as: 'edit',
          to: 'transfers#bulk_edit'
      put 'save',
          as: 'save',
          to: 'transfers#bulk_save'
    end
  end

  resources :property_types

  resources :companies do
    member do
      get 'payments',
          as: 'edit_payments',
          to: 'companies#bulk_edit'
      put 'payments',
          as: 'save_payments',
          to: 'companies#bulk_save'
    end
  end

  resources :contracts

  get "queries/inspector"
  get "queries/manager"

  match '/login' => 'application#authenticate', via: [:get, :post]
  match '/logout' => 'application#logout', via: [:get, :post]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
