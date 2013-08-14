class Setting < ActiveRecord::Base

  store :settings, accessors: [ :time_zone ]

  after_save :setup_time_zone

  def setup_time_zone
    Time.zone = self.time_zone
  end

end
