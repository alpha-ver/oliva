json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :fi, :ev, :interval, :active, :user_id
  json.url task_url(task, format: :json)
end
