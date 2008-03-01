#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w

require 'RMagick'

img = Magick::Image.read('images/Flower_Hat.jpg').first
result = img.posterize
result.write('posterize.jpg')
exit
