class AddPictureToWows < ActiveRecord::Migration[5.2]
  def change
    add_column :wows, :picture, :string
  end
end
