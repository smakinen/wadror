class Style < ActiveRecord::Base
  has_many :beers

  def self.top(n)
    sorted_by_rating_in_desc_order = top_styles
    sorted_by_rating_in_desc_order[0..n-1] unless sorted_by_rating_in_desc_order.empty?
  end

  def average_rating
    Style.style_average(id).to_s
  end

  private
  # the styles of all rated beers
  def self.rated_styles
    Rating.all.map{|r| r.beer.style}.uniq
  end

  # the average score of a given style in the user's ratings
  def self.style_average(style_id)

    # find out the which of the user's rated beers belong to a style
    style_specific_beers = Beer.all.select("id").where("style_id = ?", style_id).distinct

    # gather the ids of those beers in order to find the ratings
    style_specific_beer_ids = []

    style_specific_beers.each do |style_beer|
      style_specific_beer_ids << style_beer.id
    end

    # calc avg for the beers of the style
    style_average = Rating.all.where(beer_id: style_specific_beer_ids).average(:score)
  end

  def self.top_styles
    return nil if Rating.all.empty?
    # find the styles of all the beers that have been rated
    all_rated_beer_styles = rated_styles
    all_rated_beer_styles.sort_by{|style| -(style_average(style.id)||0)}
  end


end
