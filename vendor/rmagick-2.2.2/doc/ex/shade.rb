#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w
require 'RMagick'

# Demonstrate Image#shade

img = Magick::Image.read('images/Flower_Hat.jpg').first

img = img.shade(true, 50, 50)

img.write('shade.jpg')
exit
