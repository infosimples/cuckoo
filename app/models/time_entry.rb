class TimeEntry < ActiveRecord::Base

  before_save :update_time_total

  belongs_to :user
  belongs_to :project
  belongs_to :task

  # TODO: include user
  validates_presence_of :project, :task, :started_at
  validate :start_and_end_are_same_day, :start_and_end_are_in_order

  scope :for_user, lambda { |user| where(user_id: user.id ) }
  scope :for_day, lambda { |day| where('DATE(started_at) = ?', day.to_date) }

  private

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

end
