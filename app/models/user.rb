class User < ActiveRecord::Base
  include RatingAverage
  has_many :ratings
  has_many :beers, through: :ratings

  has_many :memberships
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true
  validates :username, length: {in: 3..15}
end
