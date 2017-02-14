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

        post 'predictions/:prediction_id/add_comment' => 'predictions#add_comment'
        post 'predictions/:prediction_id/add_expert' => 'predictions#add_expert'
      end

      resources :claims do
        resources :claim_comments
        resources :claim_experts
        resources :claim_categories
        resources :claim_evidences
        resources :claim_votes
        resources :claim_flags
      end

      post 'claims/:claim_id/add_comment' => 'claims#add_comment'
      post 'claims/:claim_id/add_expert' => 'claims#add_expert'
      
      resources :categories

      get 'categories/:category_id/all' => 'categories#show_all'
      get 'categories/:category_id/predictions' => 'categories#show_predictions'
      get 'categories/:category_id/claims' => 'categories#show_claims'
      get 'categories/:category_id/experts' => 'categories#show_experts'

      resources :experts do
        resources :expert_categories
        resources :expert_claims
        resources :expert_comments
        resources :expert_flags
      end

      post 'experts/:expert_id/add_publication' => 'experts#add_publication'
      post 'experts/:expert_id/add_comment' => 'experts#add_comment'
      post 'experts/:expert_id/add_claim' => 'experts#add_claim'
      post 'experts/:expert_id/add_prediction' => 'experts#add_prediction'

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

      get 'leaderboard/claims' => 'leaderboard#claims'
      get 'leaderboard/claims/:status' => 'leaderboard#claims'
      
      get 'leaderboard/predictions' => 'leaderboard#predictions'
      get 'leaderboard/predictions/:status' => 'leaderboard#predictions'

      get 'leaderboard/experts' => 'leaderboard#experts'

      post 'search' => 'search#index'
      
    end
  end
end
