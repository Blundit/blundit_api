json.array! @claims.each do |claim|
  json.id claim.id
  json.title claim.title
end