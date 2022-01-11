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

    it "requires mailing address 1" do
      expect(FactoryBot.build(:kit_request, mailing_address_1: nil)).to_not be_valid
      expect(FactoryBot.build(:kit_request, mailing_address_1: "1234 Fake St")).to be_valid
    end

    it "requires zip code" do
      expect(FactoryBot.build(:kit_request, zip_code: nil)).to_not be_valid
      expect(FactoryBot.build(:kit_request, zip_code: "12345")).to be_valid
    end

    it "requires state" do
      expect(FactoryBot.build(:kit_request, state: nil)).to_not be_valid
      expect(FactoryBot.build(:kit_request, state: "OH")).to be_valid
    end

    describe "address validation" do
      context "no matches returned" do
        it "is invalid and assigns an error to mailing adddress" do
          allow(UsStreetAddressValidator).to receive(:new) { instance_double(UsStreetAddressValidator, run: nil) }

          kr = FactoryBot.build(:kit_request)
          expect(kr).to_not be_valid
          expect(kr.errors[:mailing_address].count).to eq(1)
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
    end
  end
end
