#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -w
require 'RMagick'

# Demonstrate the Image#normalize method

img = Magick::Image.read('images/Hot_Air_Balloons.jpg').first

img = img.normalize

img.write('normalize.jpg')
exit
