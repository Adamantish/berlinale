module FlickrService
  include HTTParty
  base_uri 'api.flickr.com:443'
  
  NO_PHOTOS_PLACEHOLDER = "no_images.png"
  
  PHOTO_SIZES =  {
    
    "Square" => "_s" ,
    "Large Square" => "_q" ,
    "Thumbnail" => "_t" ,
    "Small" => "_m" ,
    "Small 320" => "_n" ,
    "Medium" =>  "" ,
    "Medium 640" => "_z" ,
    "Medium 800" => "_c" ,
    "Large" => "_b" ,
    "Original" => "_o" 
  }

  def self.photos_of(search: , lat: ,lng:)
    response = self.get("/services/rest", {query: 
        {method:'flickr.photos.search',
          tags: tag_list(search),
          api_key: Rails.application.secrets[:flickr_api_key],
          format:'json',
          lat: lat,
          lon: lng,
          nojsoncallback: 1
        }
      }
    )
    response_photos = response["photos"]["photo"]
    photos = []


    if response_photos.any?
      photos = response_photos.map do |photo|
        Photo.new(photo["id"], photo["title"], photo["secret"], photo["farm"], photo["server"])
      end
    else
      # TODO: move this logic to the view
      photos << Photo.new(nil, "no images found")
    end

    photos

  end

  def self.tag_list(search)
    search.strip.chomp.split(" ").join(",")
  end

  Photo = Struct.new(:id, :title, :secret, :farm, :server) do 
    def image_url(size = "Medium")
      if id
        "https://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}#{PHOTO_SIZES[size]}.jpg"
      else
        "/assets/" << NO_PHOTOS_PLACEHOLDER
      end
    end
  end


end