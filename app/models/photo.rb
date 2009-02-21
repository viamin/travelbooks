# == Schema Information
# Schema version: 20090214004612
#
# Table name: photos
#
#  id           :integer         not null, primary key
#  path         :string(255)     not null
#  file_name    :string(255)     not null
#  url          :string(255)     not null
#  content_type :string(255)     not null
#  bytes        :integer
#  width        :integer
#  height       :integer
#  caption      :string(255)     not null
#  photo_type   :integer
#  location_id  :integer
#  person_id    :integer
#  item_id      :integer
#  created_on   :date
#

# photo_type should be able to indicate if the photo is the primary photo for the given item/person/location
class Photo < ActiveRecord::Base
  belongs_to :person
  belongs_to :item
  belongs_to :location
  has_many :data, :dependent => :destroy
  validates_length_of :path, :maximum => 250
  validates_length_of :file_name, :maximum => 250
  validates_length_of :url, :maximum => 250
  validates_length_of :content_type, :maximum => 250
  validates_length_of :caption, :maximum => 250
  
  # photo_types
  MAIN = 1
  PERSON = 2
  ITEM = 3
  LOCATION = 4
  
  IMAGE_ROOT = "#{SHARED_ROOT}/public/images"
  
  TYPE_BASE_PATH = {
    2 => "#{IMAGE_ROOT}/users",
    3 => "#{IMAGE_ROOT}/books"
  }
  
  FORMATS = Magick.formats.keys.collect {|t| t.downcase }
        
  # Thumbnail sizes
  THUMB = {18  => 25,  # for icons on maps
           36  => 50,  # for books on home page
           80  => 120, # for friends on home page
           240 => 360} # Currently regular size
  
