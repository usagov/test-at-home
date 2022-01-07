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
      it "creates a new kit request and redirects to confirmation page" do
        kit_request_params = {
          full_name: "Test McTester",
          address: "1234 Fake St"
        }

        expect {
          post "/kit_requests", params: {kit_request: kit_request_params}
        }.to change { KitRequest.count }.by(1)

        expect(response).to have_http_status(200)
        expect(response).to render_template(:confirmation)
      end
    end
  end
end
