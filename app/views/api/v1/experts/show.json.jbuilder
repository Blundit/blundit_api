json.expert do
  json.id @expert.id
  json.name @expert.name
  json.description @expert.description
  json.avatar @expert.avatar.url(:medium)
  json.alias @expert.alias
  json.occupation @expert.occupation
  json.website @expert.website
  json.city @expert.city
  json.country @expert.country
  json.twitter @expert.twitter
  json.facebook @expert.facebook
  json.instagram @expert.instagram
  json.youtube @expert.youtube
  json.wikipedia @expert.wikipedia
  json.categories @expert.categories.each do |category|
    json.id category.id
    json.name category.name
  end
  json.comments_count @expert.comments.count
  json.accuracy @expert.accuracy
  json.number_of_predictions @expert.predictions.count
  json.number_of_claims @expert.claims.count
  json.bookmark @bookmark

  json.category_accuracies @expert.expert_category_accuracies.each do |eca|
    json.category_id eca.category.id
    json.category_name eca.category.name
    json.claim_accuracy eca.claim_accuracy
    json.correct_claims eca.correct_claims
    json.incorrect_claims eca.incorrect_claims
    json.unknown_claims eca.unknown_claims
    json.unknowable_claims eca.unknowable_claims
    json.prediction_accuracy eca.prediction_accuracy
    json.correct_predictions eca.correct_predictions
    json.incorrect_predictions eca.incorrect_predictions
    json.unknown_predictions eca.unknown_predictions
    json.unknowable_predictions eca.unknowable_predictions
  end
  json.bona_fides @expert.bona_fides
end
json.claims @expert.expert_claims.order('updated_at DESC').each do |ec|
  json.id ec.claim.id
  json.alias ec.claim.alias
  json.title ec.claim.title
  json.vote_value ec.claim.vote_value
  json.evidence_of_beliefs ec.evidence_of_beliefs.count
end
json.predictions @expert.expert_predictions.order('updated_at DESC').each do |ep|
  json.id ep.prediction.id
  json.alias ep.prediction.alias
  json.title ep.prediction.title
  json.vote_value ep.prediction.vote_value
  json.evidence_of_beliefs ep.evidence_of_beliefs.count
end