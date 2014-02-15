
class PlacesController < ApplicationController

  def index
  end

  def search
    city = params[:city]

    @places = BeermappingApi.places_in(city)

    if @places.empty?
      redirect_to places_path, :notice => "No places in #{city}"
    else
      render :index
    end
  end
end
