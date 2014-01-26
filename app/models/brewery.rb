class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  # Alternative ActiveRecord avg method. Before week 2, exc. 15 mixin.
  #def average_rating
  #  ratings.average(:score)
  #end

end
