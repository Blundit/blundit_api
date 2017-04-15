json.comments @comments.each do |comment|
  json.content comment.content
  json.created_at comment.created_at
  json.user do
    json.id comment.user.id
    json.first_name comment.user.first_name
    json.last_name comment.user.last_name
    json.avatar comment.user.avatar.url
    json.email comment.user.email
  end
end

json.page @page
json.per_page @per_page
json.number_of_pages @comments.total_pages