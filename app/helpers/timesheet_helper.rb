module TimesheetHelper

  def stop_button(time_entry)
    css_class = 'btn btn-warning btn-small stop-button'
    if time_entry.persisted?
      link_to 'Stop', time_entry_finish_path(time_entry.id),
                      method: :patch, remote: true, class: css_class
    else
      link_to 'Stop', '#', method: :patch, remote: true, class: css_class
    end
  end

  def timer_duration(time_entry)
    if time_entry.ended_at.present?
      time_entry.ended_at - time_entry.started_at
    elsif time_entry.started_at.present?
      Time.zone.now - time_entry.started_at
    else
      0
    end.ceil
  end

  def hours_and_minutes(seconds)
    if seconds.is_a?(Fixnum)
      minutes = seconds/60
      hours   = minutes/60

      return "#{hours.to_s.rjust(2, '0')}:#{(minutes % 60).to_s.rjust(2, '0')}"
    end
  end

  def format_datetime(datetime)
    datetime.strftime("%H:%M")
  end

end