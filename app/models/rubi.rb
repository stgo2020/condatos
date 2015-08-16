class Rubi < ActiveRecord::Base
		belongs_to :user
		validates_presence_of :user


	def rubi_props
		[user.id,self.nombre,self.id]
 	end


end
