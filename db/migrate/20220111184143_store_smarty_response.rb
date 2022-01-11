class StoreSmartyResponse < ActiveRecord::Migration[7.0]
  def change
    add_column :kit_requests, :smarty_response, :json, default: []
  end
end
