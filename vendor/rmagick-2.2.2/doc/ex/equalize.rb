#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w
require 'RMagick'

# Demonstrate the Image#equalize method

img = Magick::Image.read('images/Flower_Hat.jpg').first

img = img.equalize

img.write('equalize.jpg')
exit
