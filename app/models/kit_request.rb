class KitRequest < ApplicationRecord
  encrypts :first_name, :last_name, :email, :mailing_address_1, :mailing_address_2, :smarty_response

  validates_presence_of :first_name, :last_name
  validates :email,
    email: {message: I18n.t("activerecord.errors.messages.email_invalid")},
    length: {maximum: 50, message: I18n.t("activerecord.errors.messages.email_too_long", count: 50)},
    allow_blank: true

  # Ordering is important here, since we need first validation to run before others
  validates_presence_of :mailing_address_1, :city, :state, :zip_code
  validate :valid_mailing_address, if: :require_smarty_validation?
  validates_presence_of :email, if: -> { UsStreetAddressValidator.smarty_disabled? }
  validate :recaptcha_provided, if: -> { ENV["RECAPTCHA_REQUIRED"] == "true" }

  after_validation :store_smarty_response

  attr_accessor :mailing_address, :js_smarty_status, :recaptcha_token

  private

  def require_smarty_validation?
    js_smarty_status != "pass" && !UsStreetAddressValidator.smarty_disabled? && errors.empty?
  end

  def valid_mailing_address
    begin
      validation_results = UsStreetAddressValidator.new(self).run
    rescue UsStreetAddressValidator::ServiceIssueError
      return true
    end

    # No matches
    unless validation_results
      errors.add :mailing_address, :address_not_found
      return false
    end

    deliverable_results = validation_results.select { |result| UsStreetAddressValidator.deliverable?(result) }
    # A deliverable match
    if deliverable_results.any?
      @smarty_response_json = deliverable_results.first.to_json
      self.address_validated = true
      true
    # A match that is undeliverable (eg missing apartment number)
    else
      errors.add :mailing_address, :address_incorrect
      false
    end
  end

  def recaptcha_provided
    return true unless ENV["RECAPTCHA_REQUIRED"] == "true"
    unless recaptcha_token&.present?
      errors.add :recaptcha_token, :recaptcha_not_valid
      return false
    end

    # https://cloud.google.com/recaptcha-enterprise/docs/create-assessment#rest-api
    uri = URI.parse("https://recaptchaenterprise.googleapis.com/v1beta1/projects/#{ENV["RECAPTCHA_PROJECT_ID"]}/assessments?key=#{Rails.application.credentials.recaptcha.api_key}")
    request_data = {
      event: {
        token: recaptcha_token,
        siteKey: ENV["RECAPTCHA_SITE_KEY"],
        expectedAction: "submit"
      }
    }

    begin
      response = Net::HTTP.post(uri, request_data.to_json, "Content-Type" => "application/json; charset=utf-8")
      ::NewRelic::Agent.record_metric("Custom/Recaptcha/success", 1)
      json = JSON.parse(response.body)
    rescue Net::OpenTimeout, JSON::ParserError => err
      ::NewRelic::Agent.record_metric("Custom/Recaptcha/success", 0)
      NewRelic::Agent.notice_error(err)
      return true
    end

    if json["tokenProperties"]["valid"] == true && json["tokenProperties"]["action"] == "submit"
      self.recaptcha_score = json["score"]
      true
    else
      errors.add :recaptcha_token, :recaptcha_not_valid
      false
    end
  end

  def store_smarty_response
    self.smarty_response = @smarty_response_json
  end
end
