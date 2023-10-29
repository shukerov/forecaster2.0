class ForecasterController < ApplicationController
  def index
    @hello = "Hello forecasting world!!"
  end


  def search_locations
    @results = Geocoder.search(search_locations_params[:q]).reduce({}) do |r, v|
      r.update(v.display_name => v.coordinates.join(";"))
    end

    render partial: "search_locations", formats: :html
  end

  private

  def search_locations_params
    params.permit(:q)
  end
end
