Rails.application.routes.draw do

  namespace :parse do
    resources :dbs
    resources :tasks
  end

  namespace :vk do
    resources :invites
    resources :users
    resources :finds
    resources :accounts
    resources :account_groups, :only => [:create, :edit, :new, :update]
  end

  
  namespace :avito do
    resources :accounts
    resources :postings
    resources :tasks
    resources :finds
  end


  devise_for :users
  resources :images, :only => [:index, :create]
  resources :roles


  
  root  'static_page#main'
  post  'beta' => 'feed_back#beta'

  post  'api/avito' => 'api#avito'
  get   'api/avito' => 'api#avito'

  post  'api/test' => 'api#test'
  get   'api/test' => 'api#test'

  post  'tst' => 'api#txt'
  get   'tst' => 'api#txt'

  get   'test' => 'static_page#test'




  # get 'static_page/about'
  # get 'static_page/help'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #
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
