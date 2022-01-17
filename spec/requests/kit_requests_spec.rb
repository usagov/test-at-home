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
    around do |example|
      ClimateControl.modify RECAPTCHA_REQUIRED: "true" do
        example.run
      end
    end

    let(:valid_smarty_response) do
      [
        {
          input_index: 0,
          candidate_index: 0,
          delivery_line_1: "1377 Fell St",
          last_line: "San Francisco CA 94117-2224",
          delivery_point_barcode: "941172224774",
          components: {
            primary_number: "1377",
            street_name: "Fell",
            street_suffix: "St",
            city_name: "San Francisco",
            default_city_name: "San Francisco",
            state_abbreviation: "CA",
            zipcode: "94117",
            plus4_code: "2224",
            delivery_point: "77",
            delivery_point_check_digit: "4"
          },
          metadata: {
            record_type: "S",
            zip_type: "Standard",
            county_fips: "06075",
            county_name: "San Francisco",
            carrier_route: "C024",
            congressional_district: "12",
            rdi: "Commercial",
            elot_sequence: "0002",
            elot_sort: "A",
            latitude: 37.773335,
            longitude: -122.440468,
            coordinate_license: 1,
            precision: "Rooftop",
            time_zone: "Pacific",
            utc_offset: -8,
            dst: true
          },
          analysis: {
            dpv_match_code: "Y",
            dpv_footnotes: "AABB",
            dpv_cmra: "N",
            dpv_vacant: "N",
            dpv_no_stat: "N",
            active: "Y",
            footnotes: "B#"
          }
        }
      ]
    end
    let(:valid_params) do
      {
        kit_request: {
          :first_name => "Test",
          :last_name => "McTester",
          :email => "foo@example.com",
          :mailing_address_1 => "1234 Fake St",
          :mailing_address_2 => "Apt A",
          :city => "SF",
          :state => "CA",
          :zip_code => "12345",
          "recaptcha_token" => "asdfasdfasdfasdfasdf"
        }
      }
    end

    context "when data is valid" do
      let(:smarty_response) { valid_smarty_response }

      before do
        stub_request(:get, /api.smartystreets.com/).to_return(status: 200, body: smarty_response.to_json, headers: {})
      end

      it "renders the confirmation page" do
        post "/kit_requests", params: valid_params

        expect(response).to have_http_status(200)
        expect(response).to render_template(:confirmation)
      end

      it "creates a new kit request with correct attributes" do
        expect {
          post "/kit_requests", params: valid_params
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
        expect(record.recaptcha_score).to eq(0.9)
      end
    end

    context "when data is invalid" do
      it "renders errors without creating new record" do
        invalid_params = {
          kit_request: {
            first_name: ""
          }
        }

        expect {
          post "/kit_requests", params: invalid_params
        }.to change { KitRequest.count }.by(0)

        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
      end

      it "handles null bytes" do
        stub_request(:get, /api.smartystreets.com/).to_return(status: 200, body: valid_smarty_response.to_json, headers: {})

        invalid_params = {
          kit_request: {
            :first_name => "Test\x00",
            :last_name => "McTester\x00",
            :email => "foo@example.com",
            :mailing_address_1 => "1234 Fake St\x00",
            :mailing_address_2 => "Apt A\x00",
            :city => "SF\x00",
            :state => "CA\x00",
            :zip_code => "12345\x00",
            "recaptcha_token" => "asdfasdfasdfasdfasdf\x00"
          }
        }

        expect {
          post "/kit_requests", params: invalid_params
        }.to change { KitRequest.count }.by(0)

        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
      end
    end
  end
end
