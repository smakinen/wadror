class User < ActiveRecord::Base
  include RatingAverage
  has_many :ratings
  has_many :beers, through: :ratings
  has_many :beerclubs

  validates :username, uniqueness: true
  validates :username, length: {in: 3..15}
end
