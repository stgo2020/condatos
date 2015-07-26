class AddDestinolonToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :destinolon, :float
  end
end
