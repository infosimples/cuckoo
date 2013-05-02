class Setting < ActiveRecord::Base

  store :settings, accessors: [ :time_zone ]

  after_initialize do
    self.time_zone ||= 'Brasilia'
  end
  after_save do
    Time.zone = Setting.first.time_zone
  end
end
