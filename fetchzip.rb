require 'csv'

STATES = {
  :AK => "Alaska", 
  :AL => "Alabama", 
  :AR => "Arkansas", 
  :AS => "American Samoa", 
  :AZ => "Arizona", 
  :CA => "California", 
  :CO => "Colorado", 
  :CT => "Connecticut", 
  :DC => "District of Columbia", 
  :DE => "Delaware", 
  :FL => "Florida", 
  :GA => "Georgia", 
  :GU => "Guam", 
  :HI => "Hawaii", 
  :IA => "Iowa", 
  :ID => "Idaho", 
  :IL => "Illinois", 
  :IN => "Indiana", 
  :KS => "Kansas", 
  :KY => "Kentucky", 
  :LA => "Louisiana", 
  :MA => "Massachusetts", 
  :MD => "Maryland", 
  :ME => "Maine", 
  :MI => "Michigan", 
  :MN => "Minnesota", 
  :MO => "Missouri", 
  :MS => "Mississippi", 
  :MT => "Montana", 
  :NC => "North Carolina", 
  :ND => "North Dakota", 
  :NE => "Nebraska", 
  :NH => "New Hampshire", 
  :NJ => "New Jersey", 
  :NM => "New Mexico", 
  :NV => "Nevada", 
  :NY => "New York", 
  :OH => "Ohio", 
  :OK => "Oklahoma", 
  :OR => "Oregon", 
  :PA => "Pennsylvania", 
  :PR => "Puerto Rico", 
  :RI => "Rhode Island", 
  :SC => "South Carolina", 
  :SD => "South Dakota", 
  :TN => "Tennessee", 
  :TX => "Texas", 
  :UT => "Utah", 
  :VA => "Virginia", 
  :VI => "Virgin Islands", 
  :VT => "Vermont", 
  :WA => "Washington", 
  :WI => "Wisconsin", 
  :WV => "West Virginia", 
  :WY => "Wyoming"
}

ZONES = {
  :AK => "Other US",
  :AL => "South & Midwest",
  :AR => "South & Midwest",
  :AZ => "Western",
  :CA => "Western",
  :CO => "Western",
  :CT => "Metro New York",
  :DC => "Eastern",
  :DE => "Eastern",
  :FL => "South & Midwest",
  :GA => "Eastern",
  :HI => "Other US",
  :IA => "South & Midwest",
  :ID => "Western",
  :IL => "Eastern",
  :IN => "Eastern",
  :KS => "South & Midwest",
  :KY => "Eastern",
  :LA => "South & Midwest",
  :MA => "Eastern",
  :ME => "Eastern",
  :MI => "Eastern",
  :MD => "Eastern",
  :MN => "South & Midwest",
  :MO => "South & Midwest",
  :MS => "South & Midwest",
  :MT => "Western",
  :NE => "South & Midwest",
  :NJ => "Metro New York",
  :NC => "Eastern",
  :ND => "South & Midwest",
  :NH => "Eastern",
  :NM => "Western",
  :NV => "Western",
  :NY => "Eastern",
  :OH => "Eastern",
  :OK => "South & Midwest",
  :OR => "Western",
  :PA => "Eastern",
  :RI => "Eastern",
  :SC => "Eastern",
  :SD => "South & Midwest",
  :TN => "Eastern",
  :TX => "Western",
  :UT => "Western",
  :VA => "Eastern",
  :VT => "Eastern",
  :WA => "Western",
  :WI => "South & Midwest",
  :WV => "Eastern",
  :WY => "Western"
}

DELIVERY = {
  "Eastern" => 2,
  "South & Midwest" => 4,
  "Western" => 6,
  "Other US" => 6,
  "Metro New York" => 1
}

class FetchZip
  def run
    zip = CSV.read('us_postal_codes.csv')
    
    metro_array = CSV.read('ny_sales_tax_rates.csv')

    metro_hash = {}

    metro_array.each do |m|
      metro_hash[m[4]] = "METRO"
    end

    delivery_array = [["ZipCode", "City", "StateCode", "Zone", "DeliveryDays"]]
    zip.each do |z|
      if "METRO" == metro_hash[z[0]]
        delivery_array << [z[0], z[1], z[3], "Metro New York", 1]
      elsif z[3]
        zone = ZONES[z[3].to_sym]
        delivery_array << [z[0], z[1], z[3], zone, DELIVERY[zone]]
      end
    end

    CSV.open("delivery_days.csv", "wb") do |csv|
      delivery_array.each do |a|
        csv << a
      end
    end
  end
end


fz = FetchZip.new
fz.run
