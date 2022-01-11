require "rails_helper"

RSpec.describe KitRequest, type: :model do
  before do
    fake_result = double("result", analysis: double(dpv_match_code: "Y"))
    allow(UsStreetAddressValidator).to receive(:new) { instance_double(UsStreetAddressValidator, run: [fake_result]) }
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
  end
end
