#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w
require 'RMagick'

# Demonstrate the crop_resize method

img = Magick::Image.read('images/Flower_Hat.jpg')[0]
thumbnail = img.resize_to_fit(76, 76)
thumbnail.write("resize_to_fit.jpg")


