require "smartystreets_ruby_sdk/static_credentials"
require "smartystreets_ruby_sdk/client_builder"
require "smartystreets_ruby_sdk/us_street/lookup"

class UsStreetAddressValidator
  DELIVERABLE_MATCH_CODES = %w[Y S]

  class ServiceIssueError < StandardError; end

  MAX_TIMEOUT = (ENV["SMARTY_STREETS_MAX_TIMEOUT"] || 1).to_i
  MAX_RETRY = (ENV["SMARTY_STREETS_MAX_RETRY"] || 2).to_i

  def initialize(kit_request)
    auth_id = Rails.application.credentials.smarty_streets.secrets.auth_id
    auth_token = Rails.application.credentials.smarty_streets.secrets.auth_token
    credentials = SmartyStreets::StaticCredentials.new(auth_id, auth_token)

    @client = SmartyStreets::ClientBuilder.new(credentials)
      .with_proxy("proxy.api.smartystreets.com", 80, nil, nil)
      .with_licenses(["us-core-custom-enterprise-cloud"])
      .with_max_timeout(MAX_TIMEOUT)
      .retry_at_most(MAX_RETRY)
      .build_us_street_api_client

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
    # Possible exceptions: https://github.com/smartystreets/smartystreets-ruby-sdk/blob/master/lib/smartystreets_ruby_sdk/exceptions.rb
    rescue Net::OpenTimeout, SmartyStreets::SmartyError => err
      NewRelic::Agent.notice_error(err)
      raise ServiceIssueError
    end

    lookup.result
  end

  def self.deliverable?(candidate)
    return false unless candidate
    DELIVERABLE_MATCH_CODES.include?(candidate.analysis.dpv_match_code)
  end

  def self.smarty_disabled?
    ENV["DISABLE_SMARTY_STREETS"] == "true"
  end

  private

  attr_reader :client, :lookup
end
