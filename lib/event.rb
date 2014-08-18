class Event < ActiveRecord::Base
  validates :description, :presence => true
  validates :location, :presence => true
  validates :start, :presence => true
  validates :end, :presence => true

end
