Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
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

      post 'predictions/:prediction_id/add_comment' => 'predictions#add_comment'
      post 'predictions/:prediction_id/remove_comment' => 'predictions#remove_comment'
      post 'predictions/:prediction_id/add_expert' => 'predictions#add_expert'
      post 'predictions/:prediction_id/remove_expert' => 'predictions#remove_expert'
      post 'predictions/:prediction_id/add_tag' => 'predictions#add_tag'
      post 'predictions/:prediction_id/remove_tag' => 'predictions#remove_tag'
      post 'predictions/:prediction_id/add_category' => 'predictions#add_category'
      post 'predictions/:prediction_id/remove_category' => 'predictions#remove_category'


      resources :claims do
        resources :claim_comments
        resources :claim_experts
        resources :claim_categories
        resources :claim_evidences
        resources :claim_votes
        resources :claim_flags
      end

      post 'claims/:claim_id/add_comment' => 'claims#add_comment'
      post 'claims/:claim_id/remove_comment' => 'claims#remove_comment'
      post 'claims/:claim_id/add_expert' => 'claims#add_expert'
      post 'claims/:claim_id/remove_expert' => 'claims#remove_expert'
      post 'claims/:claim_id/add_tag' => 'claims#add_tag'
      post 'claims/:claim_id/remove_tag' => 'claims#remove_tag'
      post 'claims/:claim_id/add_category' => 'claims#add_category'
      post 'claims/:claim_id/remove_category' => 'claims#remove_category'
      

      
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
      post 'experts/:expert_id/remove_publication' => 'experts#remove_publication'

      post 'experts/:expert_id/add_comment' => 'experts#add_comment'
      post 'experts/:expert_id/remove_comment' => 'experts#remove_comment'
      post 'experts/:expert_id/add_claim' => 'experts#add_claim'
      post 'experts/:expert_id/remove_claim' => 'experts#remove_claim'
      post 'experts/:expert_id/add_prediction' => 'experts#add_prediction'
      post 'experts/:expert_id/remove_prediction' => 'experts#remove_prediction'
      post 'experts/:expert_id/add_tag' => 'experts#add_tag'
      post 'experts/:expert_id/remove_tag' => 'experts#remove_tag'
      post 'experts/:expert_id/add_category' => 'experts#add_category'
      post 'experts/:expert_id/remove_category' => 'experts#remove_category'

      get 'expertly' => 'experts#sidekiq'

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

      post 'leaderboard/claims' => 'leaderboard#claims'
      post 'leaderboard/claims/newest' => 'leaderboard#newest_claims'
      post 'leaderboard/claims/recently_updated' => 'leaderboard#recently_updated_claims'
      post 'leaderboard/claims/category' => 'leaderboard#claims_by_category'
      
      post 'leaderboard/predictions' => 'leaderboard#predictions'
      post 'leaderboard/predictions/newest' => 'leaderboard#newest_predictions'
      post 'leaderboard/predictions/recently_updated' => 'leaderboard#recently_updated_predictions'
      post 'leaderboard/predictions/category' => 'leaderboard#predictions_by_category'

      post 'leaderboard/experts' => 'leaderboard#experts'
      post 'leaderboard/experts/newest' => 'leaderboard#newest_experts'
      post 'leaderboard/experts/recently_updated' => 'leaderboard#recently_updated_experts'
      post 'leaderboard/experts/category' => 'leaderboard#experts_by_category'


      post 'search' => 'search#index'
      get 'search/tags' => 'search#most_used_tags'
       
    end
  end
end
