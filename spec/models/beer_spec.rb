require 'spec_helper'

describe Beer do

  it "is saved with a proper name and style" do
    beer = Beer.create name:"X Porter", style:"Porter"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    nameless_beer = Beer.create style:"Porter"

    expect(nameless_beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    styleless_beer = Beer.create name:"X Porter"

    expect(styleless_beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

end
