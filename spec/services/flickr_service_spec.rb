require 'rails_helper'

RSpec.describe FlickrService do 

  before do 

    flickr_elephant_data = JSON(File.read('spec/fixtures/Elephant_ride.json'))
    allow(FlickrService).to receive(:get).and_return(flickr_elephant_data)

    @result = FlickrService.photos_of(search: "Ride elephant", lat: 28.6139391 ,lng: 77.2090212)
  
  end

  it "find 92 photos" do
    expect(@result.length).to eq 92
  end

  it "makes an object for each photo with an image url" do 
    expect(@result.first.image_url).to eq('https://farm1.staticflickr.com/578/22338700974_3ef7860725.jpg')
  end

  it "can also retrieve the image in a different size" do 
    expect(@result.first.image_url("Thumbnail")).to eq('https://farm1.staticflickr.com/578/22338700974_3ef7860725_t.jpg')
  end

  it "sets the title for each photo" do 
    expect(@result.first.title).to eq "\"Dilli Haat\", at New Delhi"
  end

  describe "tag_list" do
    it "converts description into comma separated string of tags" do 
      expect(FlickrService.tag_list("ride an elephant")).to eq "ride,an,elephant"
    end
  end
end