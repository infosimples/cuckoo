class TimeEntry < ActiveRecord::Base

  attr_accessor :entry_date, :start_time, :end_time

  scope :for_user, lambda { |user| where(user_id: user.id) }
  scope :for_day, (lambda do |day|
                            at_gmtime = day.at_midnight.gmtime
                            where('started_at >= ? AND started_at < ?',
                                  at_gmtime,
                                  at_gmtime.tomorrow).order('started_at')
                          end)

  belongs_to :user
  belongs_to :project
  belongs_to :task

  validates_presence_of :project, :task, :started_at
  validates_inclusion_of :is_billable, in: [true, false]
  validate :start_and_end_are_in_order

  before_validation :set_time_parameters
  before_save :update_total_time
  before_create :test_on_create

  def stop
    update_attribute(:ended_at, Time.zone.now)
  end

  private

  def set_time_parameters
    if entry_date
      self.started_at = (start_time.present? ? Time.zone.parse("#{entry_date} #{start_time}") : nil)
      self.ended_at   = (end_time.present? ? Time.zone.parse("#{entry_date} #{end_time}") : nil)
    end
  end

  def start_and_end_are_in_order
    unless !ended_at || started_at && ended_at >= started_at
      errors.add(:base, :start_and_end_must_be_in_order)
    end
  end

  def update_total_time
    if started_at && ended_at
      self.total_time = ended_at - started_at
    end
  end

  def test_on_create
    if start_time.blank?
      errors.add(:base, :start_time_blank)
    end
  end

end
