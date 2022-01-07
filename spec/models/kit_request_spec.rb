require "rails_helper"

RSpec.describe KitRequest, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:kit_request)).to be_valid
  end

  describe "validations" do
    it "requires full name" do
      expect(FactoryBot.build(:kit_request, full_name: nil)).to_not be_valid
      expect(FactoryBot.build(:kit_request, full_name: "Test McTester")).to be_valid
    end

    it "requires address" do
      expect(FactoryBot.build(:kit_request, address: nil)).to_not be_valid
      expect(FactoryBot.build(:kit_request, address: "1234 Fake St Lima, OH")).to be_valid
    end
  end
end
