class AddCatnumCodeToEntries < ActiveRecord::Migration

  def self.up
  	add_column :entries, :catnum_code, :string, :limit => 8
  end

end