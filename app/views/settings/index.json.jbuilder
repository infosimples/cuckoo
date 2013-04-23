json.array!(@settings) do |setting|
  json.extract! setting, 
  json.url setting_url(setting, format: :json)
end