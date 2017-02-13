json.array! @categories.each do |category|
    json.(category, :id, :name, :description)
end