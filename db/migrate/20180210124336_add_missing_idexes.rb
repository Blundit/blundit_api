class AddMissingIdexes < ActiveRecord::Migration
  def change
    # add_index :bona_fides, :expert_id
    # add_index :bookmarks, :claim_id
    # add_index :bookmarks, :expert_id
    # add_index :bookmarks, :prediction_id
    # add_index :bookmarks, :user_id
    # add_index :claim_categories, :category_id
    # add_index :claim_categories, :claim_id
    # add_index :claim_comments, :claim_id
    # add_index :claim_comments, :comment_id
    # add_index :claim_evidences, :claim_id
    # add_index :claim_evidences, :evidence_id
    # add_index :claim_experts, :claim_id
    # add_index :claim_experts, :expert_id
    # add_index :claim_flags, :claim_id
    # add_index :claim_flags, :flag_id
    # add_index :claim_votes, :claim_id
    # add_index :claim_votes, :vote_id
    # add_index :comments, :user_id
    # add_index :contributions, :bona_fide_id
    # add_index :contributions, :claim_id
    # add_index :contributions, :comment_id
    # add_index :contributions, :evidence_id
    # add_index :contributions, :expert_id
    # add_index :contributions, :flag_id
    # add_index :contributions, :prediction_id
    # add_index :contributions, :user_id
    # add_index :expert_categories, :category_id
    # add_index :expert_categories, :expert_id
    # add_index :expert_category_accuracies, :category_id
    # add_index :expert_category_accuracies, :expert_id
    # add_index :expert_claims, :claim_id
    # add_index :expert_claims, :expert_id
    # add_index :expert_comments, :comment_id
    # add_index :expert_comments, :expert_id
    # add_index :expert_flags, :expert_id
    # add_index :expert_flags, :flag_id
    # add_index :expert_predictions, :expert_id
    # add_index :expert_predictions, :prediction_id
    add_index :notification_queue_items, :category_id
    add_index :notification_queue_items, :claim_id
    add_index :notification_queue_items, :comment_id
    add_index :notification_queue_items, :expert_id
    add_index :notification_queue_items, :prediction_id
    add_index :prediction_categories, :category_id
    add_index :prediction_categories, :prediction_id
    add_index :prediction_comments, :comment_id
    add_index :prediction_comments, :prediction_id
    add_index :prediction_evidences, :evidence_id
    add_index :prediction_evidences, :prediction_id
    add_index :prediction_experts, :expert_id
    add_index :prediction_experts, :prediction_id
    add_index :prediction_flags, :flag_id
    add_index :prediction_flags, :prediction_id
    add_index :prediction_votes, :prediction_id
    add_index :prediction_votes, :vote_id
    # add_index :taggings, [:acts_as_taggable_on/tag_id, :claim_id]
    # add_index :taggings, [:acts_as_taggable_on/tag_id, :expert_id]
    # add_index :taggings, [:acts_as_taggable_on/tag_id, :prediction_id]
    add_index :user_claims, :claim_id
    add_index :user_claims, :user_id
    add_index :user_comments, :comment_id
    add_index :user_comments, :user_id
    add_index :user_contributions, :contribution_id
    add_index :user_contributions, :user_id
    add_index :user_experts, :expert_id
    add_index :user_experts, :user_id
    add_index :user_flags, :flag_id
    add_index :user_flags, :user_id
    add_index :user_predictions, :prediction_id
    add_index :user_predictions, :user_id
    add_index :user_votes, :user_id
    add_index :user_votes, :vote_id
    add_index :votes, :user_id
  end
end