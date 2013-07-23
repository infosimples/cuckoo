module TimeEntriesHelper

  def all_projects
    Project.all
  end

  def all_tasks
    Task.all
  end

  #
  # `arg` should be one of :day, :month or :year
  #
  def get_date_component(time_entry, arg)
    arg = arg.to_sym
    time_entry.persisted? ? time_entry.started_at.send(arg) : params[arg]
  end

end