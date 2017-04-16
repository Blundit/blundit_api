json.array! @evidences.each do |evidence|
  json.url evidence.url
  json.title evidence.title
  json.description evidence.description
  json.pic evidence.pic.url(:medium)
end