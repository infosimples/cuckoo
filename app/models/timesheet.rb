class Timesheet

  attr_reader :user, :date, :day_entries, :weekdays, :week_summary

  def initialize(args)
    @user = User.find_by_id(args[:user_id])
    @date = parse_to_date(args[:day], args[:month], args[:year])
    @day_entries = day_entries_for(@date)
    @weekdays = (@date.at_beginning_of_week..@date.at_end_of_week)
    @week_summary = week_hours(@weekdays)
  end

  def day_entries_for(day)
    TimeEntry.for_user(@user).for_day(day)
  end

  def week_hours(weekdays)
    weekdays.map { |weekday| { weekday.day => day_entries_for(weekday).sum(:total_time) } }.reduce(:merge)
  end

  def parse_to_date(day, month, year)
    Time.zone.parse("#{year}-#{month}-#{day}").to_date
  end

end