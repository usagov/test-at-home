class AddAddressValidatedFlag < ActiveRecord::Migration[7.0]
  def change
    add_column :kit_requests, :address_validated, :boolean, default: false
  end
end
