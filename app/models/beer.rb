class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    times_rated = ratings.count

    # init sum to float for avg calculation
    ratings_sum = ratings.inject(0.0) { |sum, rating |
      sum + rating.score
    }

    # calc avg if there are ratings, default to 0
    avg_score = (times_rated > 0) ? ratings_sum / times_rated : 0

    # alternative method with AR
    #ratings.average('score').to_s
  end

  def to_s
    "#{name} #{brewery.name}"
  end
end