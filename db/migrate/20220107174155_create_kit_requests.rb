class CreateKitRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :kit_requests do |t|
      t.string :full_name, null: false
      t.string :address, null: false
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
