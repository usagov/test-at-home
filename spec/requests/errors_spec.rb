require "rails_helper"

RSpec.describe "Errors", type: :request do
  describe "GET /not_found" do
    it "returns http success" do
      get "/404"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /internal_server_error" do
    it "returns http success" do
      get "/500"
      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
