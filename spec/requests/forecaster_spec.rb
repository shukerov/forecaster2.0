require 'rails_helper'

RSpec.describe "Forecasters", type: :request do
  describe "GET /index" do
    it "loads main page with no errors" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
    end
  end

  describe "GET /search_locations" do
    it "comes back with success" do
      get search_locations_path

      expect(response).to have_http_status(:ok)
      expect(response).to render_template("forecaster/_search_locations")
    end
  end
end
