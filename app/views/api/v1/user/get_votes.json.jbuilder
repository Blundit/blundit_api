json.predictions @prediction_votes.each do |item|
  json.created_at item.created_at
  json.prediction_id item.prediction_id
  json.vote do
    json.vote item.vote.vote
    json.user_id item.vote.user_id
  end
end

json.claims @claim_votes.each do |item|
  json.created_at item.created_at
  json.claim_id item.claim_id
  json.vote do
    json.vote item.vote.vote
    json.user_id item.vote.user_id
  end
end