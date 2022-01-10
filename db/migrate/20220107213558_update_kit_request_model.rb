class UpdateKitRequestModel < ActiveRecord::Migration[7.0]
  def change
    rename_column :kit_requests, :full_name, :first_name
    rename_column :kit_requests, :address, :mailing_address_1

    add_column :kit_requests, :last_name, :string, null: false
    add_column :kit_requests, :mailing_address_2, :string
    add_column :kit_requests, :city, :string
    add_column :kit_requests, :state, :string, null: false
    add_column :kit_requests, :zip_code, :string, null: false

    remove_column :kit_requests, :phone_number, :string
  end
end
