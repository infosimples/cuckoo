class Setting < ActiveRecord::Base

  store :settings, accessors: [ :time_zone ]

  after_save :setup_time_zone

  after_initialize do
    self.time_zone ||= 'Brasilia' # Default time zone
  end

  def setup_time_zone
    Rails.application.config.time_zone = self.time_zone
    Time.zone = self.time_zone
  end

end
