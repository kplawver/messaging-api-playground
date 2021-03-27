class CreateMessageTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :message_tickets do |t|
      t.integer :user_id
      t.integer :message_id
      t.boolean :read, default: false
      t.datetime :created_at
    end
  end
end
