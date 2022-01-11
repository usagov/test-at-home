class KitRequest < ApplicationRecord
  encrypts :first_name, :last_name, :email, :mailing_address_1, :mailing_address_2

  validates_presence_of :first_name, :last_name, :mailing_address_1, :state, :zip_code

  validate :valid_mailing_address

  attr_accessor :mailing_address

  private

  def valid_mailing_address
    validation_results = UsStreetAddressValidator.new(self).run
    deliverable_results = validation_results.select do |result|
      UsStreetAddressValidator::DELIVERABLE_MATCH_CODES.include?(result.analysis.dpv_match_code)
    end

    # A deliverable match
    if validation_results.any? && deliverable_results.any?
      true
    # No matches
    elsif validation_results.none?
      errors.add :mailing_address, :address_not_found
      false
    # A match that is undeliverable (eg missing apartment number)
    else
      errors.add :mailing_address, :address_more_info
      false
    end
  end
end
