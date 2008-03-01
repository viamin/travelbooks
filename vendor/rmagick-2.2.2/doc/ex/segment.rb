#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w
require 'RMagick'

# Demonstrate the Image#segment method.

img = Magick::Image.read('images/Flower_Hat.jpg').first

img = img.segment(Magick::YUVColorspace, 0.4, 0.4)

img.write('segment.jpg')
exit
