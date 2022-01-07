FactoryBot.define do
  factory :kit_request do
    first_name { "Test" }
    last_name { "McTester" }
    mailing_address_1 { "1234 Fake Street" }
    state { "OH" }
    zip_code { "12345" }
  end
end
