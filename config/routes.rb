Accelr8::Application.routes.draw do

  resources :accelerators do
#   member do
#     post 'terms'
#   end
  end
  match 'accelerators/terms' => 'accelerators#terms', :via => :post

  devise_for :accelerator_users

# match 'accelerator_user_root', :to => 'accelerators#index'
  match '/accelerator_user_root', :to => 'accelerators#index'
  match '/accelerators' => 'accelerators#index', :as => :accelerator_user_root

  resources :questionnaires do
    resources :qfounders
    member do
      get 'apply'
    end
  end
# match 'questionnaires/apply' => 'questionnaires#apply', :via => :get

  resources :ac_registrations, :only => [:index]
  match 'ac_registrations/createbatch' => 'ac_registrations#createbatch', :via => :post
  match 'ac_registrations/destroybatch' => 'ac_registrations#destroybatch', :via => :delete

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  root :to => "accelerators#index"
# root :to => "questionnaires#index"  # temp change for testing

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
