json.array!(@images) do |image|
  json.extract! image, :id, :name, :hash, :class, :user_id
  json.url image_url(image, format: :json)
end
