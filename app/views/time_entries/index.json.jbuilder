json.array!(@time_entries) do |time_entry|
  json.extract! time_entry,
  json.url time_entry_url(time_entry, format: :json)
end