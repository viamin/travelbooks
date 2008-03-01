#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w
require 'RMagick'

# Demonstrate the Image#raise method.
img = Magick::Image.read('images/Flower_Hat.jpg').first
img = img.raise
img.write('raise.jpg')
exit
