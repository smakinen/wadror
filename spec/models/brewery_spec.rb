require 'spec_helper'

describe Brewery do
  describe "when initialized with name Schlenkerla and year 1674" do
    subject{ Brewery.create name:"Schlenkerla", year:1674}

    it {should be_valid}
    its(:name) {should eq("Schlenkerla")}
    its(:year) {should eq(1674)}
  end

  describe "when not initialized with a proper name" do
    subject{ Brewery.create year:1674 }
    it {should_not be_valid}
  end

end