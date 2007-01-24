# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def ymap_js_tag
    output = '<script type="text/javascript" src="http://api.maps.yahoo.com/ajaxymap?v=3.0&appid=travellerbooks"></script>'
  end

  def ymap_div_style(width, height)
    output = '<style type="text/css">'
    output += "\n#mapContainer {\n"
    output += "  width: #{width};\n"
    output += "  height: #{height};\n"
    output += "}\n"
    output += "</style>\n"
    output
  end

  def ymap_div_tag
    output = '<div id="mapContainer"></div>'
  end

  def ymap_default_map
    output = '<script type="text/javascript">'
    output += "\nvar myPoint = new YGeoPoint(37.4041960114344,-122.008194923401);\n"
    output += 'var myAddress = "170 Phoebe St., Encinitas, CA 92024"'
    output += "\nvar map = new YMap(document.getElementById('mapContainer'));\n"
    output += "map.drawZoomAndCenter(myAddress, 3);\n"
    output += "map.addTypeControl();\n"
    output += "map.setMapType(YAHOO_MAP_HYB);\n"
    output += "var myMapTypes = map.getMapTypes();\n"
    output += "map.addPanControl();\n"
    output += "map.addZoomLong();\n"
#    output += "map.addOverlay(new YMarker(myAddress));\n"
    output += "map.addMarker(myAddress);\n"
    output += "</script>\n"
    output
  end

  def ymap_address_map(location)
    output = '<script type="text/javascript">'
    if location.nil?
      output += "\nvar myAddress = \"95054\"\n"
    else
      output += "\nvar myAddress = \"#{location.address_line_1} #{location.address_line_2}, #{location.city}, #{location.state} #{location.zip_code}\"\n"
    end
    output += "var map = new YMap(document.getElementById('mapContainer'));\n"
    output += "map.drawZoomAndCenter(myAddress, 3);\n"
    output += "map.setMapType(YAHOO_MAP_REG);\n"
    output += "map.addZoomLong();\n"
    output += "map.addTypeControl();\n"
    output += "var myMapTypes = map.getMapTypes();\n"
    output += "map.addMarker(myAddress);\n"
    output += "</script>\n"
    output
  end

end
