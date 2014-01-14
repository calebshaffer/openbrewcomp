class AddOrders < ActiveRecord::Migration

  def self.up
  	create_table :orders, :force => true do |t|
  	  t.string :paypal_transaction_id, :references => nil
  	  t.string :paypal_payer_id, :references => nil
      t.string :paypal_express_checkout_token
      t.boolean :is_paid, :null => false, :default => false
      t.references :entrant, :user
  	end
    add_index :orders, [ :paypal_transaction_id ]
    add_index :orders, [ :paypal_payer_id ]
    add_index :orders, [ :paypal_express_checkout_token ]

  	create_table :entries_orders, :id => false, :force => true do |t|
  	  t.references :entry, :order,  :null => false
  	end
  	add_index :entries_orders, [ :entry_id, :order_id ]

  end

end
