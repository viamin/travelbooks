#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w
require 'RMagick'

# Demonstrate the Image#negate_channel method

img = Magick::Image.read('images/Flower_Hat.jpg').first
result = img.negate_channel(false, Magick::GreenChannel)
result.write('negate_channel.jpg')
exit
