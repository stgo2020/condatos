json.array!(@points) do |point|
  json.extract! point, :id, :latitud, :longitud, :tiempo, :track_id
  json.url point_url(point, format: :json)
end
