json.array!(@projects) do |project|
  json.extract! project, :name, :description, :owner_id
  json.url project_url(project, format: :json)
end