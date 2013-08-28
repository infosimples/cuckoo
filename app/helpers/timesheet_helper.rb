module TimesheetHelper

  def start_button(time_entry, css_class = '')
    css_class = "btn btn-inverse btn-small #{css_class}".strip
    hsh = {
      time_entry: {
        project_id: time_entry.project_id,
        task_id: time_entry.task_id,
        description: time_entry.description
      }
    }
    link_to 'Start', time_entries_path(today_date.merge(hsh)), method: :post, class: css_class
  end

  def stop_button(time_entry)
    css_class = 'btn btn-warning btn-small stop-button'
    link_to 'Stop', time_entry_finish_path(time_entry.id, { time_entry: { ended_at: '' } }),
                                           method: :patch, class: css_class
  end

  def timer_data_id(time_entry)
    if time_entry.ended_at.present?
      time_entry.ended_at - time_entry.started_at
    else
      Time.zone.now - time_entry.started_at
    end.ceil
  end

  def hours_and_minutes(seconds)
    if seconds.is_a?(Fixnum)
      minutes = seconds/60
      hours   = minutes/60

      return "#{hours.to_s.rjust(2, '0')}:#{(minutes % 60).to_s.rjust(2, '0')}"
    end
  end

end