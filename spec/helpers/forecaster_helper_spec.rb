require 'rails_helper'

RSpec.describe ForecasterHelper, type: :helper do

  describe "#display_degrees" do
    let(:degree_value) { 55 }
    subject { display_degrees(degree_value) }

    it "displays value with degree symbol" do
      expect(subject).to eq("55&deg;")
    end

    context "when a bad value is passed in" do
      let(:degree_value) { "asdasdsa" }

      it "fails as expected" do
        expect {subject}.to raise_error(TypeError)
      end
    end
  end
end
