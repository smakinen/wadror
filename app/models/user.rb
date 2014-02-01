class User < ActiveRecord::Base
  include RatingAverage
  has_many :ratings

  validates :username, uniqueness: true
  validates :username, length: {in: 3..15}
end
