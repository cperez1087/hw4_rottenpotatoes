require 'spec_helper'

describe Movie do

  it 'should return a list of movie rates' do
    Movie.all_ratings.should include("PG-13")
  end
end