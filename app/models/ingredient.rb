class Ingredient < ActiveRecord::Base
  attr_accessible :discovered, :harvested, :counter, :name, :code, :latitude, :longitude, :title, :city, :state, :zip
  has_many :checkins
  has_many :users, through: :checkins

  has_many :user_ingredients
  has_many :users, through: :user_ingredients

  def latlong
    [latitude.to_f, longitude.to_f]
  end

  def self.three_found?
    Ingredient.where(harvested: true).count == 3
  end

  def self.reset_all
  	Ingredient.all.each do |ingredient|
      ingredient.counter = 0
      ingredient.discovered = false
      ingredient.harvested = false
      ingredient.save
    end
  end

end

