class Report

  def initialize(user)
    @user = user
  end

  def week_summary(date = Time.current.to_date)

    week_begin = date.at_beginning_of_week.at_midnight.gmtime
    week_end = date.at_end_of_week.at_midnight.gmtime
    entries = TimeEntry.where(user_id: @user.id)
                      .where('started_at >= ? AND started_at < ?', week_begin, week_end)
                      .includes(:project, :task)

    time_summary = {}
    entries.each do |time_entry|
      project = time_entry.project.name
      task = time_entry.task.name

      if (time_summary[project].nil?)
        time_summary[project] = {}
        time_summary[project][:total] = 0
        time_summary[project][:tasks] = {}
      end

      if (time_summary[project][:tasks][task].nil?)
        time_summary[project][:tasks][task] = 0
      end

      if (!time_entry.total_time.nil?)
        time_summary[project][:total] += time_entry.total_time
        time_summary[project][:tasks][task] += time_entry.total_time
      end

    end

    {
      date: date,
      weekdays: week_days(date),
      week_hours: week_hours(date),
      time_summary: time_summary
    }

  end

  def day_summary(date = Time.current.to_date)
    {
      date: date,
      weekdays: week_days(date),
      week_hours: week_hours(date),
      day_entries: day_entries(date)
    }
  end

  def week_hours(date = Time.current.to_date)
    Timesheet.new(@user).week_hours(date)
  end

  def week_days(date = Time.current.to_date)
    (date.at_beginning_of_week..date.at_end_of_week)
  end

  def day_entries(date = Time.current.to_date)
    Timesheet.new(@user).day_entries(date)
  end


end