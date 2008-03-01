#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w
require 'RMagick'

# Demonstrate the Image#transpose method

img = Magick::Image.read('images/Flower_Hat.jpg').first
img = img.transpose
img.write('transpose.jpg')
exit
