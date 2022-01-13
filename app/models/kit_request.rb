class KitRequest < ApplicationRecord
  encrypts :first_name, :last_name, :email, :mailing_address_1, :mailing_address_2, :smarty_response

  validates_presence_of :first_name, :last_name
  validates :email, email: {message: I18n.t("activerecord.errors.messages.invalid_email")}, allow_blank: true

  validates_presence_of :email, if: -> { ENV["DISABLE_SMARTY_STREETS"] == "true" }
  validate :valid_mailing_address, unless: -> { ENV["DISABLE_SMARTY_STREETS"] == "true" }

  after_validation :store_smarty_response

  attr_accessor :mailing_address

  private

  def valid_mailing_address
    begin
      validation_results = UsStreetAddressValidator.new(self).run
    rescue UsStreetAddressValidator::ServiceIssueError => err
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

  def store_smarty_response
    self.smarty_response = @smarty_response_json
  end
end
