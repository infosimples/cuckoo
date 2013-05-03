module TimesheetHelper

  def start_button(time_entry, css_class='')
    css_class = "btn btn-inverse btn-small #{css_class}".strip
    hsh = {
      time_entry: {
        project_id: time_entry.project_id,
        task_id: time_entry.task_id,
        description: time_entry.description
      }
    }
    link_to 'Start', time_entries_path(today_date.merge(hsh)), method: 'POST', class: css_class
  end

end