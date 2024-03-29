class User < ActiveRecord::Base

	attr_accessible :email, :phone_number, :password, :handle, :infected, :name, :points, :cures, :infections, :mod

  belongs_to :game
  belongs_to :battle
  has_many :user_ingredients
  has_many :ingredients, through: :user_ingredients

  validates :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  validates :email, uniqueness: true
  
  has_many :checkins
  has_many :ingredients, through: :checkins
	has_secure_password

  def self.points
    User.order("points desc")
  end

  def generate_handle
    first_half = self.id.to_s + (1..9).to_a.sample.to_s
    letters = []
    2. times do
      letters << ("A".."Z").to_a.sample
    end
    second_half = letters.join
    whole = first_half.to_s + second_half.to_s
  end

  def should_be_infected
    num = (1..100).to_a.sample
    num > 75
  end

  def self.all_can_cure
    User.all.each do |user|
      user.can_cure = true
      user.save
    end
  end

  def password
  end


end