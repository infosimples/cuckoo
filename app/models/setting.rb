class Setting < ActiveRecord::Base

  store :settings, accessors: [ :time_zone ]

  after_initialize do
    self.time_zone ||= 'Brasilia'
  end
end
