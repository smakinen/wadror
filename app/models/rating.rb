class Rating < ActiveRecord::Base
  belongs_to :beer
  belongs_to :user

  validates :score, numericality: {only_integer: true,
                                   greater_than_or_equal_to: 1,
                                   less_than_or_equal_to: 50}

  def to_s
    "#{beer.name} #{score}"
  end
end
