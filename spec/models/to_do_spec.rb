require 'rails_helper'


RSpec.describe ToDo, type: :model do
  before do 
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.add_stub(
      "Delhi, India", [
        {
          'latitude'     => 28.6139391,
          'longitude'    => 77.2090212,
          'address'      => 'Delhi, India',
          'country'      => 'India'
        }
      ]
    )

    @destination = Destination.create(name: "India")
    @to_do = @destination.to_dos.build(:description => "Ride an Elephant", :address => "Delhi")
    @kurt = Traveller.create!(name: "Kurt", email: "new@sage.trav.com", password: "LikeTotally")
    @previn = Traveller.create!(name: "Previn", email: "Sweety@sage.trav.com", password: "LikeYahally")

    flickr_elephant_data = JSON(File.read('spec/fixtures/Elephant_ride.json'))
    allow(FlickrService).to receive(:get).and_return(flickr_elephant_data)

  end


  it "should build a string suitable for geocoding" do 
    expect(@to_do.geocode_string).to eq('Delhi, India')
  end

  it "geocodes the coordinates" do

    @to_do.geocode

    expect(@to_do.lat). to eq 28.6139391
    expect(@to_do.lng). to eq 77.2090212
  end

  it "geocodes on save" do 
    @to_do.save!

    expect(@to_do.lat). to eq 28.6139391
    expect(@to_do.lng). to eq 77.2090212
  end

  it "can fetch array of flickr photo objects" do
    @to_do.save!
    expect(@to_do.photos[0].is_a? Struct)
  end

  describe "ToDo Likes" do 

    it "knows how many likes it has" do 
      Like.create!(traveller: @kurt, to_do: @to_do)
      expect(@to_do.likes.length).to eq 1
    end

    it "can be liked through shovelling directly in" do 
      @to_do.travellers << @kurt
      expect(@to_do.likes.length).to eq 1
    end

    it "cannot be liked twice by the same traveller" do
      Like.create(traveller: @kurt, to_do: @to_do)
      Like.create(traveller: @kurt, to_do: @to_do)
      expect(@to_do.likes.length).to eq 1

      expect { @to_do.travellers << @kurt }.to raise_error /Hey you can't like it THAT much!/
    end

    it "can be liked by different people" do 
      Like.create(traveller: @kurt, to_do: @to_do)
      Like.create(traveller: @previn, to_do: @to_do)
      expect(@to_do.likes.length).to eq 2

    end
  end
end
