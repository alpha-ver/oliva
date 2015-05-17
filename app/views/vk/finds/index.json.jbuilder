json.array!(@vk_finds) do |vk_find|
  json.extract! vk_find, :id, :name, :p, :user_id, :count, :find_count, :step_count, :map_find, :error_code, :interval, :next_at, :find_ids, :active
  json.url vk_find_url(vk_find, format: :json)
end
