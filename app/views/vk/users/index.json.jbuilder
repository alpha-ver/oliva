json.array!(@vk_users) do |vk_user|
  json.extract! vk_user, :id, :first_name, :last_name, :sex, :status, :city_id, :country_id, :friend_ids, :friend_count, :private_message
  json.url vk_user_url(vk_user, format: :json)
end
