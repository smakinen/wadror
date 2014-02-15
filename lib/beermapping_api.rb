class BeermappingApi

  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 60.seconds) {fetch_places_in(city)}
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

  def self.key
    "dac36960ad4db5fc0008e99b86031519"
  end
end