require 'spec_helper'

describe "Beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery_reaktor = FactoryGirl.create(:brewery_reaktor)
    @brewery_hartwall = FactoryGirl.create(:brewery_hartwall)
    @brewery_brewdog = FactoryGirl.create(:brewery_brewdog)

    @style_lager = FactoryGirl.create(:style, name:"lager")
    @style_pale_ale = FactoryGirl.create(:style, name:"Pale ale")
    @style_weizen = FactoryGirl.create(:style, name:"weizen")

    @beer1 = FactoryGirl.create(:beer, name:"5am Saint", brewery:@brewery_brewdog, style:@style_pale_ale)
    @beer2 = FactoryGirl.create(:beer, name:"Lapin kulta", brewery:@brewery_hartwall, style:@style_weizen)
    @beer3 = FactoryGirl.create(:beer, name:"Reaktor beer", brewery:@brewery_reaktor, style:@style_lager)

  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows one known beer", js:true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content "5am Saint"
  end

  it "by defaults shows the beers in alphabetical order", js:true do
    visit beerlist_path

    beers_table = find('table')

    first_data_row = beers_table.find('tr:nth-child(2)')
    second_data_row = beers_table.find('tr:nth-child(3)')
    third_data_row = beers_table.find('tr:nth-child(4)')

    # ensure alphabetical order

    first_data_row.should have_content(@beer1.name)
    second_data_row.should have_content(@beer2.name)
    third_data_row.should have_content(@beer3.name)

  end

  it "orders the beers by style if the style header is clicked", js:true do

    visit beerlist_path

    # click header
    style_srt_link = find('#style')
    style_srt_link.click

    beers_table = find('table')

    # beers should now be ordered by style instead of name

    first_data_row = beers_table.find('tr:nth-child(2)')
    second_data_row = beers_table.find('tr:nth-child(3)')
    third_data_row = beers_table.find('tr:nth-child(4)')

    first_data_row.should have_content(@beer3.style.name)
    second_data_row.should have_content(@beer1.style.name)
    third_data_row.should have_content(@beer2.style.name)

  end

  it "orders the beers by brewery if the brewery header is clicked", js:true do

    visit beerlist_path

    # click header
    style_srt_link = find('#brewery')
    style_srt_link.click

    beers_table = find('table')

    # beers should now be ordered by the brewery name

    first_data_row = beers_table.find('tr:nth-child(2)')
    second_data_row = beers_table.find('tr:nth-child(3)')
    third_data_row = beers_table.find('tr:nth-child(4)')

    first_data_row.should have_content(@beer1.brewery.name)
    second_data_row.should have_content(@beer2.brewery.name)
    third_data_row.should have_content(@beer3.brewery.name)

  end

end