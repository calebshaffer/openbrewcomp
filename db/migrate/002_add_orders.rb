class AddPaypals < ActiveRecord::Migration

  def self.up
  	create_table :orders, :force => true do |t|
  	  t.string :paypal_transaction_id, :references => nil
  	  t.string :paypal_payer_id, :references => nil
  	end

  	create_table :entries_orders, :id => false, :force => true do |t|
  	  t.references :entry, :order,  :null => false
  	end
  	add_index :entries_orders, [ :entry_id, :order_id ]

  end

end
