class RemoveSubjectFromMessages < ActiveRecord::Migration[6.1]
  def change
    remove_column :messages, :subject
  end
end
