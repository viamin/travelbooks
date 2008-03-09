// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// "Borrowed" from http://www.agilepartners.com/blog/2005/12/07/iphoto-image-resizing-using-javascript/
function scaleIt(v, width, height) {
	var scalePhoto = document.getElementById("photo_block");

	// Remap the 0-1 scale to fit the desired range
	floorSize = Math.max((240 / width), (360 / height));
	ceilingSize = 1.0;
	v = floorSize + (v * (ceilingSize - floorSize));
	scalePhoto.style.width = (v*width)+"px";
	scalePhoto.style.height = (v*height)+"px";
	$('scale').value = v;
	checkPos("photo_block");
	$('photo_submit').value = "Crop, scale and save photo";
}

function checkPos(photo_div) {
	var photo = document.getElementById(photo_div);
	minLeft = 240 - parseInt(photo.style.width);
	maxLeft = 0;
	minTop = 360 - parseInt(photo.style.height);
	maxTop = 0;
	if (parseInt(photo.style.left) < minLeft) {
		photo.style.left = minLeft+"px";
	}
	if (parseInt(photo.style.left) > maxLeft) {
		photo.style.left = maxLeft+"px";
	}
	if (parseInt(photo.style.top) < minTop) {
		photo.style.top = minTop+"px";
	}
	if (parseInt(photo.style.top) > maxTop) {
		photo.style.top = maxTop+"px";
	}
	update_position_divs(photo_div);
}

function prepSlider(handle_div, track_div, size_w, size_h) {
	var testSlider = new Control.Slider(handle_div, track_div, 
      {	axis:'horizontal', 
		minimum: 0, 
		maximum:200, 
		alignX: 2, 
		increment: 2, 
		sliderValue: 1});

	testSlider.options.onSlide = function(v){scaleIt(v, size_w, size_h);};
	testSlider.options.onChange = function(v){scaleIt(v, size_w, size_h);};
}

function update_position_divs(photo_div) {
	var photo = document.getElementById(photo_div);
	$('offset_x').value = parseInt(photo.style.left);
	$('offset_y').value = parseInt(photo.style.top);
}

function stretchImage(caller, photo_div, orig_width, orig_height) {
	var photo = document.getElementById(photo_div);
//	alert("caller.value = "+$(caller).value);
//	alert("caller.value.checked == yes: "+(document.getElementById(caller).checked == true));
	if (document.getElementById(caller).checked == true) {
		photo.style.width = "240px";
		photo.style.height = "360px";
		photo.style.top = 0;
		photo.style.left = 0;
		scaler = max((360/parseInt(orig_height)), (240/parseInt(orig_width)));
		$('scale').value = scaler;
	} else {
		photo.style.width = orig_width+"px";
		photo.style.height = orig_height+"px";
		photo.style.top = 0;
		photo.style.left = 0;
		$('scale').value = 1.0;
		scaleIt(1.0, orig_width, orig_height);
	}
	$('offset_x').value = 0;
	$('offset_y').value = 0;
}