class KitRequest < ApplicationRecord
  encrypts :first_name, :last_name, :email, :mailing_address_1

  validates_presence_of :first_name, :last_name, :mailing_address_1, :state, :zip_code
end
