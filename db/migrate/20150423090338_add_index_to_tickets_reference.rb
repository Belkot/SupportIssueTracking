class AddIndexToTicketsReference < ActiveRecord::Migration
  def change
    add_index :tickets, :reference, unique: true
  end
end
