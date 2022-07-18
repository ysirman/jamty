class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.belongs_to :jam
      t.belongs_to :user

      t.timestamps
    end
    add_index :entries, [:jam_id, :user_id], unique: true
  end
end
