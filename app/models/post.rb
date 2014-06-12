class Post < ActiveRecord::Base
  attr_accessible :body, :title, :audience

  def self.latest_zombie_posts
    Post.where("audience = ? or audience = ?", "zombie", "both").order('created_at DESC')
  end

  def self.latest_human_posts
    Post.where("audience = ? or audience = ?", "human", "both").order('created_at DESC')
  end

  def self.delete_empty_posts(posts)
  	posts.each do |post|
  		if post.title == nil || post.body == nil
  			post.destroy
  		end
  	end
  end

  def self.show_cure_createds
    cure_zombie = Message.where(title: "Cure created", audience: "zombie")[0]
    cure_human = Message.where(title: "Cure created", audience: "human")[0]

    Post.create(title: cure_zombie.title, body: cure_zombie.description, audience: "zombie")
    Post.create(title: cure_human.title, body: cure_human.description, audience: "human")
    cure_zombie.has_been_called = true
    cure_zombie.save
    cure_human.has_been_called = true
    cure_human.save
  end
end