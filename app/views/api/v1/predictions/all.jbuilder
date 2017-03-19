json.array! @predictions.each do |prediction|
  json.id prediction.id
  json.title prediction.title
end