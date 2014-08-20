collection @businesses

attributes :longitude, :latitude, :name, :yelp_avatar, :yelp_url 

node do |business|
  {:full_address => business.address.to_s + ", " + business.locality.to_s + ", HI " + business.postcode.to_s}
end