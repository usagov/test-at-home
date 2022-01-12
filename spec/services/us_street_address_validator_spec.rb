require "rails_helper"
require "smartystreets_ruby_sdk/us_street/client"

RSpec.describe UsStreetAddressValidator, type: :model do
  describe "error handling" do
    context "when request times out" do
      it "raises a custom error" do
        stub_request(:get, /api.smartystreets.com/).to_timeout

        kit_request = FactoryBot.build(:kit_request)

        expect {
          UsStreetAddressValidator.new(kit_request).run
        }.to raise_error(UsStreetAddressValidator::ServiceIssueError)
      end
    end

    context "when smarty raises an error" do
      it "raises a custom error" do
        allow_any_instance_of(SmartyStreets::USStreet::Client).to receive(:send_lookup).and_raise(SmartyStreets::SmartyError)

        kit_request = FactoryBot.build(:kit_request)

        expect {
          UsStreetAddressValidator.new(kit_request).run
        }.to raise_error(UsStreetAddressValidator::ServiceIssueError)
      end
    end
  end
end
