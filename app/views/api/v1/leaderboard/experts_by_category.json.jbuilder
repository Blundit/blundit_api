json.array! @experts.each do |expert|
    json.overall_accuracy expert.overall_accuracy
    json.claim_accuracy expert.claim_accuracy
    json.prediction_accuracy expert.prediction_accuracy
    json.expert expert.expert
end
