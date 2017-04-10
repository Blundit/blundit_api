json.array! @categories.each do |category|
    json.id category.id
    json.name category.name
    json.description category.description
    json.experts category.experts.count
    json.predictions category.predictions.count
    json.claims category.claims.count
end