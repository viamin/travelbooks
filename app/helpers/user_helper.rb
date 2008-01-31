module UserHelper
  
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
  
end
