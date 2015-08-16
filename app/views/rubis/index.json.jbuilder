json.array!(@rubis) do |rubi|
  json.extract! rubi, :id, :user_id, :serie, :nombre
  json.url rubi_url(rubi, format: :json)
end
