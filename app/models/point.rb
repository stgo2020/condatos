require 'csv'

class Point < ActiveRecord::Base
  
  belongs_to :track

  def self.import(file)                # Se podria mejorar haciendo ingresos de 500 arreglos por INSERT
		point = Point.new                  # Creo un punto para obtener track_id, luego este punto se debe eliminar
		point.save!
		id_punto = point.id
		id = point.track_id
		id = id.to_s

		point = Point.destroy(id_punto)   
    created_at = Time.now.strftime("%Y-%m-%d")
		res = ActiveRecord::Base.connection.execute('begin')
  	
    flag      = 0                       ### Inicializo algunas variables 
    tiempo_0  = 0
    tiempo_1  = 0
    lat_i     = 0
    lon_i     = 0
    lat_f     = 0
    lon_f     = 0
    lat       = 0
    lon       = 0
    distancia = 0
    valocidad = 0

    	CSV.foreach(file.path, headers: true) do |row|

        	if flag == 0                  ### Inicio un ciclo para obtener el tiempo inicial
            tiempo_0 = row[2]           ### Obtengo el tiempo por primera vez
            lat_i    = row[0]
            lon_i    = row[1] 
            flag     = 1
          end

          sql = "INSERT INTO points (track_id, latitud, longitud, tiempo, created_at, updated_at) VALUES (" + id + "," + row[0] + "," + row[1] + ", '" + row[2] + "' , '" + created_at +"', '" + created_at + "')"   
        	res = ActiveRecord::Base.connection.execute(sql)
 
          lat       = lat_f
          lon       = lon_f
          tiempo_1  = row[2]             ### Obtengo Variables
          lat_f     = row[0]             ### Por Ultima Vez     
          lon_f     = row[1]  
          delta     = Math.sqrt((lat_f.to_f - lat.to_f)**2 + (lon.to_f - lon_f.to_f)**2)*2*3.14*6371*0.67/360
          if delta < 10
    	      distancia = delta + distancia
          end
      end
  		

      res = ActiveRecord::Base.connection.execute('commit')

      ################################# Ingreso las coordenadas del principio y fin #################   
      con = ActiveRecord::Base.connection.execute('begin')
      sql = "UPDATE tracks SET origenlat = '" + lat_i + "' WHERE id = " + id   
      con = ActiveRecord::Base.connection.execute(sql)
      res = ActiveRecord::Base.connection.execute('commit')
      con = ActiveRecord::Base.connection.execute('begin')
      sql = "UPDATE tracks SET origenlon = '" + lon_i + "' WHERE id = " + id   
      con = ActiveRecord::Base.connection.execute(sql)
      res = ActiveRecord::Base.connection.execute('commit')
      con = ActiveRecord::Base.connection.execute('begin')
      sql = "UPDATE tracks SET destinolat = '" + lat_f + "' WHERE id = " + id     
      con = ActiveRecord::Base.connection.execute(sql)
      res = ActiveRecord::Base.connection.execute('commit')
      con = ActiveRecord::Base.connection.execute('begin')
      sql = "UPDATE tracks SET destinolon = '" + lon_f + "' WHERE id = " + id    
      con = ActiveRecord::Base.connection.execute(sql)
      res = ActiveRecord::Base.connection.execute('commit')
      ######################################## Transformamos el tiempo ###############################   
      tiempo_i = tiempo_0.split(':')   
      seg_i = (tiempo_i[2].to_i)
      min_i = (tiempo_i[1].to_i)*60
      hor_i = (tiempo_i[0].to_i)*3600
      tiempo_f = tiempo_1.split(':')
      seg_f = (tiempo_f[2].to_i)
      min_f = (tiempo_f[1].to_i)*60
      hor_f = (tiempo_f[0].to_i)*3600
      tiempo_total = (seg_i + min_i + hor_i - seg_f - min_f - hor_f).abs
      con = ActiveRecord::Base.connection.execute('begin')
      sql = "UPDATE tracks SET tiempo = " + tiempo_total.to_s + " WHERE id = "  + id
      con = ActiveRecord::Base.connection.execute(sql)
      res = ActiveRecord::Base.connection.execute('commit')
      ############################################ Obtener la velocidad ###############################
      velocidad = distancia*3600/tiempo_total
      distancia = distancia.round(2)
      velocidad = velocidad.round(2)
      con = ActiveRecord::Base.connection.execute('begin')
      sql = "UPDATE tracks SET velocidad = '" + velocidad.to_s + "' WHERE id = "  + id
      con = ActiveRecord::Base.connection.execute(sql)
      res = ActiveRecord::Base.connection.execute('commit')
      con = ActiveRecord::Base.connection.execute('begin')
      sql = "UPDATE tracks SET distancia = '" + distancia.to_s + "' WHERE id = "  + id
      con = ActiveRecord::Base.connection.execute(sql)
      res = ActiveRecord::Base.connection.execute('commit')
 	end



 	def latlng
		[self.latitud,self.longitud]
 	end


end