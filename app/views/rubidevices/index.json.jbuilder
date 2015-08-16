json.array!(@rubidevices) do |rubidevice|
  json.extract! rubidevice, :id, :user_id, :identifier, :model, :creation, :owner
  json.url rubidevice_url(rubidevice, format: :json)
end
