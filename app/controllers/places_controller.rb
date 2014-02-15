
class PlacesController < ApplicationController

  def index

  end

  def search

    api_key = "dac36960ad4db5fc0008e99b86031519"
    url = "http://beermapping.com/webservice/loccity/#{api_key}"

    city = ERB::Util.url_encode(params[:city])
    response = HTTParty.get("#{url}/#{city}")

    places = response.parsed_response["bmp_locations"]["location"]
    if places.is_a?(Hash) and places['id'].nil?
      redirect_to places_path, :notice => "No places in #{city}"

    else
      places = [places] if places.is_a?(Hash)
      @places = places.inject([]) do |set, location|
        set << Place.new(location)
      end
    end

    render :index
  end

end
