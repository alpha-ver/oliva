json.array!(@parse_dbs) do |parse_db|
  json.extract! parse_db, :id, :task_id, :url, :title, :body, :img, :date, :additional
  json.url parse_db_url(parse_db, format: :json)
end
