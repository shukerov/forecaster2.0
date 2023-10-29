class ForecastService
  URL = "https://api.openweathermap.org/data/2.5/weather" 
  API_KEY = Rails.application.credentials.open_weather[:api_key]
  CACHE_EXPIRY_PERIOD = 30.minutes
  
  # HTTP GET - query OpenWeatherAPI for weather data
  #
  # @param lat [String] latitude coordinate
  # @param lon [String] longitude coordinate
  #
  # @return [Hash] the OpenWeather API response
  def get_forecast(lat, lon)
    request_data = {
      method: :get,
      url: URL,
      headers: {
        params: {
          lat: lat,
          lon: lon,
          units: 'imperial',
          appid: API_KEY,
        }
      }
    }

    # fetch response
    response = RestClient::Request.execute(request_data)

    return JSON.parse(response.body) if response.body.present?
  rescue RestClient::ExceptionWithResponse => err
    return :not_found 
  end

  # this function extracts the forecast response data we care about
  #
  # @param forecast_response [Hash] the repsonse from OpenWeatherAPI
  #
  # @return [Hash] formatted forecast data
  def forecast_format(forecast_response)
    forecast_data = {
      time_utc: DateTime.strptime(forecast_response["dt"].to_s, "%s").strftime("%F %T"),
      temp: forecast_response.dig("main", "temp").to_f,
      feels_like: forecast_response.dig("main", "feels_like").to_f,
      min: forecast_response.dig("main", "temp_min").to_f,
      max: forecast_response.dig("main", "temp_max").to_f,
      weather: forecast_response.dig("weather", 0, "description"),
      icon: forecast_response.dig("weather", 0, "icon"),
      location_name: forecast_response.dig("name"),
    }

    return forecast_data
  end

  # Fetches forecast info (either from cache or makes a requests),
  # and extracts the specific datapoints 
  #
  # @param lat [String] latitude coordinate
  # @param lon [String] longitude coordinate
  #
  # @return [Hash, Bool] formatted forecast data, and a boolean indicating information response is coming from the cache
  def get_sanitized_forecast(lat:, lon:)
    # lookup value in the cache
    cache_key = "#{lat}:#{lon}"
    cached = Rails.cache.exist?(cache_key)

    forecast_response = Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRY_PERIOD) do
      get_forecast(lat, lon)
    end
    
    # no weather data was found don't format just return
    return :not_found, cached  if forecast_response == :not_found

    # format forecast data and return
    forecast_formatted = forecast_format(forecast_response)
    return forecast_formatted, cached
  end
end

