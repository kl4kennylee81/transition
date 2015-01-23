class SongsController < ApplicationController

	@@counter = 0

	def index 
		@@counter = 0
		@songs = Song.search(params[:search])
	end 

	def show
		@song = Song.find(params[:id])
		@no_links = Array.new(0)
		@link_transitions = Array.new(0)
		JSON.parse(@song.transitions).each do |t|
			song_l = Song.where(['title = ?', t])
			if song_l != []
				@link_transitions.push(song_l[0])
			else 
				@no_links.push(t)
			end
		end 
		@adding = @@counter
		if params[:count]
			@@counter = @@counter + 1
			redirect_to song_path(@song)
		end 
	end 

	def new
		@song = Song.new
		if params[:trans]
			@inputted = params[:trans]
		else 
			@inputted = []
		end
		if params[:count]
			@@counter = @@counter + 1
			redirect_to new_song_path
		end
		@counter = @@counter
	end

	def create
		@song = Song.new(:title => params[:title], 
			:transitions => [])
		temp_trans = params[:trans]
		upd_trans = Array.new(0)
		temp_trans.each do |t|
			if t != ""
				upd_trans.push(t)
			end
		end
		@song.transitions = upd_trans
		@song.save
		redirect_to @song
	end

	def update
		@song = Song.find(params[:id])
		@list = params[:songs]
		@add = params[:trans]
		if @add
			upd_list = JSON.parse(@song.transitions)
			@add.each do |title|
				if title != ""
					upd_list.push(title)
				end
			end
			@song.update_attributes(:transitions => JSON.dump(upd_list))
		end
		if @list
			upd_list = JSON.parse(@song.transitions)
			@list.each do |title|
				upd_list.delete(title)
			end 
			@song.update_attributes(:transitions => JSON.dump(upd_list))
			redirect_to @song
		else 
			redirect_to @song
		end
	end

	def destroy
		@song = Song.find(params[:id])
		@song.destroy
		redirect_to songs_path
	end

	private
	  def song_params
	    params.require(:song).permit(:title, :transitions)
	  end

end
