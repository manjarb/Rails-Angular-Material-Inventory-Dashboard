Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :inventories do
        collection do
          post :upload
          get :summary
        end
      end

      resources :preferences do
        collection do
          post :upload
        end
      end
    end
  end
end
