class KitRequest < ApplicationRecord
  encrypts :first_name, :last_name, :email, :mailing_address_1, :mailing_address_2, :smarty_response

  validates_presence_of :first_name, :last_name
  validates :email, email: {message: I18n.t("activerecord.errors.messages.invalid_email")}, allow_blank: true

  # Ordering is important here, since we need first validation to run before others
  validate :valid_mailing_address, unless: -> { UsStreetAddressValidator.smarty_disabled? }
  validates_presence_of :mailing_address_1, :city, :state, :zip_code, if: :address_validation_service_errored
  validates_presence_of :mailing_address_1, :city, :state, :zip_code, :email, if: -> { UsStreetAddressValidator.smarty_disabled? }

  after_validation :store_smarty_response

  attr_accessor :mailing_address

  private

  def valid_mailing_address
    begin
      validation_results = UsStreetAddressValidator.new(self).run
    rescue UsStreetAddressValidator::ServiceIssueError
      @address_validation_service_errored = true
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

  private

  attr_reader :address_validation_service_errored
end
