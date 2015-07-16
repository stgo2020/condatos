require 'csv'

class Point < ActiveRecord::Base
  
  belongs_to :track

    def self.import(file)

    	#id = ActiveRecord::Base.connection.execute('lastval') # Esta linea es la clave
    	
		
#		point = Point.new
#		point.save!
#		id_punto = point.id
#		id = point.track_id
#		id = id.to_s
		#point = Point.destroy(id_punto)

   # 	inserts = ''
  #      created_at = Time.now.strftime("%Y-%m-%d")
 #       updated_at = Time.now.strftime("%H:%M:%S")

		res = ActiveRecord::Base.connection.execute('begin')
  		CSV.foreach(file.path, headers: true) do |row|
        #inserts = '(63' + ',' + row[0] + ',' + row[1] + ',' + '"' + row[2] + '"' + ',' + '"' + created_at + '"' + ',' + "'" + updated_at + "'" + ')'
        sql = 'INSERT INTO "points" ("track_id", "latitud", "longitud", "tiempo", "created_at", "updated_at") VALUES (63, -33.40047,-70.6301, $4 , "2015-07-16 15:32:37.751685", "2015-07-16 15:32:37.751685")'

        #    sql = 'INSERT INTO "points" ("track_id", "latitud", "longitud", "tiempo", "created_at", "updated_at") VALUES ' + inserts
        #    res = ActiveRecord::Base.connection.execute(sql)
    	end
 # 		sql = 'INSERT INTO "points" ("track_id", "latitud", "longitud", "tiempo", "created_at", "updated_at") VALUES  (63,33,33,"01:01:02",1,1)'
		res = ActiveRecord::Base.connection.execute(sql)

  		res = ActiveRecord::Base.connection.execute('commit')

 	end


def self.import(file)
res = ActiveRecord::Base.connection.execute('begin')
#sql = 'INSERT INTO "points" ("track_id", "latitud", "longitud", "tiempo", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"  [["track_id", 63], ["latitud", -33.40047], ["longitud", -70.6301066667], ["tiempo", "2000-01-01 12:03:23.000000"], ["created_at", "2015-07-16 15:32:37.751685"], ["updated_at", "2015-07-16 15:32:37.751685"]]'
sql = 'INSERT INTO "points" ("track_id", "latitud", "longitud", "tiempo", "created_at", "updated_at") VALUES (63, -33.40047,-70.6301, "2000-01-01 12:03:23.000000", "2015-07-16 15:32:37.751685", "2015-07-16 15:32:37.751685")'
res = ActiveRecord::Base.connection.execute(sql)
res = ActiveRecord::Base.connection.execute('commit')
end

   # def self.import(file)
  #		CSV.foreach(file.path, headers: true) do |row|
 # 			Point.create! row.to_hash
#		end
#	end

 	def latlng
		[self.latitud,self.longitud]
 	end


end
