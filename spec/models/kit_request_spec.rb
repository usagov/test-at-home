require "rails_helper"
require "smartystreets_ruby_sdk/us_street/candidate"

RSpec.describe KitRequest, type: :model do
  before do
    allow(UsStreetAddressValidator).to receive(:new) { instance_double(UsStreetAddressValidator, run: [double("foo")]) }
    allow(UsStreetAddressValidator).to receive(:deliverable?) { true }
  end

  it "has a valid factory" do
    expect(FactoryBot.build(:kit_request)).to be_valid
  end

  describe "validations" do
    it "requires first_name" do
      expect(FactoryBot.build(:kit_request, first_name: nil)).to_not be_valid
      expect(FactoryBot.build(:kit_request, first_name: "Test")).to be_valid
    end

    it "requires last_name" do
      expect(FactoryBot.build(:kit_request, last_name: nil)).to_not be_valid
      expect(FactoryBot.build(:kit_request, last_name: "McTester")).to be_valid
    end

    describe "address validation" do
      context "no matches returned" do
        before do
          allow(UsStreetAddressValidator).to receive(:new) { instance_double(UsStreetAddressValidator, run: nil) }
        end

        it "is invalid and assigns an error to mailing adddress" do
          kr = FactoryBot.build(:kit_request)
          expect(kr).to_not be_valid
          expect(kr.errors[:mailing_address].count).to eq(1)
        end

        it "doesn't blow up on save, and instead returns false" do
          kr = FactoryBot.build(:kit_request)
          expect(kr.save).to eq(false)
        end
      end

      context "matches received with allowable delivery code" do
        before do
          fake_candidate = SmartyStreets::USStreet::Candidate.new({"delivery_line_1" => "1234 fake st"})
          allow(UsStreetAddressValidator).to receive(:new) { instance_double(UsStreetAddressValidator, run: [fake_candidate]) }
          allow(UsStreetAddressValidator).to receive(:deliverable?) { true }
        end

        it "is valid" do
          kr = FactoryBot.build(:kit_request)
          expect(kr).to be_valid
        end

        it "stores the resulting object as json in smarty_response" do
          kr = FactoryBot.build(:kit_request)
          kr.valid?

          expect(JSON.parse(kr.smarty_response)["delivery_line_1"]).to eq("1234 fake st")
        end

        it "sets address_validated to true" do
          kr = FactoryBot.build(:kit_request)
          kr.valid?

          expect(kr.address_validated?).to be_truthy
        end
      end

      context "matches received with unallowable delivery code" do
        it "is invalid and assigns an error" do
          allow(UsStreetAddressValidator).to receive(:new) { instance_double(UsStreetAddressValidator, run: [double("foo")]) }
          allow(UsStreetAddressValidator).to receive(:deliverable?) { false }

          kr = FactoryBot.build(:kit_request)
          expect(kr).to_not be_valid
          expect(kr.errors[:mailing_address].count).to eq(1)
        end
      end

      context "when smarty throws error" do
        before do
          allow(UsStreetAddressValidator).to receive(:new).and_raise(UsStreetAddressValidator::ServiceIssueError)
        end

        it "requires additional address fields" do
          expect(FactoryBot.build(:kit_request, :smarty_streets_disabled, mailing_address_1: "")).not_to be_valid
          expect(FactoryBot.build(:kit_request, :smarty_streets_disabled, city: "")).not_to be_valid
          expect(FactoryBot.build(:kit_request, :smarty_streets_disabled, state: "")).not_to be_valid
          expect(FactoryBot.build(:kit_request, :smarty_streets_disabled, zip_code: "")).not_to be_valid
        end

        it "can be valid with address fields supplied (doesn't require email)" do
          expect(FactoryBot.build(:kit_request, :smarty_streets_disabled, email: "")).to be_valid
        end

        it "keeps address_validated as false" do
          kr = FactoryBot.build(:kit_request)
          kr.valid?

          expect(kr.address_validated?).to be_falsey
        end
      end
    end

    context "email" do
      it "is not required" do
        expect(FactoryBot.build(:kit_request, email: "")).to be_valid
      end

      context "when provided" do
        it "validates format" do
          expect(FactoryBot.build(:kit_request, email: "asdlfj")).to_not be_valid
          expect(FactoryBot.build(:kit_request, email: "foo@example.com")).to be_valid
        end

        it "limits to less than 50 characters" do
          long_string = ""
          60.times.each { |i| long_string += "a" }

          less_long_string = ""
          38.times.each { |i| less_long_string += "b" }

          expect(FactoryBot.build(:kit_request, email: "#{long_string}@example.com")).not_to be_valid
          expect(FactoryBot.build(:kit_request, email: "#{less_long_string}@example.com")).to be_valid
        end
      end
    end

    context "when js_smarty_status is passed" do
      it "does not require address validation" do
        expect(UsStreetAddressValidator).to_not receive(:new)
        kit_request = FactoryBot.build(:kit_request, js_smarty_status: "pass")

        expect(kit_request).to be_valid
      end
    end

    context "when smarty streets integration disabled" do
      around do |example|
        ClimateControl.modify DISABLE_SMARTY_STREETS: "true" do
          example.run
        end
      end

      it "does not require address validation" do
        kit_request = FactoryBot.build(:kit_request, :smarty_streets_disabled)

        expect(kit_request).to be_valid
        expect(kit_request.save).to be_truthy
      end

      it "does require other address fields" do
        expect(FactoryBot.build(:kit_request, :smarty_streets_disabled, email: "")).to_not be_valid
        expect(FactoryBot.build(:kit_request, :smarty_streets_disabled, mailing_address_1: "")).to_not be_valid
        expect(FactoryBot.build(:kit_request, :smarty_streets_disabled, city: "")).to_not be_valid
        expect(FactoryBot.build(:kit_request, :smarty_streets_disabled, state: "")).to_not be_valid
        expect(FactoryBot.build(:kit_request, :smarty_streets_disabled, zip_code: "")).to_not be_valid
      end

      it "requires email to be valid" do
        kit_request = FactoryBot.build(:kit_request, :smarty_streets_disabled, email: "foo@elkjadf")

        expect(kit_request).to_not be_valid
      end
    end

    describe "recaptcha" do
      context "when recaptcha required" do
        around do |example|
          ClimateControl.modify RECAPTCHA_REQUIRED: "true" do
            example.run
          end
        end

        let(:recaptcha_response) do
          {
            "name" => "projects/asdfasdf/assessments/lkjasdlkfjasldfk",
            "event" =>
              {"token" =>
                "adfasdfasdfasdfasdfasdfasdfasdfsadf",
               "siteKey" => "asdfasdfasdf",
               "userAgent" => "",
               "userIpAddress" => "",
               "expectedAction" => "submit",
               "hashedAccountId" => ""},
            "score" => 0.9,
            "tokenProperties" =>
              {"valid" => true,
               "invalidReason" => "INVALID_REASON_UNSPECIFIED",
               "hostname" => "localhost",
               "action" => "submit",
               "createTime" => "2022-01-16T16:35:44.371Z"},
            "reasons" => []
          }
        end

        it "is valid" do
          stub_request(:any, /recaptchaenterprise.googleapis.com/).to_return(body: recaptcha_response.to_json)

          kr = FactoryBot.build(:kit_request, recaptcha_token: "asdfasdf")

          expect(kr).to be_valid
        end

        context "invalid states" do
          it "is invalid without token, and does not hit recaptcha API" do
            stub_request(:any, /recaptchaenterprise.googleapis.com/).to_return(body: recaptcha_response.to_json)

            kr = FactoryBot.build(:kit_request, recaptcha_token: "")

            expect(kr).to_not be_valid
            expect(WebMock).not_to have_requested(:any, /recaptchaenterprise.googleapis.com/)
          end

          it "requires recaptcha to be valid" do
            recaptcha_response["tokenProperties"]["valid"] = false
            stub_request(:any, /recaptchaenterprise.googleapis.com/).to_return(body: recaptcha_response.to_json)

            kr = FactoryBot.build(:kit_request, recaptcha_token: "asdfasdf")

            expect(kr).to_not be_valid
          end

          it "requires action to be submit" do
            recaptcha_response["tokenProperties"]["action"] = "bogus"
            stub_request(:any, /recaptchaenterprise.googleapis.com/).to_return(body: recaptcha_response.to_json)

            kr = FactoryBot.build(:kit_request, recaptcha_token: "asdfasdf")

            expect(kr).to_not be_valid
          end
        end
      end
    end
  end
end
