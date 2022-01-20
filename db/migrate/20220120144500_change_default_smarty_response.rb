class ChangeDefaultSmartyResponse < ActiveRecord::Migration[7.0]
  def up
    change_column :kit_requests, :smarty_response, :json, default: nil
  end

  def down
    change_column :kit_requests, :smarty_response, :json, default: {}
  end
end
