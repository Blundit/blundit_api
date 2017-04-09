json.most_recent_active_predictions @most_recent_active_predictions.each do |prediction|
  json.id prediction.id
  json.title prediction.title
  json.created_at prediction.created_at
  json.alias prediction.alias
  json.description prediction.description
  json.comments_count prediction.comments_count
  json.votes_count prediction.votes_count

  json.categories prediction.categories.each do |category|
    json.id category.id
    json.name category.name
  end

  json.number_of_experts prediction.experts.count
  json.recent_experts prediction.prediction_experts.order('updated_at DESC').limit(3).each do |pe|
    json.name pe.expert.name
    json.alias pe.expert.alias
    json.avatar pe.expert.avatar
  end

  json.vote_value prediction.vote_value
  json.status prediction.status
end

json.most_recent_settled_predictions @most_recent_settled_predictions.each do |prediction|
  json.id prediction.id
  json.title prediction.title
  json.created_at prediction.created_at
  json.alias prediction.alias
  json.description prediction.description
  json.comments_count prediction.comments_count
  json.votes_count prediction.votes_count

  json.categories prediction.categories.each do |category|
    json.id category.id
    json.name category.name
  end

  json.number_of_experts prediction.experts.count
  json.recent_experts prediction.prediction_experts.order('updated_at DESC').limit(3).each do |pe|
    json.name pe.expert.name
    json.alias pe.expert.alias
    json.avatar pe.expert.avatar
  end

  json.vote_value prediction.vote_value
  json.status prediction.status
end

json.most_recent_active_claims @most_recent_active_claims.each do |claim|
  json.id claim.id
  json.alias claim.alias
  json.description claim.description
  json.created_at claim.created_at
  json.title claim.title
  json.comments_count claim.comments_count
  json.votes_count = claim.votes_count

  json.categories claim.categories.each do |category|
    json.id category.id
    json.name category.name
  end

  json.number_of_experts claim.experts.count
  json.recent_experts claim.claim_experts.order('updated_at DESC').limit(3).each do |ce|
    json.name ce.expert.name
    json.alias ce.expert.alias
    json.avatar ce.expert.avatar
  end

  json.vote_value claim.vote_value
  json.status claim.status
end

json.most_recent_settled_claims @most_recent_settled_claims.each do |claim|
  json.id claim.id
  json.alias claim.alias
  json.description claim.description
  json.created_at claim.created_at
  json.title claim.title
  json.comments_count claim.comments_count
  json.votes_count = claim.votes_count

  json.categories claim.categories.each do |category|
    json.id category.id
    json.name category.name
  end

  json.number_of_experts claim.experts.count
  json.recent_experts claim.claim_experts.order('updated_at DESC').limit(3).each do |ce|
    json.name ce.expert.name
    json.alias ce.expert.alias
    json.avatar ce.expert.avatar
  end

  json.vote_value claim.vote_value
  json.status claim.status
end

json.random_expert do
  json.id @random_expert.id
  json.name @random_expert.name
  json.description @random_expert.description
  json.avatar @random_expert.avatar
  json.alias @random_expert.alias
  json.categories @random_expert.categories.each do |category|
    json.id category.id
    json.name category.name
  end
  json.comments_count @random_expert.comments.count
  json.accuracy @random_expert.accuracy
  json.number_of_predictions @random_expert.predictions.count
  json.number_of_claims @random_expert.claims.count
  json.most_recent_claim @random_expert.expert_claims.order('updated_at DESC').limit(1).each do |ec|
    json.alias ec.claim.alias
    json.title ec.claim.title
    json.vote_value ec.claim.vote_value
  end
  json.most_recent_prediction @random_expert.expert_predictions.order('updated_at DESC').limit(1).each do |ep|
    json.alias ep.prediction.alias
    json.title ep.prediction.title
    json.vote_value ep.prediction.vote_value
  end
end

json.random_claim do
  json.id @random_claim.id
  json.alias @random_claim.alias
  json.description @random_claim.description
  json.created_at @random_claim.created_at
  json.title @random_claim.title
  json.comments_count @random_claim.comments_count
  json.votes_count = @random_claim.votes_count

  json.categories @random_claim.categories.each do |category|
    json.id category.id
    json.name category.name
  end

  json.number_of_experts @random_claim.experts.count
  json.recent_experts @random_claim.claim_experts.order('updated_at DESC').limit(3).each do |ce|
    json.name ce.expert.name
    json.alias ce.expert.alias
    json.avatar ce.expert.avatar
  end

  json.vote_value @random_claim.vote_value
  json.status @random_claim.status
end

