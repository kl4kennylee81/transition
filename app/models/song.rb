class Song < ActiveRecord::Base
	def self.search(search)
	  if search
	    Song.where(['title LIKE ?', "%#{search}%"])
	  else
	    Song.all
	  end
	end

end
