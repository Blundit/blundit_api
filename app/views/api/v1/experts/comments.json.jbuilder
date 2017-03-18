json.array! @comments.each do |comment|
  json.content comment.content
  json.created_at comment.created_at
  json.user comment.user
end
