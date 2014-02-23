class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery
  belongs_to :style

  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{|b| -(b.average_rating||0)}
    sorted_by_rating_in_desc_order[0..n-1] unless sorted_by_rating_in_desc_order.empty?
  end

  def to_s
    "#{name} #{brewery.name}"
  end
end