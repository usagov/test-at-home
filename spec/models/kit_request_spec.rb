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

        it "skips validation" do
          kr = FactoryBot.build(:kit_request)
          kr.valid?

          expect(kr).to be_valid
        end

        it "keeps address_validated as false" do
          kr = FactoryBot.build(:kit_request)
          kr.valid?

          expect(kr.address_validated?).to be_falsey
        end
      end

      context "when smarty streets integration disabled" do
        it "does not require address validation" do
          ClimateControl.modify DISABLE_SMARTY_STREETS: "true" do
            kit_request = FactoryBot.build(:kit_request)
            expect(kit_request).to be_valid
            expect(kit_request.save).to be_truthy
          end
        end
      end
    end
  end
end
