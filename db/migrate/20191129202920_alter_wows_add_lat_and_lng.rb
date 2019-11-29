class AlterWowsAddLatAndLng < ActiveRecord::Migration[5.2]
  def change
    add_column :wows, :latitude, :float
    add_column :wows, :longitude, :float
  end
end
