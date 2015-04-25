json.array!(@avito_accounts) do |avito_account|
  json.extract! avito_account, :id, :login, :pass, :status, :user_id, :f
  json.url avito_account_url(avito_account, format: :json)
end
