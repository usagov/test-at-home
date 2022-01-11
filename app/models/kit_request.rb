class KitRequest < ApplicationRecord
  encrypts :first_name, :last_name, :email, :mailing_address_1, :mailing_address_2

  validates_presence_of :first_name, :last_name

  validate :valid_mailing_address

  attr_accessor :mailing_address

  private

  def valid_mailing_address
    validation_results = UsStreetAddressValidator.new(self).run
    # No matches
    unless validation_results
      errors.add :mailing_address, :address_not_found
      return false
    end

    deliverable_results = validation_results.select { |result| UsStreetAddressValidator.deliverable?(result) }
    # A deliverable match
    if deliverable_results.any?
      self.smarty_response = deliverable_results.first.to_json
      true
    # A match that is undeliverable (eg missing apartment number)
    else
      errors.add :mailing_address, :address_incorrect
      false
    end
  end
end