json.random_prediction do
  json.id @random_prediction.id
  json.title @random_prediction.title
  json.created_at @random_prediction.created_at
  json.alias @random_prediction.alias
  json.description @random_prediction.description
  json.comments_count @random_prediction.comments_count
  json.votes_count @random_prediction.votes_count

  json.categories @random_prediction.categories.each do |category|
    json.id category.id
    json.name category.name
  end

  json.number_of_experts @random_prediction.experts.count
  json.recent_experts @random_prediction.prediction_experts.order('updated_at DESC').limit(3).each do |pe|
    json.name pe.expert.name
    json.alias pe.expert.alias
    json.avatar pe.expert.avatar
  end

  json.vote_value @random_prediction.vote_value
  json.status @random_prediction.status
end

json.most_accurate_experts @most_accurate_experts.each do |expert|
  json.id expert.id
  json.name expert.name
  json.description expert.description
  json.avatar expert.avatar
  json.alias expert.alias
  json.categories expert.categories.each do |category|
    json.id category.id
    json.name category.name
  end
  json.comments_count expert.comments.count
  json.accuracy expert.accuracy
  json.number_of_predictions expert.predictions.count
  json.number_of_claims expert.claims.count
  json.most_recent_claim expert.expert_claims.order('updated_at DESC').limit(1).each do |ec|
    json.alias ec.claim.alias
    json.title ec.claim.title
    json.vote_value ec.claim.vote_value
  end
  json.most_recent_prediction expert.expert_predictions.order('updated_at DESC').limit(1).each do |ep|
    json.alias ep.prediction.alias
    json.title ep.prediction.title
    json.vote_value ep.prediction.vote_value
  end
end

json.least_accurate_experts @least_accurate_experts.each do |expert|
  json.id expert.id
  json.name expert.name
  json.description expert.description
  json.avatar expert.avatar
  json.alias expert.alias
  json.categories expert.categories.each do |category|
    json.id category.id
    json.name category.name
  end
  json.comments_count expert.comments.count
  json.accuracy expert.accuracy
  json.number_of_predictions expert.predictions.count
  json.number_of_claims expert.claims.count
  json.most_recent_claim expert.expert_claims.order('updated_at DESC').limit(1).each do |ec|
    json.alias ec.claim.alias
    json.title ec.claim.title
    json.vote_value ec.claim.vote_value
  end
  json.most_recent_prediction expert.expert_predictions.order('updated_at DESC').limit(1).each do |ep|
    json.alias ep.prediction.alias
    json.title ep.prediction.title
    json.vote_value ep.prediction.vote_value
  end
end

json.most_popular_experts @most_popular_experts.each do |expert|
  json.id expert.id
  json.name expert.name
  json.description expert.description
  json.avatar expert.avatar
  json.alias expert.alias
  json.categories expert.categories.each do |category|
    json.id category.id
    json.name category.name
  end
  json.comments_count expert.comments.count
  json.accuracy expert.accuracy
  json.number_of_predictions expert.predictions.count
  json.number_of_claims expert.claims.count
  json.most_recent_claim expert.expert_claims.order('updated_at DESC').limit(1).each do |ec|
    json.alias ec.claim.alias
    json.title ec.claim.title
    json.vote_value ec.claim.vote_value
  end
  json.most_recent_prediction expert.expert_predictions.order('updated_at DESC').limit(1).each do |ep|
    json.alias ep.prediction.alias
    json.title ep.prediction.title
    json.vote_value ep.prediction.vote_value
  end
end

json.most_popular_predictions @most_popular_predictions.each do |prediction|
  json.id prediction.id
  json.title prediction.title
  json.created_at prediction.created_at
  json.alias prediction.alias
  json.description prediction.description
  json.comments_count prediction.comments_count
  json.votes_count prediction.votes_count

  json.categories prediction.categories.each do |category|
    json.id category.id
    json.name category.name
  end

  json.number_of_experts prediction.experts.count
  json.recent_experts prediction.prediction_experts.order('updated_at DESC').limit(3).each do |pe|
    json.name pe.expert.name
    json.alias pe.expert.alias
    json.avatar pe.expert.avatar
  end

  json.vote_value prediction.vote_value
  json.status prediction.status
end

json.most_popular_claims @most_popular_claims.each do |claim|
  json.id claim.id
  json.alias claim.alias
  json.description claim.description
  json.created_at claim.created_at
  json.title claim.title
  json.comments_count claim.comments_count
  json.votes_count = claim.votes_count

  json.categories claim.categories.each do |category|
    json.id category.id
    json.name category.name
  end

  json.number_of_experts claim.experts.count
  json.recent_experts claim.claim_experts.order('updated_at DESC').limit(3).each do |ce|
    json.name ce.expert.name
    json.alias ce.expert.alias
    json.avatar ce.expert.avatar
  end

  json.vote_value claim.vote_value
  json.status claim.status
end