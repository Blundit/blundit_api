json.comments @comments.each do |comment|
  json.content comment.content
  json.created_at comment.created_at
  json.user comment.user
end

json.page @page
json.per_page @per_page
json.number_of_pages @comments.total_pages