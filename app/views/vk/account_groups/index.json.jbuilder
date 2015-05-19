json.array!(@vk_account_groups) do |vk_account_group|
  json.extract! vk_account_group, :id, :name, :cross, :cross_ids, :find_id, :user_id, :actove
  json.url vk_account_group_url(vk_account_group, format: :json)
end
