require 'spec_helper'
include OwnTestHelper

describe "Rating" do

  let!(:brewery) {FactoryGirl.create :brewery, name:"Koff"}
  let!(:beer1) {FactoryGirl.create :beer, name:"Iso 3", brewery:brewery}
  let!(:beer2) {FactoryGirl.create :beer, name:"Karhu", brewery:brewery}
  let!(:user) { FactoryGirl.create :user}

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and to the user who is signed in" do

    visit new_rating_path

    select('Iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')


    expect{
      click_button ("Create Rating")
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15)
  end

  it "is shown in all ratings with the correct information" do

    brewdog_brewery = FactoryGirl.create(:brewery_brewdog)
    beer3 = FactoryGirl.create(:beer, name:"5am Saint", brewery:brewdog_brewery)

    rating1 = FactoryGirl.create(:rating, score:25, beer:beer1, user:user)
    rating2 = FactoryGirl.create(:rating, score:15, beer:beer2, user:user)
    rating3 = FactoryGirl.create(:rating, score:30, beer:beer3, user:user)

    visit ratings_path

    expect(page).to have_content("3 beers rated so far.")
    expect(page).to have_content("#{beer1.name} #{rating1.score} #{user.username}")
    expect(page).to have_content("#{beer2.name} #{rating2.score} #{user.username}")
    expect(page).to have_content("#{beer3.name} #{rating3.score} #{user.username}")

  end

  it "made by a user is visible on the account page but not on the account page of others" do

    another_user = FactoryGirl.create(:user, username:"Matt")

    own_rating = FactoryGirl.create(:rating, score:25, beer:beer1, user:user)
    another_user_rating = FactoryGirl.create(:rating, score:40, beer:beer2, user:another_user)

    visit user_path(user)
    expect(page).to have_content("#{own_rating.beer.name} #{own_rating.score}")
    expect(page).to have_no_content("#{another_user_rating.beer.name} #{another_user_rating.score}")
  end

  it "is deleted when a user chooses to delete the rating from the account page" do
    rating1 = FactoryGirl.create(:rating, score:25, beer:beer1, user:user)
    rating2 = FactoryGirl.create(:rating, score:15, beer:beer2, user:user)

    visit user_path(user)

    expect{
      page.first(:link, "delete").click
    }.to change{Rating.count}.from(2).to(1)

  end

  it "affects the preferred beer style on the user's page" do
    brewdog_brewery = FactoryGirl.create(:brewery_brewdog)

    pale_ale_style = FactoryGirl.create(:style, name:"Pale Ale")
    another_beer = FactoryGirl.create(:beer, name:"5am Saint", style:pale_ale_style, brewery:brewdog_brewery)

    rating1 = FactoryGirl.create(:rating, score:25, beer:beer1, user:user)
    rating2 = FactoryGirl.create(:rating, score:30, beer:another_beer, user:user)

    visit user_path(user)

    expect(page).to have_content("#{another_beer.style.name} tastes and feels the best at the moment")

  end

  it "affects the preferred brewery on the user's page" do
    brewdog_brewery = FactoryGirl.create(:brewery_brewdog)

    pale_ale_style = FactoryGirl.create(:style, name:"Pale Ale")
    another_beer = FactoryGirl.create(:beer, name:"5am Saint", style:pale_ale_style, brewery:brewdog_brewery)

    rating1 = FactoryGirl.create(:rating, score:25, beer:beer1, user:user)
    rating2 = FactoryGirl.create(:rating, score:30, beer:another_beer, user:user)

    visit user_path(user)

    expect(page).to have_content("#{another_beer.brewery.name} has the most enjoyable products")


  end


  end