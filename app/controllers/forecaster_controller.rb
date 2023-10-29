class ForecasterController < ApplicationController

  # GET /forecaster/index
  # also serves as root path of application
  def index
    coordinates = forecast_params[:coordinates]&.split(";")
    
    if coordinates.present? && coordinates.length == 2
      @forecast_data, @cached = forecast_service.get_sanitized_forecast(lat: coordinates[0], lon: coordinates[1])
    end
  end

  # GET /forecaster/search_locations
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

  def forecast_params
    params.permit(:coordinates, :location_name, :commit)
  end

  def forecast_service
    @forecast_service ||= ForecastService.new
  end
end
