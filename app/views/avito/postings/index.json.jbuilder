json.array!(@avito_postings) do |avito_posting|
  json.extract! avito_posting, :id, :title, :description, :manager, :price, :images, :p, :count, :user_id, :active, :allow_mail, :next_at
  json.url avito_posting_url(avito_posting, format: :json)
end
