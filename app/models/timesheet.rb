class Timesheet

  def initialize(user)
    @user = user
  end

  def week_hours(day = Time.zone.now)
    day  = day.to_date
    week = (day.at_beginning_of_week..day.at_end_of_week)

    week.map { |weekday| { weekday.day => day_time(weekday) } }.reduce(:merge)
  end

  def day_time(day)
    TimeEntry.for_user(@user).for_day(day).sum(:total_time)
  end

  def day_entries(day = Time.zone.now)
    TimeEntry.for_user(@user).for_day(day)
  end

end