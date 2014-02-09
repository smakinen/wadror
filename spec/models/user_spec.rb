require 'spec_helper'

describe User do

  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do

      rating = FactoryGirl.create(:rating)
      rating2 = FactoryGirl.create(:rating2)

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15)
    end
  end

  it "is not saved without a password that is too short" do
    user = User.create username:"Pekka", password:"abc", password_confirmation:"abc"

    expect(User.count).to eq(0)
    expect(user).not_to be_valid
  end

  it "is not saved without a password which doesn't have a digit" do
    user = User.create username:"Pekka", password:"abcD", password_confirmation:"abcD"

    expect(User.count).to eq(0)
    expect(user).not_to be_valid
  end

  describe "favorite beer" do

    let(:user) {FactoryGirl.create(:user)}

    it "has a method for determining the favorite beer" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with the highest rating if several rated" do

      create_beers_with_ratings(10, 15, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end

  end

  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating(score, user)
    end
  end

  def create_beer_with_style_and_rating(style, score, user)
    beer = FactoryGirl.create(:beer, style:style)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beer_with_brewery_and_rating(brewery, score, user)
    beer = FactoryGirl.create(:beer, brewery:brewery)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_brewery_and_ratings(brewery, *scores, user)
    scores.each do |score|
      beer = FactoryGirl.create(:beer, brewery:brewery)
      FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    end
  end

  describe "favorite style" do
    let(:user) {FactoryGirl.create(:user)}

    it "has a method for determining the favorite style" do
      user.should respond_to :favorite_style
    end

    it "is the style of the only beer if only one beer rated " do
        beer = create_beer_with_rating(20, user)
        expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style of the highest rated beer if two beers with different styles rated" do
      lager_beer = create_beer_with_rating(10, user)
      preferred_porter_beer = create_beer_with_style_and_rating("Porter", 20, user)

      expect(user.favorite_style).to eq(preferred_porter_beer.style)
    end

    it "is the style of which ratings has a highest average if several styles rated" do

      # standard lager beers
      create_beer_with_rating(10, user)
      create_beer_with_rating(20, user)

      create_beer_with_style_and_rating("Pale Ale", 28, user)
      create_beer_with_style_and_rating("Pale Ale", 17, user)

      create_beer_with_style_and_rating("Scotch Ale", 35, user)
      preferred_beer_sample = create_beer_with_style_and_rating("Scotch Ale", 31, user)

      expect(user.favorite_style).to eq(preferred_beer_sample.style)

    end
  end

  describe "favorite brewery" do

    let(:user) {FactoryGirl.create(:user)}

    let(:brewery_reaktor) {FactoryGirl.create(:brewery_reaktor)}
    let(:brewery_hartwall) {FactoryGirl.create(:brewery_hartwall)}

    it "has the method for determining the favorite brewery" do
      user.should respond_to :favorite_brewery
    end

    it "is the brewery of the beer if only one beer rated" do
      beer = create_beer_with_rating(10, user)
      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the brewery which has the higher rating if two ratings with different breweries" do
      create_beer_with_brewery_and_rating(brewery_reaktor, 15, user)
      higher_rated_beer = create_beer_with_brewery_and_rating(brewery_hartwall, 25, user)

      expect(user.favorite_brewery).to eq(higher_rated_beer.brewery)

    end

    it "is the brewery which has the highest rating if beers of muliple breweries rated" do
      brewery_brewdog = FactoryGirl.create(:brewery_brewdog)

      create_beers_with_brewery_and_ratings(brewery_brewdog, 10, 15, 27, 5, user)
      create_beers_with_brewery_and_ratings(brewery_hartwall, 5, 7, 10, 12, user)
      create_beers_with_brewery_and_ratings(brewery_reaktor, 20, 15, user)

      expected_brewery_product = create_beer_with_brewery_and_rating(brewery_reaktor, 30, user)
      expect(user.favorite_brewery).to eq(expected_brewery_product.brewery)

    end



  end


end