#  def initialize(*params)
#    super(*params)
#    if self.new_record?
#      self.path = String.new
#      self.file_name = String.new
#      self.url = String.new
#      self.content_type = String.new
#      self.caption = String.new
#    end
#  end

  def thumb_url(size = 80)
    if self.person_id.nil?
      if self.item_id.nil?
        # Location photo, which currently has no thumbnail
        self.url
      else
        if File.exists?(self.thumb_path(size))
          "/images/books/#{size}/#{self.file_name}"
        else
          self.url
        end
      end
    else
      if File.exists?(self.thumb_path(size))
        "/images/users/#{self.person.email}/#{size}/#{self.file_name}"
      else
        self.url
      end
    end
  end
  
  def thumb_path(size = 80)
    if size == 0
      return self.path
    end
    if self.person_id.nil?
      if self.item_id.nil?
        # Location photo, which currently has no thumbnail
        nil
      else
        FileUtils.touch("#{IMAGE_ROOT}/books/#{size}/#{self.file_name}")
        "#{IMAGE_ROOT}/books/#{size}/#{self.file_name}"
      end
    else
      FileUtils.touch("#{IMAGE_ROOT}/users/#{self.person.email}/#{size}/#{self.file_name}")
      "#{IMAGE_ROOT}/users/#{self.person.email}/#{size}/#{self.file_name}"
    end
  end

  def person
    Person.find(:first, :conditions => {:id => self.person_id})
  end
  
  def item
    Item.find(:first, :conditions => {:id => self.item_id})
  end
  
  def is_primary
    return (self.photo_type == Photo::MAIN)
  end
  
  def make_primary_for_person(person)
    person.photos.each do |photo| 
      photo.photo_type = Photo::PERSON 
      photo.save 
    end
    self.photo_type = Photo::MAIN
    self.save!
  end
  
  def make_primary_for_item(item)
    item.photos.each do |photo|
      photo.photo_type = Photo::ITEM
      photo.save
    end
    self.photo_type = Photo::MAIN
    self.save!
  end
  
  def make_primary_for_location(location)
    location.photos.each do |photo|
      photo.photo_type = Photo::LOCATION
      photo.save
    end
    self.photo_type = Photo::MAIN
    self.save!
  end
  
  def self.default
    temp = Photo.new
    temp.path = '/images/'
    temp.file_name = 'no_image.png'
    temp.url = 'no_image.png'
    temp.width = 200
    temp.height = 200
    temp
  end
  
  def self.save_temp(photo_params)
    data = photo_params['data']
    filename = "#{Dir.tmpdir}/temp_photo#{rand(1000)}"
    filepath = filename
    tf = File.new(filename, "w")
    filename =  tf.path.sub(Dir.tmpdir.concat("/"), "")
    tf.write data.read
    tf.close
    File.chmod(0664, filepath)
    photo = Photo.new
    photo.caption = photo_params['caption']
    photo.url = "/images/tmp/#{filename}"
    photo.path = tf.path
    photo.file_name = filename
    photo.width = Image.read(tf.path).first.columns
    photo.height = Image.read(tf.path).first.rows
    return photo
  end
  
  def self.save(photo_params, person)
    data = Magick::Image.read("#{Dir.tmpdir}/#{photo_params[:file_name]}").first
    data = data.resize(photo_params[:scale].to_f) unless photo_params[:scale].to_f == 0
    data = data.crop(photo_params[:offset_x].to_f.abs, photo_params[:offset_y].to_f.abs, 240, 360, true) unless (photo_params[:offset_x].to_f == 0 && photo_params[:offset_y].to_f == 0)
    short_name = Photo.change_extension(photo_params[:file_name], 'jpg')
    filename = "#{IMAGE_ROOT}/users/#{person.email}/#{short_name}"
    if File.exist?(filename)
      #flash[:error] = "That filename has already been used"
      timing "filename already used - not saving"
    else
      unless File.exist?("#{IMAGE_ROOT}/users/#{person.email}")
        Dir.mkdir("#{IMAGE_ROOT}/users/#{person.email}")
      end
      file_name = Photo.save_data(data, person, short_name)
      photo = Photo.new
      photo.path = filename
      photo.caption = photo_params[:caption]
      photo.file_name = file_name
      photo.photo_type = Photo::PERSON
      photo.width = data.columns
      photo.height = data.rows
      photo.person_id = person.id
      photo.content_type = data.mime_type
      photo.bytes = data.filesize
      photo.url = "/images/users/#{person.email}/#{short_name}"
      photo.save!
      photo.create_thumbnails
      File.delete("#{Dir.tmpdir}/#{photo_params[:file_name]}") if File.exist?("#{Dir.tmpdir}/#{photo_params[:file_name]}")
      #flash[:notice] = "Uploaded #{photo_params['file_name']}"
      #timing "Uploaded #{photo_params['file_name']}"
    end
    # database method
    # not implemented yet
    # see http://wiki.rubyonrails.org/rails/pages/HowtoUploadFiles
  end
  
  # Figure out what kind of photo it is and then make thumbnails
  def create_thumbnails
    # Currently there are only 2 kinds of photos: people and items
    if self.person_id.nil?
      if self.item_id.nil?
        # must be a location photo - do nothing for now
      else
        self.create_book_thumbnails
      end
    else
      self.create_person_thumbnails
    end
  end
  
  def verify_thumbnails
    # Currently there are only 2 kinds of photos: people and items
    if self.person_id.nil?
      if self.item_id.nil?
        # must be a location photo - do nothing for now
      else
        # item photo
        self.check_thumbnails([18,36])
      end
    else
      # person photo
      self.check_thumbnails([18,80])
    end
  end
  
  def check_thumbnails(sizes = [18,36,80])
    if File.exists?(self.path)
      data = Magick::Image.read(self.path).first
    elsif File.exists?("#{SHARED_ROOT}/#{self.url}")
      data = Magick::Image.read("#{SHARED_ROOT}/#{self.url}").first
    elsif File.exists?("#{self.path}.png")
      data = Magick::Image.read("#{self.path}.png").first
      self.path = "#{self.path}.png" unless self.path.end_with?('.png')
      self.file_name = "#{self.file_name}.png" unless self.file_name.end_with?('.png')
      self.save!
    elsif File.exists?("#{self.path}.jpg")
      data = Magick::Image.read("#{self.path}.jpg").first
      self.path = "#{self.path}.jpg" unless self.path.end_with?('.jpg')
      self.file_name = "#{self.file_name}.jpg" unless self.file_name.end_with?('.jpg')
      self.save!
    else
      RAILS_DEFAULT_LOGGER.warn "File not found - aborting thumbnail verification"
      return
    end
    # first check regular size  SKIP since book images don't have to be that size
#    if (data.columns == 240 && data.rows == Photo::THUMB[240])
      # Photos are correct aspect ratio and can be resized safely
      sizes.each do |size|
        path_to_thumb = self.thumb_path(size)
        data = Magick::Image.read(path_to_thumb).first if File.size?(path_to_thumb)
        if data.nil?
          self.regen_thumb(size)
        else
#          timing "#{path_to_thumb}: #{data.columns}x#{data.rows}"
          unless (data.columns == size && data.rows == Photo::THUMB[size])
            self.regen_thumb(size)
          end
        end
      end
