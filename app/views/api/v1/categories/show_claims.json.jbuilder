json.array! @claims.each do |claim|
  json.id claim.id
  json.alias claim.alias
  json.description claim.description
  json.created_at claim.created_at
  json.title claim.title
  json.comments_count claim.comments_count
  json.votes_count claim.votes_count

  json.categories claim.categories.each do |category|
    json.id category.id
    json.name category.name
  end

  json.number_of_experts claim.experts.count
  json.recent_experts claim.claim_experts.order('updated_at DESC').limit(3).each do |ce|
    json.id ce.expert.id
    json.name ce.expert.name
    json.alias ce.expert.alias
    json.avatar ce.expert.avatar.url(:thumb)
  end

  json.vote_value claim.vote_value
  json.status claim.status == 0 ? "false" : "true"
end