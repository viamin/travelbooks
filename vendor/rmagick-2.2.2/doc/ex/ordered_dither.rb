#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w
require 'RMagick'

# Demonstrate the Image#ordered_dither method

img = Magick::Image.read('images/Flower_Hat.jpg').first

img = img.ordered_dither

img.write('ordered_dither.jpg')
exit
