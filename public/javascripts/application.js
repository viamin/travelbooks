// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


// "Borrowed" from http://www.agilepartners.com/blog/2005/12/07/iphoto-image-resizing-using-javascript/
function scaleIt(v, width) {
	var scalePhoto = document.getElementById("photo_block");

	// Remap the 0-1 scale to fit the desired range
	floorSize = (240 / width);
	ceilingSize = 1.0;
	v = floorSize + (v * (ceilingSize - floorSize));
	scalePhoto.style.width = (v*width)+"px";
	$('scale').value = v;
	$('offset_x').value = scalePhoto.style.left;
	$('offset_y').value = scalePhoto.style.top;
	$('photo_submit').value = "Crop, scale and save photo";
}

function prepSlider(handle_div, track_div, size_w) {
	var testSlider = new Control.Slider(handle_div, track_div, 
      {	axis:'horizontal', 
		minimum: 0, 
		maximum:200, 
		alignX: 2, 
		increment: 2, 
		sliderValue: 1});

	testSlider.options.onSlide = function(v){scaleIt(v, size_w);};
	testSlider.options.onChange = function(v){scaleIt(v, size_w);};
}

function update_position_divs(photo_div) {
	var photo = document.getElementById(photo_div);
	$('offset_x').value = photo.style.left;
	$('offset_y').value = photo.style.top;
}