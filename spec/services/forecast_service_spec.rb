require "rails_helper"

RSpec.describe ForecastService, type: :service do
  let(:service) { ForecastService.new }
  let(:lon) { "2.32" }
  let(:lat) { "48.8589" }
  let(:stub_body_response) { "{\"coord\":{\"lon\":2.32,\"lat\":48.8589},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"clear sky\",\"icon\":\"01n\"}],\"base\":\"stations\",\"main\":{\"temp\":54.54,\"feels_like\":53.73,\"temp_min\":52.05,\"temp_max\":56.16,\"pressure\":1000,\"humidity\":86},\"visibility\":10000,\"wind\":{\"speed\":11.5,\"deg\":190},\"clouds\":{\"all\":0},\"dt\":1698611822,\"sys\":{\"type\":2,\"id\":2012208,\"country\":\"FR\",\"sunrise\":1698561120,\"sunset\":1698597403},\"timezone\":3600,\"id\":6545270,\"name\":\"Palais-Royal\",\"cod\":200}" }
  let(:stub_forecast_response_h) { JSON.parse(stub_body_response) }
  let(:sanitized_response) {{
    time_utc: "2023-10-29 20:37:02",
    temp: 54.54,
    feels_like: 53.73,
    min: 52.05,
    max: 56.16,
    weather: "clear sky",
    icon: "01n",
    location_name: "Palais-Royal",
  }}

  describe "#get_forecast" do
    subject { service.get_forecast(lat, lon) }

    context "happy path" do
      before(:each) do
        response = double
        allow(response).to receive(:code).and_return(200)
        allow(response).to receive(:body).and_return(stub_body_response)
        allow(RestClient::Request).to receive(:execute).and_return(response)
      end

      it do
        expect(subject).to eq stub_forecast_response_h
      end
    end

    context "unhappy path" do
      before(:each) do
        allow(RestClient::Request).to receive(:execute).and_raise(RestClient::ExceptionWithResponse)
      end

      it do
        expect(subject).to eq :not_found
      end
    end
  end

  describe "#forecast_format" do
    subject { service.forecast_format(stub_forecast_response_h) }

    it do
      expect(subject).to eq sanitized_response
    end
  end

  describe "#get_sanitized_forecast" do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    subject { service.get_sanitized_forecast(lat: lat, lon: lon) }

    before(:each) do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
      response = double
      allow(response).to receive(:code).and_return(200)
      allow(response).to receive(:body).and_return(stub_body_response)
      allow(RestClient::Request).to receive(:execute).and_return(response)
    end

    it do
      expect(subject).to eq([sanitized_response, false])

      # subsequent calls with same arguments should come back from cache
      expect(service.get_sanitized_forecast(lat: lat, lon: lon)).to eq([sanitized_response, true])
    end
  end
end
