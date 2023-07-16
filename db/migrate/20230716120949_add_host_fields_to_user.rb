class AddHostFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_host, :integer, default: false
    add_column :users, :stripe_account_id, :string
    add_column :users, :charges_enabled, :boolean, default: false
  end
end
