Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # ActiveAdmin.routes(self)

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  match '*path', via: [:options], to: lambda {|_| [204, { 'Content-Type' => 'text/plain' }]}
  
  namespace :api do
    namespace :v1 do
      get 'predictions/all' => 'predictions#all'
      get 'claims/all' => 'claims#all'
      get 'experts/all' => 'experts#all'
      
      resources :predictions do
        resources :prediction_comments
        resources :prediction_categories
        resources :prediction_experts
        resources :prediction_evidences
        resources :prediction_votes
        resources :prediction_flags
      end

      get 'predictions/:prediction_id/comments' => 'predictions#comments'
      post 'predictions/:prediction_id/add_comment' => 'predictions#add_comment'
      post 'predictions/:prediction_id/remove_comment' => 'predictions#remove_comment'
      post 'predictions/:prediction_id/add_expert' => 'predictions#add_expert'
      post 'predictions/:prediction_id/remove_expert' => 'predictions#remove_expert'
      post 'predictions/:prediction_id/add_tag' => 'predictions#add_tag'
      post 'predictions/:prediction_id/remove_tag' => 'predictions#remove_tag'
      post 'predictions/:prediction_id/add_category' => 'predictions#add_category'
      post 'predictions/:prediction_id/remove_category' => 'predictions#remove_category'
      post 'predictions/:prediction_id/vote' => 'predictions#vote'
      post 'predictions/:prediction_id/add_evidence' => 'predictions#add_evidence'
      patch 'predictions/:prediction_id/update_image' => 'predictions#update_image'
      delete 'predictions/:prediction_id/delete_image' => 'predictions#delete_image'

      resources :claims do
        resources :claim_comments
        resources :claim_experts
        resources :claim_categories
        resources :claim_evidences
        resources :claim_votes
        resources :claim_flags
      end

      get 'claims/:claim_id/comments' => 'claims#comments'
      post 'claims/:claim_id/add_comment' => 'claims#add_comment'
      post 'claims/:claim_id/remove_comment' => 'claims#remove_comment'
      post 'claims/:claim_id/add_expert' => 'claims#add_expert'
      post 'claims/:claim_id/remove_expert' => 'claims#remove_expert'
      post 'claims/:claim_id/add_tag' => 'claims#add_tag'
      post 'claims/:claim_id/remove_tag' => 'claims#remove_tag'
      post 'claims/:claim_id/add_category' => 'claims#add_category'
      post 'claims/:claim_id/remove_category' => 'claims#remove_category'
      post 'claims/:claim_id/vote' => 'claims#vote'
      post 'claims/:claim_id/add_evidence' => 'claims#add_evidence'
      patch 'claims/:claim_id/update_image' => 'claims#update_image'
      delete 'claims/:claim_id/delete_image' => 'claims#delete_image'
      
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

      post 'experts/:expert_id/add_bona_fide' => 'experts#add_bona_fide'
      post 'experts/:expert_id/remove_bona_fide' => 'experts#remove_bona_fide'

      get 'experts/:expert_id/comments' => 'experts#comments'
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
      post 'experts/:expert_id/add_substantiation' => 'experts#add_evidence_of_belief'
      post 'experts/:expert_id/get_substantiations' => 'experts#get_substantiations'
      patch 'experts/:expert_id/update_image' => 'experts#update_image'
      delete 'experts/:expert_id/delete_image' => 'experts#delete_image'


      resources :publications

      resources :users

      resource :user do
        post 'add_bookmark' => 'user#add_bookmark'
        post 'remove_bookmark/:bookmark_id' => 'user#remove_bookmark'
        post 'update_bookmark/:bookmark_id' => 'user#update_bookmark'
        get 'bookmarks' => 'user#get_bookmarks'
        get 'votes' => 'user#get_votes'
        put 'update' => 'user#update_user'
        post 'get_avatar' => 'user#get_avatar'
        get 'authenticate' => 'user#authenticate'
      end

      resource :home do
        get 'homepage' => 'home#homepage'
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
