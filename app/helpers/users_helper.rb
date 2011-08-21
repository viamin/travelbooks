module UsersHelper
  
  def last_login_string(datetime)
    if datetime.day == Date.today.day
      last_day = "Today"
    elsif datetime.day == Date.today.day - 1
      last_day = "Yesterday"
    elsif ((Date.today.day - 7)..(Date.today.day - 2)) === datetime.day
      last_day = datetime.strftime("%A")
    else
      last_day = datetime.strftime("%b %e")
    end
    last_time = datetime.to_formatted_s(:last_login_time)
    "#{last_time} #{last_day}"
  end
  
  def add_person_marker(person, map)
    loc = person.current_location
    if person == Person.find(session[:user_id])
      map.add_marker(Marker.new([loc.lat, loc.lng], :info_bubble => loc.description, :icon => '/images/homeicon.png'))
    else
      map.add_marker(Marker.new([loc.lat, loc.lng], :info_bubble => person.display_name, :icon => '/images/personicon.png'))
    end
  end
  
  def add_item_marker(item, map)
    loc = item.locations.current
    map.add_marker(Marker.new([loc.lat, loc.lng], :info_bubble => item.name, :icon => '/images/ambericonsh.png'))
  end
  
  def add_trip_line(trip, map)
    dests = trip.destinations
    line = Array.new
    dests.each do |d|
      if d.has_location?
        line << LatLonPoint.new([d.location.lat, d.location.lng])
      end
    end
    polyline = Polyline.new(line, :width => 5, :color => COLORS[rand(6)], :opacity => 0.8)
    map.add_polyline(polyline)
  end
  
end
