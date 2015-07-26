class Track < ActiveRecord::Base
	
	belongs_to :user
	validates_presence_of :user
	has_many :points
	validates_presence_of :name
	accepts_nested_attributes_for :points
	
 	def props
		[self.tiempo,self.velocidad,self.distancia]
 	end


end

