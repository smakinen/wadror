require 'spec_helper'

describe "Beer" do

  let!(:brewery) {FactoryGirl.create(:brewery_brewdog)}

  it "is added to the system when the name is not blank" do

    visit new_beer_path

    fill_in('beer[name]', with:'5am Saint')
    select('Pale ale', from:'beer[style]')
    select('Brewdog', from:'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change {Beer.count}.from(0).to(1)

    added_beer = Beer.first

    expect(added_beer.name).to eq('5am Saint')
    expect(added_beer.style).to eq('Pale ale')
    expect(added_beer.brewery.name).to eq(brewery.name)

  end

  it "is not added to the system if the name is blank and an error message is shown" do

    visit new_beer_path

    fill_in('beer[name]', with:'')
    select('Pale ale', from:'beer[style]')
    select('Brewdog', from:'beer[brewery_id]')

    click_button "Create Beer"

    expect(current_path).to eq(beers_path)
    expect(page).to have_content("Name can't be blank")

    expect(Beer.count).to eq(0)


  end


end