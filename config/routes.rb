Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get 'home' => 'home#index'

  # react paths here


  post 'auth_user' => 'authentication#authenticate_user'


  namespace :api do
    namespace :v1 do
      resources :predictions do
        resources :prediction_comments
        resources :prediction_categories
        resources :prediction_experts
        resources :prediction_evidences
        resources :prediction_votes
        resources :prediction_flags
      end

      resources :claims do
        resources :claim_comments
        resources :claim_experts
        resources :claim_categories
        resources :claim_evidences
        resources :claim_votes
        resources :claim_flags
      end

      resources :categories

      resources :experts do
        resources :expert_categories
        resources :expert_claims
        resources :expert_comments
        resources :expert_flags
      end
      post 'experts/:expert_id/add_publication' => 'experts#add_publication'

      resources :publications do
        resources :publication_comments
      end

      resources :users

      resource :user do
        post 'add_bookmark' => 'user#add_bookmark'
        post 'remove_bookmark' => 'user#remove_bookmark'
      end

      resource :evidences do
        post 'add_evidence' => 'evidences#add_evidence'
      end
    end
  end
end
