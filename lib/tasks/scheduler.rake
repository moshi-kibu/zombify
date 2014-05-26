desc "This task is called by the Heroku scheduler add-on"
task :create_game => :environment do
	Message.all.each do |message|
		message.has_been_called = false
		message.save
	end

	Game.destroy_all
	Post.destroy_all
  puts "Instantiating game"
  game = Game.create
  puts "New game created: #{game}"
  game.messages << Message.all
  game.set_code_and_times
end

# this whole task ought to be refactored.
task :start_game => :environment do
	game = Game.first
	if game.after_start_time && game.game_active == false

		game.game_active = true
		game.save

		game.show_first_message
		game.show_first_location_message
	end
	 
	if DateTime.current >= game.start_time + 60 # 10 minutes
		game.show_second_location_message
	end
end

#Adding to DateTime.current 1 results in adding one day.  When adding to a DateTime in the database, adding 1 adds 1 second.  Weird.

task :check_events => :environment do 
  puts "Checking for fate events"
  #something goes here
end