class ToDo < ActiveRecord::Base

  belongs_to :destination
  belongs_to :traveller

  has_many :likes
  has_many :travellers, :through => :likes

  geocoded_by :geocode_string, latitude: :lat, longitude: :lng
  before_save :geocode

  validates :destination_id , numericality: { greater_than: 0 }

    def geocode_string
      "#{address}, #{destination.name}"
    end

    def photos
      FlickrService.photos_of(search: description << "#{geocode_string.gsub(',','')}", lat: lat ,lng: lng)
    end
end
