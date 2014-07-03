require 'spec_helper'

describe Game do 
	before do 
		Game.destroy_all
		Post.destroy_all
		@game = Game.create
		@game.messages << Message.all
	end

	it "show_first_message should show 1 message for zombies" do
		@game.show_first_message
		expect(Post.where(audience: "zombie").count).to eq(1)
	end

	it "show_first_message should show 1 message for humans" do
		@game.show_first_message
		expect(Post.where(audience: "human").count).to eq(1)
	end

	it "show_first_message should show the correct message for zombies" do
		@game.show_first_message
		expect(Post.find_by_audience("zombie").body).to eq("I am the Hive Queen. You and all of my children are an extension of my self - my eyes and ears, my hands and feet. Your primary goal is to grow the zombie horde by consuming and converting humans.")
	end

	it "show_first_message should show the correct message for humans" do
		@game.show_first_message
		expect(Post.find_by_audience("human").body).to eq("To any who can hear this transmission, we are the last surviving humans in the city. We have an update on the state of the ongoing research into this troubling infection. Our scientists tell us that a cure is in progress, but that several steps remain to complete it. We will let you know as soon as we can how you can help.")
	end

	# it "shows correct first location message for zombies" do
	# 	@game.show_first_location_message
	# 	p Post.where(title: "First Location Announcement", audience: "zombie")
	# 	expect(Post.where(title: "First Location Announcement", audience: "zombie")[0].body).to eq("There are great pulses of life coming from Market and Fifth. Go there - feed and increase our numbers. For the good of the horde!")
	# end

end