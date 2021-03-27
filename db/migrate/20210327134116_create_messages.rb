class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :recipient_ids, array: true, default: []
      t.integer :participant_ids, array: true, default: []
      t.string :subject
      t.text :body
      t.string :thread_id
      t.timestamps
    end
  end
end
