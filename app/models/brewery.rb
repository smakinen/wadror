class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: {only_integer: true,
                                  greater_than_or_equal_to: 1042,
                                  less_than_or_equal_to: 2014}

  def print_report
    puts name
    puts "established at #{self.year}"
    puts "number of beers #{self.beers.count}"
    puts "number of ratings #{self.ratings.count}"
  end

  # Alternative ActiveRecord avg method. Before week 2, exc. 15 mixin.
  #def average_rating
  #  ratings.average(:score)
  #end

  def restart
    self.year = 2014
    puts "changed year to #{year}"
  end

end
