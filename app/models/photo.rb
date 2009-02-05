# == Schema Information
# Schema version: 37
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
    data = Image.read("#{Dir.tmpdir}/#{photo_params[:file_name]}").first
    data = data.resize(photo_params[:scale].to_f) unless photo_params[:scale].to_f == 0
    data = data.crop(photo_params[:offset_x].to_f.abs, photo_params[:offset_y].to_f.abs, 240, 360, true) unless (photo_params[:offset_x].to_f == 0 && photo_params[:offset_y].to_f == 0)
    filename = "#{RAILS_ROOT}/public/images/users/#{person.email}/#{photo_params[:file_name]}"
    if File.exist?(filename)
      #flash[:error] = "That filename has already been used"
#      timing "filename already used - not saving"
    else
      
      #### FIX THIS - RAILS_ROOT points to releases/<date>, not current/
      unless File.exist?("#{RAILS_ROOT}/public/images/users/#{person.email}")
        Dir.mkdir("#{RAILS_ROOT}/public/images/users/#{person.email}")
      end
      f = File.new(filename, "wb")
      data.write(f)
      f.close
      File.chmod(0664, filename)
      photo = Photo.new
      photo.path = filename
      photo.caption = photo_params[:caption]
      photo.file_name = photo_params[:file_name]
      photo.photo_type = Photo::PERSON
      photo.width = data.columns
      photo.height = data.rows
      photo.person_id = person.id
      photo.content_type = data.mime_type
      photo.bytes = data.filesize
      photo.url = "/images/users/#{person.email}/#{photo_params[:file_name]}"
      photo.save!
      File.delete("#{Dir.tmpdir}/#{photo_params[:file_name]}") if File.exist?("#{Dir.tmpdir}/#{photo_params[:file_name]}")
      #flash[:notice] = "Uploaded #{photo_params['file_name']}"
      #timing "Uploaded #{photo_params['file_name']}"
    end
    # database method
    # not implemented yet
    # see http://wiki.rubyonrails.org/rails/pages/HowtoUploadFiles
  end
  
end
