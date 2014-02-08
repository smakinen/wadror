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
    ratings.first.beer.style

    # something like this
    # u.ratings.group(:beer_id).average(:score)[0]


    #
  end

end
