class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true
  validates :username, length: {in: 3..15}

  validates :password, length: {minimum: 4}
  validate :password_must_contain_digit_and_caps

  def password_must_contain_digit_and_caps

    contains_digit = !password.match(/[\d{1,}]+/).nil? if not password.nil?
    contains_capital_letter = !password.match(/[A-Z]+/).nil? if not password.nil?

    if not contains_digit or not contains_capital_letter
      errors.add(:password, "Password must contain a capital letter and a number")
    end
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    # find the styles of the beers the user has rated
    user_beer_styles = rated_styles

    # put the averages for each beer style here
    style_score_averages = {}

    # get average for each rated style
    user_beer_styles.each do |style|
      style_score_averages[style] = style_average(style)
    end

    # find which rated style has the highest average
    highest_rated_style = style_score_averages.max_by {|beer_style, score_average| score_average}
    highest_rated_style.first #name

  end

  def favorite_brewery
    return nil if ratings.empty?

    # breweries included in the user's ratings
    user_beer_breweries = rated_breweries

    # get average score for different breweries
    brewery_score_averages = {}

    user_beer_breweries.each do |brewery_id, ratings_amount| #amount unused here
      brewery_score_averages[brewery_id] = brewery_average(brewery_id)
    end

    # find which brewery has the highest average as rated by user
    highest_rated_brewery = brewery_score_averages.max_by {|brewery_id, score_average| score_average}
    Brewery.find(highest_rated_brewery.first)

  end

  private

  # the style names of the beers the user has sampled and rated
  def rated_styles
    beers.group(:style).count.keys
  end

  def rated_breweries
    beers.group(:brewery_id).count
  end

  # the average score of a given style in the user's ratings
  def style_average(style)

    # find out the which of the user's rated beers belong to a style
    style_specific_beers = beers.where("style = ?", style).group(:beer_id)

    # gather the ids of those beers in order to find the ratings
    style_specific_beer_ids = []

    style_specific_beers.each do |style_beer|
      style_specific_beer_ids << style_beer.id
    end

    # calc avg for the beers of the style
    style_average = ratings.where(beer_id: style_specific_beer_ids).average(:score)
  end

  def brewery_average(brewery_id)
    # find out the which of the user's rated beers belong to the given brewery
    brewery_specific_beers = beers.where("brewery_id = ?", brewery_id).group(:beer_id)

    # gather the ids of brewery beers in order to find the ratings
    brewery_specific_beer_ids = []

    brewery_specific_beers.each do |brewery_beer|
      brewery_specific_beer_ids << brewery_beer.id
    end

    # calc avg for the beers of the brewery as rated by the user
    brewery_average = ratings.where(beer_id: brewery_specific_beer_ids).average(:score)
  end

end
