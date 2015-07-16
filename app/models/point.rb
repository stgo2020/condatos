require 'csv'

class Point < ActiveRecord::Base
  
  belongs_to :track

    def self.import(file)  # Se podria mejorar haciendo ingresos de 500 arreglos por INSERT
	
		point = Point.new  # Creo un punto para obtener track_id, luego este punto se debe eliminar
		point.save!
		id_punto = point.id
		id = point.track_id
		id = id.to_s
		point = Point.destroy(id_punto)

   
        created_at = Time.now.strftime("%Y-%m-%d")
        updated_at = Time.now.strftime("%H:%M:%S")

		res = ActiveRecord::Base.connection.execute('begin')
  		CSV.foreach(file.path, headers: true) do |row|
        #inserts = '(63' + ',' + row[0] + ',' + row[1] + ',' + '"' + row[2] + '"' + ',' + '"' + created_at + '"' + ',' + "'" + updated_at + "'" + ')'
        sql = "INSERT INTO points (track_id, latitud, longitud, tiempo, created_at, updated_at) VALUES (" + id + "," + row[0] + "," + row[1] + ", '" + row[2] + "' , '" + created_at +"', '" + created_at + "')"   
        res = ActiveRecord::Base.connection.execute(sql)
    	
    	end
		#sql = "INSERT INTO points (track_id, latitud, longitud, tiempo, created_at, updated_at) VALUES (63, -33.40047,-70.6301, '2015-07-16 15:32:37.751685' , '2015-07-16 15:32:37.751685', '2015-07-16 15:32:37.751685')"
		#res = ActiveRecord::Base.connection.execute(sql)

  		res = ActiveRecord::Base.connection.execute('commit')

 	end


 	def latlng
		[self.latitud,self.longitud]
 	end


end
