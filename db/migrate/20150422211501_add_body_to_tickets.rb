class AddBodyToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :body, :text
  end
end
