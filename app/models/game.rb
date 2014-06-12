class Game < ActiveRecord::Base
	has_many :users
	has_many :messages

	attr_accessible :start_time, :game_active, :started

	TIME_BETWEEN_GAME_CREATE_AND_GAME_START = 0 #in days
	LENGTH_OF_GAME = 1 													#in days
	TIME_INTERVAL_BETWEEN_ANNOUNCEMENTS = 0 		#in seconds

	def self.destroy_last_game
		Game.destroy_all
		Post.destroy_all
		User.destroy_all
		Checkin.destroy_all
		Message.reset_all
		Ingredient.reset_all
	end

	def setup
  	self.messages << Message.all
  	self.set_code_and_times
	end

	def initiate
		self.game_active = true
		self.started = true
		self.save
	end


	def show_announcements
		if self.ready_for_3rd_announcement?
			self.show_third_location_message
			ingredient = Ingredient.find(3)
			ingredient.discovered = true
			ingredient.save
		elsif self.ready_for_2nd_announcement?
			self.show_second_location_message
			ingredient = Ingredient.find(2)
			ingredient.discovered = true
			ingredient.save
		elsif self.ready_for_1st_announcement?
			self.show_first_message
			self.show_first_location_message
			ingredient = Ingredient.find(1)
			ingredient.discovered = true
			ingredient.save
		end
	end

	def self.current
		#assuming there is only one active game
		Game.find_by_game_active(true)
	end

	def self.completed?
		Game.where(started: true, game_active: false).length > 0 ? true : false
	end

	def self.end
		Game.current.update_attributes(game_active: false)
	end

	def current_game_state
		if possible_to_harvest?
			return "harvest"
		elsif cure_available?
			return "cure"
		else
			return "waiting to harvest"
		end
	end

	def possible_to_harvest?
		Ingredient.where(discovered: true, harvested: false).any?
	end

	def cure_available?
		Game.current.cure_found
	end

	def self.pending?
		Game.where(game_active: false, started: false ).length > 0 ? true : false
	end

	def set_code_and_times
		self.start_time = DateTime.current + TIME_BETWEEN_GAME_CREATE_AND_GAME_START
		self.end_time = DateTime.current + LENGTH_OF_GAME # 1 day
		self.save
	end

	def ready_for_1st_announcement?
		self.game_active == true && self.after_start_time
	end

	def ready_for_2nd_announcement?
		second_announcement_time_condition? && first_ingredient_found?
	end

	def ready_for_3rd_announcement?
		third_announcement_time_condition? && second_ingredient_found?
	end

	def second_announcement_time_condition?
		DateTime.current >= self.start_time + TIME_INTERVAL_BETWEEN_ANNOUNCEMENTS
	end

	def third_announcement_time_condition?
		DateTime.current >= self.start_time + (2 * TIME_INTERVAL_BETWEEN_ANNOUNCEMENTS)
	end

	def first_ingredient_found?
		Ingredient.find(1).harvested
	end

	def second_ingredient_found?
		Ingredient.find(2).harvested
	end

	def show_first_message # Game.first MVP ONLY BUG BUG BUG
		find_message("Incoming Communication")
	end

	def show_first_location_message
		find_message("You Must Go...")
	end

	def show_second_location_message
		find_message("Another Ingredient!")
	end

	def show_third_location_message
		find_message("It Is Time!")
	end

	def find_message(title)
		messages = Game.first.messages.where(title: title)
		messages = messages.select do |message|
			message.has_been_called == false
		end
		create_posts(messages)
	end

	def create_posts(messages)
		messages.each do |message|
			set_message_as_called(message)
			@post = Post.create(title: message[:title], body: message[:description],
				audience: message[:audience])
		end
	end

	def set_message_as_called(message)
		message.has_been_called = true
		message.save
	end

	def after_start_time
		DateTime.current > self.start_time
	end

	# def alert_users(kind)
 	#  	User.all.each do |user|
	#   	puts "---------------------"
	#   	p "Would send alert to #{user.phone.to_s}"
	#   	account_sid = 'ACabd565c09d3a7ac29013e490baf50742'
	# 		auth_token = '64f02d85badd951102329f750bc0bc8e'
	# 		if kind == 'game_starting'
	# 			message = 'The game is starting! Log in to your account at zomb.herokuapp.com to play!'
	#   	else
	#   		message = 'The game is over. Thanks for joining us. You can check your stats on the website for the next two hours before the game resets in preparation for next week.'
	#   	end

	# 		begin
	# 			client = Twilio::REST::Client.new account_sid, auth_token

	# 			client.account.messages.create({
	# 				:from => '+13147363622',
	# 				:to => @user.phone.to_s,
	# 				:body => message,
	# 			})
	# 		rescue Twilio::REST::RequestError => e
	# 			puts "Error: #{e.message}"
	# 		end
	# 	end
	# end
end