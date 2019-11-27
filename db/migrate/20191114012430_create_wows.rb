class CreateWows < ActiveRecord::Migration[5.2]
  def change
    create_table :wows do |t|
      t.text :comment
      t.string :address
      t.timestamps
    end
  end
end
