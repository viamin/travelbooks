# == Schema Information
# Schema version: 36
#
# Table name: statistics
#
#  id            :integer         not null, primary key
#  person_id     :integer
#  item_id       :integer
#  location_id   :integer
#  stat_type     :integer
#  key           :string(255)
#  value         :string(255)
#  related_stats :string(255)
#

class Statistic < ActiveRecord::Base
  belongs_to :person
  belongs_to :item
  belongs_to :location
  before_save :marshal_stats
  
  attr_accessor :related_statistics
  
  def marshal_stats
    self.related_stats = Marshal.dump(@related_statistics)
  end
  
  def after_find
    @related_statistics = Marshal.load(self.related_stats)
  end
  
  def initialize(*params)
    super(*params)
    if self.new_record?
      self.related_statistics = Array.new
    end
  end
  
  ############### TYPES ##############
  MILEAGE = 0
  AVERAGE_RATING = 1
  COUNTRIES_VISITED_COUNT = 2
  COUNTRIES_BOOKS_VISITED = 3
  MILES_BOOKS_GIVEN_TRAVELLED = 4
  MILES_LAST_BOOK_RECEIVED_TRAVELLED = 5
  
  
end
