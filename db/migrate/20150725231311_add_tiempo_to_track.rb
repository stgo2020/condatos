class AddTiempoToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :tiempo, :datetime
  end
end
