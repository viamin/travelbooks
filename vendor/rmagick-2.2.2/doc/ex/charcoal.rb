#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w
require 'RMagick'

# Demonstrate the Image#charcoal method

img = Magick::Image.read('images/Flower_Hat.jpg').first

img = img.charcoal(0.75)

img.write('charcoal.jpg')

exit
