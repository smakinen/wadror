module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    times_rated = ratings.count

    # init sum to float for avg calculation
    ratings_sum = ratings.inject(0.0) { |sum, rating|
      sum + rating.score
    }

    # calc avg if there are ratings, default to 0
    avg_score = (times_rated > 0) ? ratings_sum / times_rated : 0
  end
end