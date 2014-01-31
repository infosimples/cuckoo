module ApplicationHelper

  def generate_title
    title = controller_name.camelize
    title << " (#{action_name.camelize})" if action_name != 'index'
    title << ' - Cuckoo'
    title
  end

  def page_scope
    @page_scope ||= case
    when (controller_name.in? ['time_entries', 'timesheet', 'reports'])
      :timesheet
    when (controller_name.in? ['users', 'projects', 'tasks'])
      :settings
    end
  end

  def warning
    flash[:warning]
  end

  def info
    flash[:info]
  end

  def today_date (date = Time.zone.now)
    { year: date.year, month: date.month, day: date.day }
  end

end
