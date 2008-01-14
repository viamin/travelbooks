// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function loadUserMap() {
	var mapstract = new Mapstraction('user_map', 'yahoo');
	mapstract.setCenterAndZoom(new LatLonPoint(36.9732, -122.0135), 10);
	mapstract.addSmallControls();
	mapstract.addMapTypeControls();
	// Move the map since for some reason the css is being ignored
	var map_div = document.getElementById("user_map");
	map_div.style.position = 'absolute';
	map_div.style.top = '136px';
	map_div.style.left = '373px';
}

function positionFriendMap() {
	// Move the map since for some reason the css is being ignored
	var map_div = document.getElementById("friend_map");
	map_div.style.position = 'absolute';
	map_div.style.top = '146px';
	map_div.style.left = '373px';
}