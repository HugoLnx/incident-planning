IncidentPlanning::Application.routes.draw do
  resource :features_config, only: %i{edit update}

  devise_for :users,
    path_names: {sign_in: 'login', sign_out: 'logout'},
    controllers: {registrations: :registrations}

  root to: "incidents#index"

  put "/criticalities/:group_id", to: "criticalities#update", as: "update_criticality"

  get "/incident/:incident_id/expression_suggestions/:expression_name", to: "expression_suggestions#index", as: :index

  scope "/incident/:incident_id/cycle/:cycle_id/" do
    post "/group_approval", to: "group_approvals#create", as: :group_approval
    delete "/group_deletion", to: "group_deletions#destroy", as: :group_deletion
  end

  resources :profiles, only: %i{index show}
  resources :companies, only: :index

  resources :incidents do
    resource :cycle_confirmation, only: :show do
      post :show
    end

    resources :cycles do
      resources :objectives_approvals, only: :create
      resources :priorities_approvals, only: :create
      collection do
        post "/new", to: "cycles#new"
      end
      resource :analysis_matrix do
        get :group_approval
        get :group_deletion
      end
      resource :publishes, only: :show do
        post :publish
        get :publish, to: "publishes#new"
      end
      resources :versions, only: [] do
        member do
          get :ics234, as: :ics234, to: "versions#show_ics234"
          get :ics202, as: :ics202, to: "versions#show_ics202"
        end
        collection do
          get "/", as: :new, to: "versions#new"
          get "/all", as: :index, to: "versions#index"
          post "/", as: :create, to: "versions#create"
        end
      end
      resources :tactics
      resources :strategies
    end
  end

  resource :approvals, only: %i{create}


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
