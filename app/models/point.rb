require 'csv'

class Point < ActiveRecord::Base
  
  belongs_to :track

    def self.import(file)

    	#id = ActiveRecord::Base.connection.execute('lastval') # Esta linea es la clave
    	
		
		point = Point.new
		point.save!
		id_punto = point.id
		id = point.track_id
		id = id.to_s
		point = Point.destroy(id_punto)

    	inserts = ''
        created_at = Time.now.strftime("%Y-%m-%d")
        updated_at = Time.now.strftime("%H:%M:%S")

		res = ActiveRecord::Base.connection.execute('begin')
  		CSV.foreach(file.path, headers: true) do |row|
            inserts = '(' + id + ',' + row[0] + ',' + row[1] + ',' + '"' + row[2] + '"' + ',' + '"' + created_at + '"' + ',' + "'" + updated_at + "'" + ')'
            sql = 'INSERT INTO "points" ("track_id", "latitud", "longitud", "tiempo", "created_at", "updated_at") VALUES ' + inserts
            res = ActiveRecord::Base.connection.execute(sql)
  		end
  		res = ActiveRecord::Base.connection.execute('commit')

 	end


 	def latlng
		[self.latitud,self.longitud]
 	end


end
