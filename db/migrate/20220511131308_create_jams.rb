class CreateJams < ActiveRecord::Migration[7.0]
  def change
    create_table :jams do |t|
      t.references :user
      t.datetime :scheduled_for
      t.integer :prefecture_id, null: false
      t.string :place
      t.text :description
      t.datetime :canceled_at

      t.timestamps
    end
  end
end