#    else
#      timing "Photo main size was wrong for #{self.path}"
#      self.resize(data, 240) # this will mess up photos that were cropped small
#    end
  end
  
  def regen_thumb(size = 0)
    timing "Regenerating #{self.path} for size: #{size}"
    path_to_thumb = self.thumb_path(size)
    File.unlink(path_to_thumb) if File.exists?(path_to_thumb)
    data = Magick::Image.read(self.path).first
    if self.person_id.nil?
      if self.item_id.nil?
        # must be a location photo - do nothing for now
      else
        # item photo
        Photo.save_book_data(data, self.file_name, size)
      end
    else
      # person photo
      Photo.save_data(data, self.person, self.file_name, size)
    end
  end
  
  # resize should only be used with photos of the expected aspect ratio
  def resize(photo, size, path)
    data.scale!(size, Photo::THUMB[size])
    # TBD : write out the file to the right place
    file = File.new(path, "rw")
    data.write(file)
    file.close
  end
  
  def create_person_thumbnails
    if self.url == "db"
      # figure this out later
    else
      if File.exists?(self.path)
        data = Magick::Image.read(self.path).first
      elsif File.exists?("#{SHARED_ROOT}/#{self.url}")
        data = Magick::Image.read("#{SHARED_ROOT}/#{self.url}").first
      else
        RAILS_DEFAULT_LOGGER.warn "File not found - aborting thumbnail creation"
        return
      end
      Photo.save_data(data, self.person, self.file_name, 80)
#      Photo.save_data(data, self.person, self.file_name, 36)
      Photo.save_data(data, self.person, self.file_name, 18)
    end
  end
  
  def create_book_thumbnails
    if self.url == "db"
      # figure this out later
    else
      if File.exists?(self.path)
        data = Magick::Image.read(self.path).first
      elsif File.exists?("#{SHARED_ROOT}/#{self.url}")
        data = Magick::Image.read("#{SHARED_ROOT}/#{self.url}").first
      else
        RAILS_DEFAULT_LOGGER.warn "File not found - aborting book thumbnail creation"
        return
      end
#      Photo.save_book_data(data, self.person, self.file_name, 80)
      Photo.save_book_data(data, self.file_name, 36)
      Photo.save_book_data(data, self.file_name, 18)
    end
  end
  
  def self.save_book_data(data, file_name, size = false)
     if [18, 36, 80].include?(size)
       filename = "#{IMAGE_ROOT}/books/#{size}/#{file_name}"
     else
       filename = "#{IMAGE_ROOT}/books/#{file_name}"
     end
     if File.exists?(filename)
       timing "Thumbnail for #{file_name} exists for size #{size}"
     else
       unless File.exists?("#{IMAGE_ROOT}/books/#{size}/")
         Dir.mkdir("#{IMAGE_ROOT}/books/#{size}/")
       end
       data.scale!(size, Photo::THUMB[size])
       tf = File.new(filename, "w")
       data.write(tf)
       tf.close
     end
     File.chmod(0664, filename)
     return filename
   end
  
  def self.save_data(data, person, filename, size = false)
    if [18, 36, 80].include?(size)
      fname = "#{IMAGE_ROOT}/users/#{person.email}/#{size}/#{filename}"
    else
      fname = "#{IMAGE_ROOT}/users/#{person.email}/#{filename}"
    end
    fname = Photo.change_extension(fname, 'png') unless (fname.end_with?('.jpg') && !([18,36,80].include?(size)))
    if File.exists?(fname)
      timing "Thumbnail for file_name exists for size #{size}"
    else
      unless File.exists?("#{IMAGE_ROOT}/users/#{person.email}/")
        Dir.mkdir("#{IMAGE_ROOT}/users/#{person.email}/")
      end
      unless File.exists?("#{IMAGE_ROOT}/users/#{person.email}/#{size}/")
        Dir.mkdir("#{IMAGE_ROOT}/users/#{person.email}/#{size}/")
      end
      data.scale!(size, Photo::THUMB[size])
      f = File.new(fname, "wb")
      data.write(f) { self.quality = 50 }
      f.close
    end
    File.chmod(0664, fname)
    return fname
  end
  
  def self.change_extension(file_name, extension)
    ex = file_name.split('.')
    if ex.length == 1
      return "#{file_name}.#{extension}"
    else
      if FORMATS.include?(ex.last.downcase)
        return [ex[0..-2], extension].flatten.join('.')
      else
        return [ex, extension].flatten.join('.')
      end
    end
  end
  
end
