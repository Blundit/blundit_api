json.claim do
  json.id @claim.id
  json.title @claim.title
  json.description @claim.description
  json.pic @claim.pic.url
  json.alias @claim.alias
  json.categories @claim.categories.each do |category|
    json.id category.id
    json.name category.name
  end
  json.comments_count @claim.claim_comments_count
  json.votes_count @claim.claim_votes_count
  json.vote_value @claim.vote_value
  json.status @claim.status
  json.number_of_experts @claim.experts.count
  json.user_vote @user_vote
  json.open @claim.active?
  json.bookmark @bookmark

  json.evidences @claim.evidences.order('updated_at DESC').each do |evidence|
    json.title evidence.title
    json.url evidence.url
    json.description evidence.description
    json.image evidence.image
  end
end
json.experts @claim.claim_experts.order('updated_at DESC').each do |ce|
  json.id ce.expert.id
  json.alias ce.expert.alias
  json.name ce.expert.name
  json.accuracy ce.expert.accuracy
  json.avatar ce.expert.avatar.url(:thumb)
  if ExpertClaim.where({claim_id: @claim.id, expert_id: ce.expert.id}).length > 0
    json.evidence_of_beliefs ExpertClaim.where({claim_id: @claim.id, expert_id: ce.expert.id}).first.evidence_of_beliefs.count
  else
    json.evidence_of_beliefs 0
  end

end