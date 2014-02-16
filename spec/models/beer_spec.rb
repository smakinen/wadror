require 'spec_helper'

describe Beer do

  it "is saved with a proper name and style" do
    porter_style = Style.create name:"Porter"
    beer = Beer.create name:"X Porter", style: porter_style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    porter_style = Style.find_by name:"Porter"
    nameless_beer = Beer.create style:porter_style

    expect(nameless_beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    styleless_beer = Beer.create name:"X Porter"

    expect(styleless_beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

end
