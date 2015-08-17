class Track < ActiveRecord::Base
	
	belongs_to :user
	validates_presence_of :user
	has_many :points, dependent: :destroy
	validates_presence_of :name
	accepts_nested_attributes_for :points
	
 	def props
		[user.id,self.fecha,self.tiempo,self.velocidad,self.distancia,self.id]
 	end

end

