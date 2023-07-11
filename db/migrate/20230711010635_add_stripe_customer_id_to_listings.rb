class AddStripeCustomerIdToListings < ActiveRecord::Migration[7.0]
  def change
    add_column :listings, :stripe_listing_id, :string
  end
end
