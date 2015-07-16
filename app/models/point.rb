require 'csv'

class Point < ActiveRecord::Base
  
  belongs_to :track

    def self.import(file)
  		SmarterCSV.process(file.path, headers: true) do |row|
 
  			Point.create! row
 		end
 	end

 	def latlng
		[self.latitud,self.longitud]
 	end


end


# track.points.create(point_params)