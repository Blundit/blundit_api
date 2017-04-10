json.array! @predictions.each do |prediction|
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