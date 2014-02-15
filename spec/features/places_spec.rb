require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown on the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:name => "Oljenkorsi")]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, they are shown on the page" do

    teerenpeli = Place.new name: "Teerenpeli"
    bruuveri = Place.new name: "Bruuveri"

    places = []
    places << teerenpeli
    places << bruuveri

    BeermappingApi.stub(:places_in).with("kamppi").and_return(
      places
    )

    visit places_path
    fill_in('city', with: "kamppi")
    click_button "Search"

    expect(page).to have_content("Teerenpeli")
    expect(page).to have_content("Bruuveri")
  end

  it "if no places are found in the location, a message is shown on the page" do

    BeermappingApi.stub(:places_in).with("suvisaaristo").and_return(
        []
    )

    visit places_path
    fill_in('city', with: "suvisaaristo")
    click_button "Search"

    expect(page).to have_content("No places in suvisaaristo")

  end
end