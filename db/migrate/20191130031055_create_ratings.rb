class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.text :comment 
      t.integer :user_id
      t.integer :wow_id
      t.timestamps
    end
    add_index :ratings, :user_id
    add_index :ratings, :wow_id
  end
end
