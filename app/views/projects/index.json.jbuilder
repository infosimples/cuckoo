json.array!(@projects) do |project|
  json.extract! project,
  json.url project_url(project, format: :json)
end