class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :name
      t.string :email
      t.references :department, index: true
      t.string :reference, index: true
      t.string :subject, index: true

      t.timestamps
    end
  end
end
