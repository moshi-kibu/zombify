class Message < ActiveRecord::Base
	attr_accessible :title, :description, :audience, :has_been_called

	belongs_to :game

  def self.zombie_messages
    Message.where(audience: "zombie")
  end

  def self.human_messages
    Message.where(audience: "human")
  end

  def self.reset_all
		Message.all.each do |message|
			message.has_been_called = false
			message.save
		end
  end

  # def self.cure_createds_called?
  # 	Message.where(title: "Cure created")[0].has_been_called && 
  # 	Message.where(title: "Cure created")[1].has_been_called
  # end
end