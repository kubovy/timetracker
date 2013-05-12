json.array!(@tasks) do |task|
  json.extract! task, :name, :description
  json.url task_url(task, format: :json)
end