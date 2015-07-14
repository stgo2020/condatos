require 'csv'

class Point < ActiveRecord::Base
  
  belongs_to :track

    def self.import(file)
  		CSV.foreach(file.path, headers: true) do |row|
  			Point.create! row.to_hash
		end
	end

	def latlng
		[self.latitud,self.longitud]
	end


end


# track.points.create(point_params)