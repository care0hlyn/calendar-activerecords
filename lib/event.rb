class Event < ActiveRecord::Base
  ActiveRecord::Base.default_timezone = :local
  validates :description, :presence => true
  validates :location, :presence => true
  validates :start, :presence => true
  validates :end, :presence => true

  before_save :validates_start_end_dates

  def validates_start_end_dates
    false if self.start > self.end
    false if self.start < Time.now
  end

end




