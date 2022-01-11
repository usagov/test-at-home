require "smartystreets_ruby_sdk/static_credentials"
require "smartystreets_ruby_sdk/client_builder"
require "smartystreets_ruby_sdk/us_street/lookup"

class UsStreetAddressValidator
  DELIVERABLE_MATCH_CODES = %w[Y S]

  def initialize(kit_request)
    auth_id = Rails.application.credentials.smarty_streets.secrets.auth_id
    auth_token = Rails.application.credentials.smarty_streets.secrets.auth_token
    credentials = SmartyStreets::StaticCredentials.new(auth_id, auth_token)

    @client = SmartyStreets::ClientBuilder.new(credentials).with_licenses(["us-core-cloud"]).
      # with_proxy('localhost', 8080, 'proxyUser', 'proxyPassword'). # Uncomment this line to try it with a proxy
      build_us_street_api_client

    @lookup = SmartyStreets::USStreet::Lookup.new
    lookup.street = kit_request.mailing_address_1
    lookup.secondary = kit_request.mailing_address_2
    lookup.city = kit_request.city
    lookup.state = kit_request.state
    lookup.zipcode = kit_request.zip_code
    lookup.candidates = 1
    lookup.match = SmartyStreets::USStreet::MatchType::STRICT # only allow USPS matches
  end

  def run
    begin
      client.send_lookup(lookup)
    rescue SmartyStreets::SmartyError => err
      puts err
      return
    end

    lookup.result
  end

  def self.deliverable?(candidate)
    return false unless candidate
    DELIVERABLE_MATCH_CODES.include?(candidate.analysis.dpv_match_code)
  end

  private

  attr_reader :client, :lookup
end
