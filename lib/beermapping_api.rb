class BeermappingApi

  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 60.seconds) {fetch_places_in(city)}
  end

  def self.place(id)
    Rails.cache.fetch(id, expires_in: 60.seconds) {fetch_place(id)}
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}"

    encoded_city = ERB::Util.url_encode(city)
    response = HTTParty.get("#{url}/#{encoded_city}")
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places = places.inject([]) do |set, place|
      set << Place.new(place)
    end
  end

  def self.fetch_place(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/#{id}"

    response = HTTParty.get(url)
    place = response.parsed_response["bmp_locations"]["location"]
    Place.new(place)
  end

  def self.key
   Settings.beermapping_apikey
  end
end