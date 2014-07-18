# EXAMPLE OF TECHNICAL DEBT - NEEDS REFACTORING

desc "This task is called by the Heroku scheduler add-on"
task :create_game => :environment do
	Game.destroy_last_game
	game = Game.create
	game.setup
  #users reset human/zombie - fatalistic
end

task :create_demo => :environment do
	event_num = 1
	until event_num > 2 do 
		Rake::Task["start_game"].execute
		ingredient = Ingredient.find(event_num)
		ingredient.harvested = true
		ingredient.save
		event_num += 1
	end
	Rake::Task["start_game"].execute
end

task :start_game => :environment do #ewwww needs refactor
	game = Game.first
	game.initiate if game.started == false
	game.show_announcements
	if Ingredient.three_found?
		User.all_can_cure 
		game.cure_found = true
		game.save
		Post.show_cure_createds
	end
end

#Adding to DateTime.current 1 results in adding one day.  When adding to a DateTime in the database, adding 1 adds 1 second.  Weird.