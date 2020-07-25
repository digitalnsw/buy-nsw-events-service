EventService::Engine.routes.draw do
  resources :events, only: [:create, :index] do
    post :documents_requested, on: :collection
  end
  resources :feedbacks, only: :create
end
