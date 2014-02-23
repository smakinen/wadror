class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: {only_integer: true,
                                  greater_than_or_equal_to: 1042}
  validate :established_year_cannot_be_in_the_future

  scope :active, -> {where active:true}
  scope :retired, -> {where active:[nil, false]}

  def print_report
    puts name
    puts "established at #{self.year}"
    puts "number of beers #{self.beers.count}"
    puts "number of ratings #{self.ratings.count}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{|b| -(b.average_rating||0)}
    sorted_by_rating_in_desc_order[0..n-1] unless sorted_by_rating_in_desc_order.empty?
  end

  # custom validation for the brewery establishment year
  def established_year_cannot_be_in_the_future
    if year > Time.now.year
      errors.add(:year, "cannot be in the future")
    end
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
