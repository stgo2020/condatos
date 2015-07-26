class AddDistanciaToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :distancia, :float
  end
end
