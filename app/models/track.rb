class Track < ActiveRecord::Base
	
	has_many :points
	accepts_nested_attributes_for :points
	

end

