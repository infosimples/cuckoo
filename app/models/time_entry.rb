class TimeEntry < ActiveRecord::Base

  attr_accessor :entry_date, :start_time, :end_time

  scope :for_user, lambda { |user| where(user_id: user.id) }
  scope :for_day, lambda { |day| where('started_at > ? AND started_at < ?', day, day.tomorrow).order('started_at') }

  belongs_to :user
  belongs_to :project
  belongs_to :task

  validates_presence_of :project, :task, :started_at
  validate :start_and_end_are_same_day, :start_and_end_are_in_order, :entries_that_dont_start_today_must_have_start_and_end

  after_initialize :set_time_parameters

  before_validation  :set_parameters
  before_save :update_time_total
  before_create :stop_timers

  private

  def set_time_parameters
    if entry_date
      self.started_at = Time.zone.parse("#{entry_date} #{start_time}")
      self.ended_at   = Time.zone.parse("#{entry_date} #{end_time}")
    end
  end

  def start_and_end_are_same_day
    unless !ended_at || started_at && started_at.to_date == ended_at.to_date
      errors.add(:base, :start_and_end_must_be_same_day)
    end
  end

  def start_and_end_are_in_order
    unless !ended_at || started_at && ended_at >= started_at
      errors.add(:base, :start_and_end_must_be_in_order)
    end
  end

  def update_time_total
    if started_at && ended_at
      self.time_total = ended_at - started_at
    end
  end

  def entries_that_dont_start_today_must_have_start_and_end
    if (date = Time.zone.parse(entry_date)) && date.to_date != Time.zone.now.to_date && (start_time.empty? || end_time.empty?)
      errors.add(:base, :entries_that_dont_start_today_must_have_start_and_end)
    end
  end

  def set_parameters
    if (date = Time.zone.parse(entry_date)) && date.to_date == Time.zone.now.to_date
      self.started_at = Time.zone.now if start_time.blank?
      self.ended_at = nil if end_time.blank?
    end


  end

  def stop_timers
    TimeEntry.update_all({ ended_at: Time.zone.now }, { ended_at: nil, user_id: self.user_id })
  end
end
