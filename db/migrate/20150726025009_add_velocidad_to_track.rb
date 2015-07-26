class AddVelocidadToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :velocidad, :float
  end
end
