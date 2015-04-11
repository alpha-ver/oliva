json.array!(@admin_postings) do |admin_posting|
  json.extract! admin_posting, :id, :title, :description, :manager, :price, :images, :p, :count, :user_id, :active, :allow_mail, :next_at
  json.url admin_posting_url(admin_posting, format: :json)
end
