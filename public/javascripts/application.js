// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function loadUserMap() {
	var mapstract = new Mapstraction('user_map', 'yahoo');
	mapstract.setCenterAndZoom(new LatLonPoint(42.4365, -83.4884), 2);
}
