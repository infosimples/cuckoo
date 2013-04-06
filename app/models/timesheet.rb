class Timesheet

  def initialize(user)
    @user = user
  end

  def week_hours(week_day = Time.zone.now)
    # TODO: needs refactoring!

    range = week_day.all_week
    day   = range.first
    hsh   = {}

    begin
      hsh[day] = day_hours(day)
      day += 1.day
    end while day <= range.last

    hsh

  end

  def day_hours(day)
    TimeEntry.for_user(@user).for_day(day).sum(:time_total)
  end

  def day_entries(day = Time.zone.now)
    TimeEntry.for_user(@user).for_day(day).all
  end

end