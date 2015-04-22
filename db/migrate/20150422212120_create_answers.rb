class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :body
      t.integer :ticket_id
      t.integer :user_id

      t.timestamps
    end
    add_index :answers, :ticket_id
    add_index :answers, :user_id
  end
end
