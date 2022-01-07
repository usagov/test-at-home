require "rails_helper"

RSpec.describe "KitRequests", type: :request do
  describe "GET kit_requests/new" do
    it "renders the new template" do
      get "/kit_requests/new"
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

  describe "POST /kit_requests" do
    context "when data is valid" do
      it "creates a new kit request and redirects to confirmation page" do
        kit_request_params = {
          full_name: "Test McTester",
          address: "1234 Fake St"
        }

        expect {
          post "/kit_requests", params: {kit_request: kit_request_params}
        }.to change { KitRequest.count }.by(1)

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(kit_request_confirmation_path)
      end
    end

    context "when data is invalid" do
      it "creates a new kit request and redirects to confirmation page" do
        kit_request_params = {
          full_name: "",
          address: ""
        }

        expect {
          post "/kit_requests", params: {kit_request: kit_request_params}
        }.to change { KitRequest.count }.by(0)

        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET kit_requests/confirmation" do
    it "renders a confirmation page" do
      get "/kit_requests/confirmation"
      expect(response).to have_http_status(200)
      expect(response).to render_template(:confirmation)
    end
  end
end
