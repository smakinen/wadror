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

    # for some reason this doesn't work when using (double quotes ""?)
    #contains_digit = !password.match("[\d{1,}]+").nil?

    contains_digit = !password.match("[0-9]+").nil? if not password.nil?
    contains_capital_letter = !password.match("[A-Z]+").nil? if not password.nil?

    if not contains_digit or not contains_capital_letter
      errors.add(:password, "Password must contain a capital letter and a number")
    end

  end
end
