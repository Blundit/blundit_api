json.claims do 
  json.array! @most_popular_claims do |claim|
    json.(
      claim, 
      :title, 
      :alias, 
      :description,
      :status,
      :claim_votes_count,
      :vote_value, 
      :pic,
      :claim_comments_count
      ) 
    json.in_timeframe claim.in_timeframe
  end
end

json.predictions do
  json.array! @most_popular_predictions do |prediction|
    json.(
      prediction, 
      :title, 
      :alias, 
      :description,
      :status,
      :prediction_votes_count,
      :vote_value, 
      :pic,
      :prediction_comments_count
    )
    json.in_timeframe prediction.in_timeframe
  end
end

json.experts do
  json.array! @most_popular_experts do |expert|
    json.(
      expert, 
      :name,
      :alias,
      :description,
      :website,
      :avatar, 
      :expert_comments_count
    )
    json.in_timeframe expert.in_timeframe
  end
end

