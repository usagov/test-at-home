require "rails_helper"

RSpec.describe "KitRequests", type: :request do
  describe "GET /" do
    it "renders the new template" do
      get "/"
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

  describe "POST /kit_requests" do
    context "when data is valid" do
      let(:valid_params) do
        {
          first_name: "Test",
          last_name: "McTester",
          email: "foo@example.com",
          mailing_address_1: "1234 Fake St",
          mailing_address_2: "Apt A",
          city: "SF",
          state: "CA",
          zip_code: "12345",
        }
      end

      it "renders the confirmation page" do
        post "/kit_requests", params: {kit_request: valid_params}

        expect(response).to have_http_status(200)
        expect(response).to render_template(:confirmation)
      end

      it "creates a new kit request with correct attributes" do
        expect {
          post "/kit_requests", params: {kit_request: valid_params}
        }.to change { KitRequest.count }.by(1)

        record = KitRequest.last

        expect(record.first_name).to eq("Test")
        expect(record.last_name).to eq("McTester")
        expect(record.email).to eq("foo@example.com")
        expect(record.mailing_address_1).to eq("1234 Fake St")
        expect(record.mailing_address_2).to eq("Apt A")
        expect(record.city).to eq("SF")
        expect(record.state).to eq("CA")
        expect(record.zip_code).to eq("12345")
      end
    end

    context "when data is invalid" do
      it "creates a new kit request and redirects to confirmation page" do
        kit_request_params = {
          first_name: "",
        }

        expect {
          post "/kit_requests", params: {kit_request: kit_request_params}
        }.to change { KitRequest.count }.by(0)

        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /kit_requests" do
    it "renders a confirmation page" do
      get "/kit_requests"
      expect(response).to have_http_status(200)
      expect(response).to render_template(:confirmation)
    end
  end
end
