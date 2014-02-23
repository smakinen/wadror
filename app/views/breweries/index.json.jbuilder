json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.beer_count brewery.beers.count
end
