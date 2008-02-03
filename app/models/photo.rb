# == Schema Information
# Schema version: 22
#
# Table name: photos
#
#  id           :integer         not null, primary key
#  path         :string(255)     not null
#  file_name    :string(255)     not null
#  url          :string(255)     not null
#  data         :binary          
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
  
  # photo_types
  MAIN = 1
  PERSON = 2
  ITEM = 3
  LOCATION = 4
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.path = String.new
      self.file_name = String.new
      self.url = String.new
      self.content_type = String.new
      self.caption = String.new
    end
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
    timing data.pretty_inspect
    photo_params.delete :is_primary
    tf = Tempfile.new('temp_photo')
    filename =  tf.path.sub(Dir.tmpdir.concat("/"), "")
    tf.write data.read
    tf.close
    timing `file #{tf.path}`
    photo = Photo.new(photo_params)
    photo.url = "/images/tmp/#{filename}"
    photo.path = tf.path
    photo.file_name = filename
    maxheight = 600
    maxwidth = 600
    aspectratio = 80.0 / 120.0
    img = Image.read(tf.path).first
    imgwidth = img.columns
    imgheight = img.rows
    imgratio = imgwidth.to_f / imgheight.to_f
    imgratio > aspectratio ? scaleratio = maxwidth.to_f / imgwidth : scaleratio = maxheight.to_f / imgheight
    tf.open
    tf.truncate(0)
    tf.write img.resize(scaleratio).to_blob
    tf.close
    photo.width = Image.read(tf.path).first.columns
    return photo
  end
  
  def self.save(photo_params, person)
    data = Image.read("#{Dir.tmpdir}/#{photo_params[:file_name]}").first
    data.resize!(photo_params[:scale].to_f)
    data.crop!(photo_params[:offset_x], params[:offest_y], 240, 360, true)
    filename = "public/images/#{person.email}/#{data.original_filename}"
    if File.exist?(filename)
      #flash[:error] = "That filename has already been used"
      timing "filename already used - not saving"
    else
      unless File.exist?("public/images/#{person.email}")
        Dir.mkdir("public/images/#{person.email}")
      end
      f = File.new(filename, "wb")
      f.write data.to_blob
      f.close
      photo = Photo.new
      photo.path = filename
      photo.caption = photo_params['caption']
      photo.file_name = data.original_filename
      photo.person_id = person.id
      photo.content_type = data.content_type
      photo.bytes = data.length
      photo.url = "#{person.email}/#{data.original_filename}"
      photo.save!
      #flash[:notice] = "Uploaded #{photo_params['file_name']}"
      timing "Uploaded #{photo_params['file_name']}"
    end
    # database method
    # not implemented yet
    # see http://wiki.rubyonrails.org/rails/pages/HowtoUploadFiles
  end
  
end
