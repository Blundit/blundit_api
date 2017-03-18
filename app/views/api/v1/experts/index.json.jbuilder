json.experts @experts.each do |expert|
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
json.page @current_page
json.per_page @per_page
json.number_of_pages @experts.total_pages